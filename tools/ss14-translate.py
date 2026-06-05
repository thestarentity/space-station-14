#!/usr/bin/env python3
"""
ss14-translate.py — Translate SS14 .ftl files (en-US → pt-BR) using Ollama.

Requirements:  pip install fluent.syntax requests
               (or:  pip install -r tools/requirements.txt)

Usage examples
--------------
  # Dry-run on a small folder first — shows translations, writes nothing:
  python tools/ss14-translate.py --folder alert-levels --dry-run

  # Translate for real:
  python tools/ss14-translate.py --folder alert-levels

  # Single file:
  python tools/ss14-translate.py --file alert-levels/alert-levels.ftl

  # Verbose (shows every string sent to Ollama):
  python tools/ss14-translate.py --folder alert-levels --dry-run --verbose

Rules enforced
--------------
  * Only TextElement content is sent to translation.
  * Placeables { $x }, { FUNCTION(...) }, terms, messages → become ⟦N⟧ tokens.
  * SelectExpression variants are recursed into (plurals, genders, etc.).
  * Validation before writing: parse errors, key set changes, variable mismatches all abort.
  * Glossary (glossary.json) and translation memory (translation_memory.json) live in tools/.
"""

import argparse
import json
import logging
import re
import sys
from pathlib import Path

import requests
from fluent.syntax import FluentParser, FluentSerializer
from fluent.syntax import ast as F

# ── Logging ───────────────────────────────────────────────────────────────────
logging.basicConfig(level=logging.INFO, format="%(levelname)s  %(message)s")
log = logging.getLogger(__name__)

# ── Constants ─────────────────────────────────────────────────────────────────
OLLAMA_URL = "http://100.121.242.23:11434/api/chat"
MODEL = "qwen3:14b"
TIMEOUT = 120  # seconds per request

TOOLS_DIR = Path(__file__).parent
GLOSSARY_FILE = TOOLS_DIR / "glossary.json"
TM_FILE = TOOLS_DIR / "translation_memory.json"

TOKEN_RE = re.compile(r"⟦(\d+)⟧")
MAX_RETRIES = 2  # extra attempts after the first when a token is dropped

# ⟦N⟧ are "invisible tokens" — the model is told to treat them as untouchable markers.
SYSTEM_PROMPT = """\
You are a translator for Space Station 14 (SS14), a sci-fi multiplayer spaceship simulation \
game. Players are crew members aboard a space station working shifts, dealing with \
antagonists, and following space law. Translate English UI strings, item names, and \
descriptions into Brazilian Portuguese (pt-BR).

CONTEXT — use game meanings, NOT literal dictionary translations:
- "playtime" = tempo de jogo (NOT "tempo de brincadeira")
- "clipboard" = prancheta (the physical object, NOT "área de transferência")
- "round" = rodada (a game session, NOT "redondo")
- "shift" = turno (a work shift aboard the station, NOT "deslocar")
- "department" = departamento (a station department)
- "role" / "job" = cargo (a crew role, NOT "papel" or "emprego")
- "spawn" = spawn (game term, keep in English or use spawnar/spawn)
- "ahelp" = ahelp (admin help command, keep unchanged)
- "antag" / "antagonist" = antag / antagonista
- "lobby" = lobby (pre-game waiting area)
- "IC" / "OOC" = IC / OOC (In Character / Out of Character, keep unchanged)
- "metagaming", "griefing", "powergaming", "roleplay" = keep in English (gamer terms)
Prefer the term a Brazilian SS14 player would naturally use over a literal translation.

MANDATORY RULES — violations will be rejected automatically:
1. Tokens like ⟦0⟧ ⟦1⟧ ⟦2⟧ are UNTOUCHABLE placeholders. Preserve them EXACTLY in place.
   Never add, remove, move, split or translate them.
2. Use informal Brazilian Portuguese with "você" (not "tu").
3. Match the tone of the original (funny text → funny, urgent → urgent, formal → formal).
4. Keep proper nouns, brand names and UI labels consistent with the glossary.
5. Output ONLY the translated text. No explanations, markdown, or annotations.
6. If the input is only whitespace or tokens, output it unchanged.
{glossary_block}"""

# ── Default glossary (user should expand this) ────────────────────────────────
_DEFAULT_GLOSSARY = {
    "Space Station": "Estação Espacial",
    "Nanotrasen": "Nanotrasen",
    "Central Command": "Comando Central",
    "Captain": "Capitão",
    "Chief Medical Officer": "Chefe Médico",
    "Chief Engineer": "Engenheiro-Chefe",
    "Research Director": "Diretor de Pesquisa",
    "Head of Security": "Chefe de Segurança",
    "Head of Personnel": "Chefe de Pessoal",
    "Security Officer": "Oficial de Segurança",
    "Medical Doctor": "Médico",
    "Engineer": "Engenheiro",
    "Scientist": "Cientista",
    "Chemist": "Químico",
    "Botanist": "Botanista",
    "Janitor": "Zelador",
    "Clown": "Palhaço",
    "Mime": "Mímico",
    "Chef": "Chef",
    "Station": "Estação",
    "shuttle": "shuttle",
    "airlock": "airlock",
    "EVA": "EVA",
    "PDA": "PDA",
    "ID card": "cartão de identificação",
    "maintenance": "manutenção",
    "medbay": "enfermaria",
    "bridge": "ponte de comando",
    "crewmember": "tripulante",
    "crewmembers": "tripulantes",
    "head of staff": "chefe de departamento",
    "heads of staff": "chefes de departamento",
}

# ── Glossary & Translation Memory ────────────────────────────────────────────

def load_glossary() -> dict:
    if not GLOSSARY_FILE.exists():
        GLOSSARY_FILE.write_text(
            json.dumps(_DEFAULT_GLOSSARY, ensure_ascii=False, indent=2),
            encoding="utf-8",
        )
        log.info("Created default glossary → %s", GLOSSARY_FILE)
        log.info("  Edit it to add/fix game-specific terms before running on more files.")
    return json.loads(GLOSSARY_FILE.read_text(encoding="utf-8"))


def load_tm() -> dict:
    if TM_FILE.exists():
        return json.loads(TM_FILE.read_text(encoding="utf-8"))
    return {}


def save_tm(tm: dict) -> None:
    TM_FILE.write_text(json.dumps(tm, ensure_ascii=False, indent=2), encoding="utf-8")


# ── Ollama client ─────────────────────────────────────────────────────────────

def call_ollama(text: str, ctx: str, glossary: dict, tm: dict, hint: str = "") -> str:
    """
    Translate `text` to pt-BR.
    - hint: non-empty on retry; bypasses TM and prepends a correction instruction.
    """
    key = text.strip()
    if not key:
        return text

    # If the unit contains no alphabetic characters after stripping tokens and
    # [markup] tags, there is nothing to translate — return as-is without LLM call.
    _clean = re.sub(r"\[/?[^\]]*\]", "", TOKEN_RE.sub("", key))
    if not any(c.isalpha() for c in _clean):
        log.debug("  [no-translate] [%s] only tokens/markup — returning as-is", ctx)
        return text

    # TM lookup — skipped on retry so the model gets a fresh attempt
    if not hint and key in tm:
        log.debug("  TM ← [%s] %s", ctx, key[:60])
        return text.replace(key, tm[key], 1)

    gl_lines = "\n".join(f"  {en} → {pt}" for en, pt in glossary.items())
    gl_block = (
        f"\nGLOSSARY — use EXACTLY these translations for the listed terms:\n{gl_lines}"
        if gl_lines
        else ""
    )
    system = SYSTEM_PROMPT.format(glossary_block=gl_block)

    user_content = f"Context key: {ctx}\n\n{text}"
    if hint:
        user_content = f"Context key: {ctx}\n\n⚠️ RETRY — {hint}\n\n{text}"

    payload = {
        "model": MODEL,
        "think": False,
        "messages": [
            {"role": "system", "content": system},
            {"role": "user", "content": user_content},
        ],
        "stream": False,
        "options": {"temperature": 0.2},
    }

    log.debug("  LLM → [%s]%s %s", ctx, " (retry)" if hint else "", key[:70])

    last_exc: Exception | None = None
    for _attempt in range(2):  # one automatic retry on timeout
        try:
            resp = requests.post(OLLAMA_URL, json=payload, timeout=TIMEOUT)
            resp.raise_for_status()
            last_exc = None
            break
        except requests.exceptions.Timeout as exc:
            last_exc = exc
            log.warning("  [timeout] Ollama timed out for [%s], retrying...", ctx)
        except requests.RequestException as exc:
            raise RuntimeError(f"Ollama unreachable: {exc}") from exc
    if last_exc:
        raise RuntimeError(f"Ollama timed out twice for [{ctx}]") from last_exc

    raw = resp.json()["message"]["content"]
    translated = re.sub(r"<think>.*?</think>", "", raw, flags=re.DOTALL).strip()

    log.debug("  LLM ← [%s] %s", ctx, translated[:70])

    # Save to TM (stripped form → stripped form)
    tm[key] = translated.strip()
    return translated


# ── AST helpers — pattern translation ────────────────────────────────────────

def _translate_run(elements: list, translate_fn, ctx: str) -> None:
    """
    Translate a run of TextElements + non-Select Placeables in-place.

    Strategy:
      - Non-Select Placeables become ⟦N⟧ tokens in the unit sent to the LLM.
      - The LLM returns text with those tokens preserved.
      - Split on tokens → map pieces back to the original TextElements.
    """
    te_list: list[tuple[int, F.TextElement]] = []  # (index_in_unit_parts, element)
    unit_parts: list[str] = []
    token_count = 0

    for elem in elements:
        if isinstance(elem, F.TextElement):
            te_list.append((len(unit_parts), elem))
            unit_parts.append(elem.value)
        elif isinstance(elem, F.Placeable):
            unit_parts.append(f"⟦{token_count}⟧")
            token_count += 1

    if not te_list:
        return

    # Skip runs where every TextElement is pure whitespace/newlines
    has_real_text = any(elem.value.strip() for _, elem in te_list)
    if not has_real_text:
        return

    unit = "".join(unit_parts)

    # Skip units that are too long for the model to translate reliably.
    # These are typically rich-text advertisements or multi-paragraph descriptions.
    # They are kept in English; the user can translate them manually.
    if len(unit) > 800:
        log.warning(
            "  [skip-long] [%s] unit is %d chars (> 800) — keeping original English",
            ctx, len(unit),
        )
        return

    # ── Translate with automatic retry on dropped tokens ──────────────────────
    translated: str = ""
    missing: list[int] = []

    for attempt in range(MAX_RETRIES + 1):
        if attempt == 0:
            hint = ""
        else:
            dropped = " ".join(f"⟦{j}⟧" for j in missing)
            hint = (
                f"attempt {attempt}/{MAX_RETRIES}: your previous output dropped "
                f"token(s) {dropped}. You MUST keep ALL tokens unchanged in place."
            )

        translated = translate_fn(unit, ctx, hint)
        missing = [j for j in range(token_count) if f"⟦{j}⟧" not in translated]

        if not missing:
            break
        if attempt < MAX_RETRIES:
            log.warning(
                "  [retry %d/%d] [%s] token(s) %s dropped — retrying",
                attempt + 1, MAX_RETRIES, ctx,
                " ".join(f"⟦{j}⟧" for j in missing),
            )

    if missing:
        # Last-resort: if ALL missing tokens form a leading token-only prefix in
        # unit_parts (e.g. a StringLiteral space or bracket-escape before the first
        # real text), restore that prefix directly.  The model correctly translates
        # everything after the prefix; it just drops the opaque leading token(s).
        leading_prefix_parts = []
        for part in unit_parts:
            if TOKEN_RE.fullmatch(part):
                leading_prefix_parts.append(part)
            else:
                break  # first TextElement encountered — stop

        if leading_prefix_parts and all(
            any(p == f"⟦{j}⟧" for p in leading_prefix_parts) for j in missing
        ):
            prefix = "".join(leading_prefix_parts)
            candidate = prefix + translated
            still_missing = [j for j in missing if f"⟦{j}⟧" not in candidate]
            if not still_missing:
                log.warning(
                    "  [auto-restore] [%s] prepended leading token(s) %s",
                    ctx, " ".join(f"⟦{j}⟧" for j in missing),
                )
                translated = candidate
                missing = still_missing

    if missing:
        raise ValueError(
            f"[{ctx}] Token(s) {[f'⟦{j}⟧' for j in missing]} still missing "
            f"after {MAX_RETRIES + 1} attempts.\n"
            f"  Original : {unit!r}\n"
            f"  Last out : {translated!r}"
        )

    # Split on all ⟦N⟧ tokens to get the text pieces between them
    pieces = re.split(r"⟦\d+⟧", translated)
    # pieces[k] = text that appears before the k-th token
    #             (pieces[-1] = text after the last token)

    # Map each TextElement to the right piece:
    # "tokens before this TextElement in unit_parts" == its piece index
    for unit_idx, te in te_list:
        tokens_before = sum(
            1 for part in unit_parts[:unit_idx] if TOKEN_RE.fullmatch(part)
        )
        if tokens_before < len(pieces):
            new_val = pieces[tokens_before]
            if new_val:
                te.value = new_val
            else:
                # Empty piece means model dropped the surrounding text.
                # Keep original so the serializer never gets an empty TextElement.
                log.warning(
                    "[%s] Translation produced empty string for '%s' — keeping original",
                    ctx, te.value[:40],
                )
        else:
            log.warning("[%s] Could not remap TextElement '%s'", ctx, te.value[:40])


def translate_pattern_inplace(pattern: F.Pattern, translate_fn, ctx: str) -> None:
    """
    In-place translate a Fluent Pattern.

    Processes left-to-right:
      - Accumulate TextElements + non-Select Placeables into a "run".
      - When a SelectExpression is encountered, flush & translate the run,
        then recurse into each variant (handles plurals, genders, etc.).
    """
    i = 0
    elements = pattern.elements

    while i < len(elements):
        run: list = []

        # Gather until we hit a SelectExpression or end of elements
        while i < len(elements):
            elem = elements[i]
            if (
                isinstance(elem, F.Placeable)
                and isinstance(elem.expression, F.SelectExpression)
            ):
                break
            run.append(elem)
            i += 1

        # Translate the accumulated run
        _translate_run(run, translate_fn, ctx)

        # Handle the SelectExpression we stopped at
        if i < len(elements):
            elem = elements[i]
            sel: F.SelectExpression = elem.expression  # type: ignore[assignment]
            for variant in sel.variants:
                if variant.value and isinstance(variant.value, F.Pattern):
                    key_str = (
                        variant.key.name
                        if isinstance(variant.key, F.Identifier)
                        else str(variant.key.value)
                    )
                    translate_pattern_inplace(
                        variant.value, translate_fn, f"{ctx}[{key_str}]"
                    )
            i += 1  # skip past the SelectExpression placeable itself


def translate_entry(entry: F.SyntaxNode, translate_fn, ctx: str) -> None:
    """Translate the value and all attributes of a Message or Term in-place."""
    if entry.value and isinstance(entry.value, F.Pattern):
        translate_pattern_inplace(entry.value, translate_fn, ctx)
    for attr in getattr(entry, "attributes", []):
        if attr.value and isinstance(attr.value, F.Pattern):
            translate_pattern_inplace(attr.value, translate_fn, f"{ctx}.{attr.id.name}")


# ── Validation ────────────────────────────────────────────────────────────────

def _collect_vars(node, out: set) -> None:
    """Recursively collect { $variable } names from an AST expression node."""
    if isinstance(node, F.VariableReference):
        out.add(node.id.name)
    elif isinstance(node, F.SelectExpression):
        _collect_vars(node.selector, out)
        for variant in node.variants:
            if variant.value:
                for elem in variant.value.elements:
                    if isinstance(elem, F.Placeable):
                        _collect_vars(elem.expression, out)
    elif isinstance(node, F.FunctionReference):
        args = getattr(node, "arguments", None)
        if args:
            for arg in getattr(args, "positional", []):
                _collect_vars(arg, out)
            for kw in getattr(args, "named", []):
                _collect_vars(kw.value, out)
    elif isinstance(node, (F.MessageReference, F.TermReference)):
        args = getattr(node, "arguments", None)
        if args:
            for arg in getattr(args, "positional", []):
                _collect_vars(arg, out)


def _vars_in_entry(entry) -> set:
    """Return the set of { $variable } names referenced in a Message/Term."""
    found: set = set()

    def walk(pattern):
        if not pattern:
            return
        for elem in pattern.elements:
            if isinstance(elem, F.Placeable):
                _collect_vars(elem.expression, found)

    walk(getattr(entry, "value", None))
    for attr in getattr(entry, "attributes", []):
        walk(getattr(attr, "value", None))
    return found


def _entry_id(entry) -> str:
    return (
        entry.id.name
        if isinstance(entry, F.Message)
        else f"-{entry.id.name}"
    )


# ── SS14 markup validators ────────────────────────────────────────────────────

# Tags that were translated to Portuguese and break the game's markup parser
_PT_TAG_RE = re.compile(
    r'\[/?(?:'
    r'cor(?:=[^\]]*)?'           # [cor=...] or [/cor]
    r'|it[aá]lico'               # [italico] [itálico]
    r'|negrito'                  # [negrito]
    r'|fonte(?:=[^\]]*)?'        # [fonte=...]
    r'|grifo(?:=[^\]]*)?'        # [grifo=...]
    r')\]',
    re.IGNORECASE,
)

# Portuguese color names used inside color tags (e.g. [color=vermelho])
_PT_COLOR_NAME_RE = re.compile(
    r'\[color=(?:vermelho|verde|amarelo|ciano|azul|branco|preto|roxo|rosa)\]',
    re.IGNORECASE,
)


def _check_ss14_markup(translated_src: str) -> list[str]:
    """Return error strings for SS14 markup problems in translated FTL text."""
    errors: list[str] = []

    for m in _PT_TAG_RE.finditer(translated_src):
        lineno = translated_src[:m.start()].count('\n') + 1
        errors.append(
            f"SS14 markup: translated tag {m.group()!r} on line {lineno} — "
            "use English tags: [color=], [bold], [italic]"
        )

    for m in _PT_COLOR_NAME_RE.finditer(translated_src):
        lineno = translated_src[:m.start()].count('\n') + 1
        errors.append(
            f"SS14 markup: Portuguese color name {m.group()!r} on line {lineno} — "
            "use English: red, green, yellow, cyan, blue, white, black, purple, pink"
        )

    # Check overall color/bold/italic balance
    color_o = len(re.findall(r'\[color[^\]]*\]', translated_src))
    color_c = len(re.findall(r'\[/color\]', translated_src))
    if color_o != color_c:
        errors.append(
            f"SS14 markup: unbalanced [color] tags — {color_o} opens, {color_c} closes"
        )

    bold_o = len(re.findall(r'\[bold\]', translated_src))
    bold_c = len(re.findall(r'\[/bold\]', translated_src))
    if bold_o != bold_c:
        errors.append(
            f"SS14 markup: unbalanced [bold] tags — {bold_o} opens, {bold_c} closes"
        )

    italic_o = len(re.findall(r'\[italic\]', translated_src))
    italic_c = len(re.findall(r'\[/italic\]', translated_src))
    if italic_o != italic_c:
        errors.append(
            f"SS14 markup: unbalanced [italic] tags — {italic_o} opens, {italic_c} closes"
        )

    return errors


def validate_translation(original_src: str, translated_src: str) -> list[str]:
    """
    Validate translated FTL against the original.

    Checks:
      1. Translated file parses without Junk (no syntax errors).
      2. No keys added or removed.
      3. Every message has exactly the same { $variable } set.
      4. No SS14 markup translated to Portuguese or unbalanced color/bold/italic tags.

    Returns list of error strings — empty means OK.
    """
    parser = FluentParser(with_spans=False)
    errors: list[str] = []

    orig = parser.parse(original_src)
    trans = parser.parse(translated_src)

    # 1. Parse errors in translation
    trans_junk = [e for e in trans.body if isinstance(e, F.Junk)]
    if trans_junk:
        for j in trans_junk:
            errors.append(f"PARSE ERROR (Junk) introduced: {j.content[:80]!r}")
        return errors  # rest of checks are meaningless if file is broken

    # 2. Key set comparison
    orig_entries = {
        _entry_id(e): e
        for e in orig.body
        if isinstance(e, (F.Message, F.Term))
    }
    trans_entries = {
        _entry_id(e): e
        for e in trans.body
        if isinstance(e, (F.Message, F.Term))
    }

    created = set(trans_entries) - set(orig_entries)
    missing = set(orig_entries) - set(trans_entries)
    if created:
        errors.append(f"Keys added (forbidden): {sorted(created)}")
    if missing:
        errors.append(f"Keys removed (forbidden): {sorted(missing)}")

    # 3. Variable set comparison per message
    for eid in set(orig_entries) & set(trans_entries):
        ov = _vars_in_entry(orig_entries[eid])
        tv = _vars_in_entry(trans_entries[eid])
        if ov != tv:
            errors.append(
                f"Variable mismatch in '{eid}': "
                f"expected {sorted(ov)}, got {sorted(tv)}"
            )

    # 4. SS14 markup integrity
    errors.extend(_check_ss14_markup(translated_src))

    return errors


# ── File-level translation ────────────────────────────────────────────────────

def translate_file(
    src: Path,
    dst: Path,
    glossary: dict,
    tm: dict,
    dry_run: bool,
) -> bool:
    """
    Translate one .ftl file.  Returns True on success, False on any error.
    In dry_run mode prints the result to stdout without writing to disk.
    """
    log.info("  Processing: %s", src.name)
    # utf-8-sig strips BOM if present (some SS14 files have it); output is plain utf-8
    original = src.read_text(encoding="utf-8-sig")

    parser = FluentParser(with_spans=False)
    serializer = FluentSerializer()

    resource = parser.parse(original)

    junk_orig = [e for e in resource.body if isinstance(e, F.Junk)]
    if junk_orig:
        log.warning("    %d Junk entries in original — skipped (carried over)", len(junk_orig))

    def translate_fn(text: str, ctx: str, hint: str = "") -> str:
        # On retry, purge any broken TM entry so the LLM gets a clean attempt
        # (broken entries are saved by call_ollama before token-check happens)
        if hint:
            key = text.strip()
            if key in tm:
                log.debug("  [TM] Purging broken entry before retry: %s", key[:50])
                del tm[key]
        return call_ollama(text, ctx, glossary, tm, hint)

    n_translated = 0
    for entry in resource.body:
        if isinstance(entry, (F.Message, F.Term)):
            ctx = _entry_id(entry)
            try:
                translate_entry(entry, translate_fn, ctx)
                n_translated += 1
            except Exception as exc:
                log.error("    FAILED entry '%s': %s", ctx, exc)
                return False

    try:
        translated_src = serializer.serialize(resource)
    except Exception as exc:
        log.error("    Serializer error (likely empty TextElement): %s", exc)
        return False

    # ── Validate before touching disk ────────────────────────────────────────
    errors = validate_translation(original, translated_src)
    if errors:
        log.error("    Validation FAILED for %s:", src.name)
        for err in errors:
            log.error("      %s", err)
        return False

    if dry_run:
        sep = "─" * 64
        print(f"\n{sep}")
        print(f"DRY RUN → {dst}")
        print(sep)
        print(translated_src)
        log.info("    [dry-run] %d entries OK — NOT written", n_translated)
        return True

    dst.parent.mkdir(parents=True, exist_ok=True)
    dst.write_text(translated_src, encoding="utf-8")
    log.info("    ✓ %d entries written → %s", n_translated, dst)
    return True


# ── Repository helpers ────────────────────────────────────────────────────────

def find_en_us(repo: Path) -> Path:
    candidates = [
        repo / "Resources" / "Locale" / "en-US",
        repo / "Content.Client" / "Resources" / "Locale" / "en-US",
    ]
    for c in candidates:
        if c.exists():
            return c
    raise FileNotFoundError(f"en-US locale not found under {repo}")


# ── Main ──────────────────────────────────────────────────────────────────────

def main() -> None:
    ap = argparse.ArgumentParser(
        description="Translate SS14 .ftl files (en-US → pt-BR) via Ollama",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__,
    )
    ap.add_argument(
        "--repo", type=Path, default=Path(__file__).parent.parent,
        metavar="PATH", help="SS14 repo root (default: parent of tools/)",
    )
    ap.add_argument(
        "--folder", metavar="SUBDIR",
        help="Folder under en-US/ to translate recursively (e.g. alert-levels)",
    )
    ap.add_argument(
        "--file", type=Path, metavar="REL_PATH",
        help="Single .ftl path relative to en-US/ (e.g. alert-levels/alert-levels.ftl)",
    )
    ap.add_argument(
        "--all", action="store_true",
        help="Translate the entire en-US/ tree (equivalent to --folder .)",
    )
    ap.add_argument(
        "--dry-run", action="store_true",
        help="Print translations to stdout without writing any files",
    )
    ap.add_argument(
        "--skip-existing", action="store_true",
        help="Skip files that already have a pt-BR translation (for resuming interrupted runs)",
    )
    ap.add_argument(
        "--tm-save-every", type=int, default=20, metavar="N",
        help="Save translation memory every N files (default: 20)",
    )
    ap.add_argument("--verbose", "-v", action="store_true", help="Show each LLM call")
    args = ap.parse_args()

    if args.verbose:
        log.setLevel(logging.DEBUG)

    en_root = find_en_us(args.repo)
    pt_root = en_root.parent / "pt-BR"
    log.info("en-US root : %s", en_root)
    log.info("pt-BR root : %s", pt_root)

    glossary = load_glossary()
    tm = load_tm()
    log.info("Glossary: %d terms | TM: %d cached entries", len(glossary), len(tm))

    # Collect files
    if args.file:
        files = [en_root / args.file]
    elif args.all:
        files = sorted(en_root.rglob("*.ftl"))
    elif args.folder:
        folder = en_root / args.folder
        if not folder.exists():
            log.error("Folder not found: %s", folder)
            sys.exit(1)
        files = sorted(folder.rglob("*.ftl"))
    else:
        ap.print_help()
        sys.exit(1)

    if not files:
        log.error("No .ftl files found.")
        sys.exit(1)

    total = len(files)
    log.info("Files to translate: %d", total)
    if args.dry_run:
        log.info("*** DRY RUN — nothing will be written ***")
    if args.skip_existing:
        log.info("*** --skip-existing: will skip already-translated files ***")

    ok = fail = skipped = 0
    for i, src in enumerate(files, 1):
        dst = pt_root / src.relative_to(en_root)

        if args.skip_existing and not args.dry_run and dst.exists():
            skipped += 1
            continue

        log.info("[%d/%d] %s", i, total, src.relative_to(en_root))
        success = translate_file(src, dst, glossary, tm, dry_run=args.dry_run)
        if success:
            ok += 1
        else:
            fail += 1

        # Periodic TM autosave so progress is not lost if the run is interrupted
        if not args.dry_run and i % args.tm_save_every == 0:
            save_tm(tm)
            log.info("  [TM autosave: %d entries after %d files]", len(tm), i)

    if not args.dry_run:
        save_tm(tm)
        log.info("TM saved (%d entries total)", len(tm))

    log.info("─" * 40)
    if skipped:
        log.info("Done: %d OK, %d failed, %d skipped (already existed)", ok, fail, skipped)
    else:
        log.info("Done: %d OK, %d failed", ok, fail)
    if fail:
        sys.exit(1)
    if fail:
        sys.exit(1)


if __name__ == "__main__":
    main()
