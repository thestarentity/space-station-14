#!/usr/bin/env python3
"""
ss14-launch-prep.py — Launch preparation for the pt-BR translation.

Phase 2: Find and translate English strings still in pt-BR FTL files.
Phase 3: Flag dubious translations into tools/revisao-pendente.md.

Usage:
  # Find English entries without writing anything:
  python tools/ss14-launch-prep.py --phase 2 --dry-run

  # Translate for real (commits recommended after):
  python tools/ss14-launch-prep.py --phase 2

  # Limit to a specific subfolder:
  python tools/ss14-launch-prep.py --phase 2 --folder actions

  # Flag dubious translations:
  python tools/ss14-launch-prep.py --phase 3

Ollama: http://100.121.242.23:11434  (qwen3:14b)
"""

import argparse
import importlib.util
import re
import sys
from pathlib import Path

# ── Import shared infra from ss14-translate.py ───────────────────────────────
_translate_path = Path(__file__).parent / "ss14-translate.py"
_spec = importlib.util.spec_from_file_location("ss14_translate", _translate_path)
_mod = importlib.util.module_from_spec(_spec)   # type: ignore
_spec.loader.exec_module(_mod)                   # type: ignore

FluentParser         = _mod.FluentParser
FluentSerializer     = _mod.FluentSerializer
F                    = _mod.F
call_ollama          = _mod.call_ollama
translate_entry      = _mod.translate_entry
validate_translation = _mod.validate_translation
load_glossary        = _mod.load_glossary
load_tm              = _mod.load_tm
save_tm              = _mod.save_tm
find_en_us           = _mod.find_en_us
log                  = _mod.log
TOOLS_DIR            = _mod.TOOLS_DIR

# ── Helpers ───────────────────────────────────────────────────────────────────

_TOKEN_RE = re.compile(r"⟦\d+⟧")
_MARKUP_RE = re.compile(r"\[[^\]]+\]")

# Common English-only words (unlikely in pt-BR)
_EN_WORDS = frozenset("""
the a an is are was were it this that has have been will can your you with
from for they them their there here when where what who which how do does
did not no yes but and or so if by of to in on at as up its he she we our
into than then their about also after before during through until very much
more some all any each every both other own same such just even still
already often always never once perhaps soon too while although because
though unless whether ago back between something nothing everything anything
someone nobody everyone anybody myself yourself himself herself itself
""".split())
_EN_TRIGGER = 3


def _looks_english(text: str) -> bool:
    clean = _TOKEN_RE.sub(" ", text)
    clean = _MARKUP_RE.sub(" ", clean)
    clean = re.sub(r"[^a-zA-ZÀ-ÿ\s]", " ", clean)
    words = clean.lower().split()
    if len(words) < 2:
        return False
    return sum(1 for w in words if w in _EN_WORDS) >= _EN_TRIGGER


def _entry_id(e) -> str:
    if isinstance(e, F.Message):
        return e.id.name
    if isinstance(e, F.Term):
        return f"-{e.id.name}"
    return ""


def _extract_all_text(entry) -> str:
    """Join all TextElement values in an entry."""
    parts = []

    def walk(pattern):
        if not pattern:
            return
        for elem in pattern.elements:
            if isinstance(elem, F.TextElement):
                parts.append(elem.value)
            elif isinstance(elem, F.Placeable):
                if isinstance(elem.expression, F.SelectExpression):
                    for v in elem.expression.variants:
                        walk(v.value)

    walk(getattr(entry, "value", None))
    for attr in getattr(entry, "attributes", []):
        walk(attr.value)
    return " ".join(parts)


# ── Phase 2: compare with en-US, find identical = untranslated ───────────────

# Strings that are intentionally identical in en-US and pt-BR
_SKIP_IDENTICAL = re.compile(
    r"^(?:"
    r"<[^>]+>"            # command params like <level>
    r"|\[[^\]]+\]"        # flags like [locked] or markup
    r"|[A-Z][a-z]+"       # single proper noun like Delta, Epsilon, Nanotrasen
    r"|[A-Z]{2,}"         # all-caps acronym
    r"|\d[\d.]*"          # number
    r"|[a-z_-]+"          # snake_case identifier
    r")$",
)


def _entries_are_same_text(en_entry, pt_entry, serializer) -> bool:
    """
    Returns True if the pt-BR entry is still the English original
    (was never translated).
    False-positive guards:
      - Short strings that are proper nouns/acronyms/identifiers
      - Command params (<level>, [locked])
      - Must contain ≥2 common English function words
    """
    en_text = _extract_all_text(en_entry).strip()
    pt_text = _extract_all_text(pt_entry).strip()
    if not en_text or en_text.lower() != pt_text.lower():
        return False
    # Skip trivially identical strings that need no translation
    if _SKIP_IDENTICAL.match(en_text):
        return False
    # Must be long enough and look like actual English prose
    if len(en_text.split()) < 2:
        return False
    return _looks_english(en_text)


def scan_vs_enus(pt_file: Path, en_file: Path) -> list[str]:
    """Return list of entry IDs whose pt-BR text == en-US text."""
    parser = FluentParser(with_spans=False)
    try:
        pt_src = pt_file.read_text(encoding="utf-8")
        en_src = en_file.read_text(encoding="utf-8-sig")
    except Exception:
        return []

    pt_res = parser.parse(pt_src)
    en_res = parser.parse(en_src)
    serializer = FluentSerializer()

    en_map = {_entry_id(e): e for e in en_res.body if isinstance(e, (F.Message, F.Term))}

    same = []
    for e in pt_res.body:
        if not isinstance(e, (F.Message, F.Term)):
            continue
        eid = _entry_id(e)
        en_entry = en_map.get(eid)
        if en_entry is None:
            continue
        if _entries_are_same_text(en_entry, e, serializer):
            # Extra filter: only flag if the text is non-trivial (>3 chars after cleanup)
            en_text = _extract_all_text(en_entry).strip()
            if len(en_text) > 3:
                same.append(eid)
    return same


def scan_heuristic(pt_file: Path) -> list[str]:
    """Return list of entry IDs in entity FTL that look English (no en-US ref)."""
    parser = FluentParser(with_spans=False)
    try:
        src = pt_file.read_text(encoding="utf-8")
    except Exception:
        return []
    res = parser.parse(src)
    flagged = []
    for e in res.body:
        if not isinstance(e, (F.Message, F.Term)):
            continue
        text = _extract_all_text(e)
        if text and _looks_english(text):
            flagged.append(_entry_id(e))
    return flagged


def retranslate_entries(
    pt_file: Path,
    en_src: str,
    target_ids: set[str],
    glossary: dict,
    tm: dict,
    dry_run: bool,
) -> int:
    """
    Re-translate the target_ids entries in pt_file using the en-US source.
    For each entry, we copy the en-US entry text, call translate_entry,
    then replace it in the pt-BR resource.
    Returns the number of entries changed.
    """
    parser = FluentParser(with_spans=False)
    serializer = FluentSerializer()

    pt_src = pt_file.read_text(encoding="utf-8")
    pt_res = parser.parse(pt_src)
    en_res = parser.parse(en_src)

    en_map = {_entry_id(e): e for e in en_res.body if isinstance(e, (F.Message, F.Term))}

    def make_translate_fn(tm_local):
        def fn(text, ctx, hint=""):
            if hint:
                key = text.strip()
                if key in tm_local:
                    del tm_local[key]
            return call_ollama(text, ctx, glossary, tm_local, hint)
        return fn

    translate_fn = make_translate_fn(tm)
    changed = 0

    for i, pt_entry in enumerate(pt_res.body):
        if not isinstance(pt_entry, (F.Message, F.Term)):
            continue
        eid = _entry_id(pt_entry)
        if eid not in target_ids:
            continue
        en_entry = en_map.get(eid)
        if en_entry is None:
            continue

        # Replace pt_entry content with en_entry content (reset to English)
        # then translate in-place
        import copy
        fresh_entry = copy.deepcopy(en_entry)
        try:
            translate_entry(fresh_entry, translate_fn, eid)
            pt_res.body[i] = fresh_entry
            changed += 1
            log.info("    [%s] translated", eid)
        except Exception as exc:
            log.warning("    [%s] failed: %s", eid, exc)

    if changed == 0:
        return 0

    new_src = serializer.serialize(pt_res)
    errors = validate_translation(en_src, new_src)
    if errors:
        log.warning("  Validation errors in %s — NOT written:", pt_file.name)
        for e in errors:
            log.warning("    %s", e)
        return 0

    if not dry_run:
        pt_file.write_text(new_src, encoding="utf-8")
    return changed


def retranslate_entity_entries(
    pt_file: Path,
    target_ids: set[str],
    glossary: dict,
    tm: dict,
    dry_run: bool,
) -> int:
    """Re-translate entity entries (no en-US FTL) that look English."""
    parser = FluentParser(with_spans=False)
    serializer = FluentSerializer()
    pt_src = pt_file.read_text(encoding="utf-8")
    pt_res = parser.parse(pt_src)

    def translate_fn(text, ctx, hint=""):
        if hint:
            key = text.strip()
            if key in tm:
                del tm[key]
        return call_ollama(text, ctx, glossary, tm, hint)

    changed = 0
    for i, pt_entry in enumerate(pt_res.body):
        if not isinstance(pt_entry, (F.Message, F.Term)):
            continue
        eid = _entry_id(pt_entry)
        if eid not in target_ids:
            continue
        try:
            translate_entry(pt_entry, translate_fn, eid)
            changed += 1
            log.info("    [%s] (entity) translated", eid)
        except Exception as exc:
            log.warning("    [%s] failed: %s", eid, exc)

    if changed == 0:
        return 0

    new_src = serializer.serialize(pt_res)
    if not dry_run:
        pt_file.write_text(new_src, encoding="utf-8")
    return changed


def phase2(args, pt_root: Path, en_root: Path) -> None:
    log.info("=== PHASE 2: Detect + translate English strings ===")
    if args.dry_run:
        log.info("    (DRY-RUN — nothing will be written)")

    glossary = load_glossary()
    tm = load_tm()

    total_entries = 0
    total_files = 0

    # ── A. Files that have en-US counterparts ─────────────────────────────────
    if args.folder:
        folder_path = en_root / args.folder
        if not folder_path.exists():
            log.error("Folder not found: %s", folder_path)
            sys.exit(1)
        en_files = sorted(folder_path.rglob("*.ftl"))
    else:
        en_files = sorted(en_root.rglob("*.ftl"))

    for en_file in en_files:
        pt_file = pt_root / en_file.relative_to(en_root)
        if not pt_file.exists():
            continue

        untranslated = scan_vs_enus(pt_file, en_file)
        if not untranslated:
            continue

        rel = pt_file.relative_to(pt_root)
        log.info("  %s — %d untranslated: %s",
                 rel, len(untranslated),
                 ", ".join(f"[{x}]" for x in untranslated[:6]))

        if not args.dry_run:
            en_src = en_file.read_text(encoding="utf-8-sig")
            n = retranslate_entries(pt_file, en_src, set(untranslated),
                                    glossary, tm, dry_run=False)
            if n:
                total_entries += n
                total_files += 1
        else:
            total_entries += len(untranslated)

    # ── B. Entity FTL files (no en-US counterpart) ────────────────────────────
    if not args.folder or args.folder == "entities":
        entity_dir = pt_root / "entities"
        if entity_dir.exists():
            ent_files = sorted(entity_dir.rglob("*.ftl"))
            for pt_file in ent_files:
                flagged = scan_heuristic(pt_file)
                if not flagged:
                    continue
                rel = pt_file.relative_to(pt_root)
                log.info("  [heuristic] %s — %d English-looking: %s",
                         rel, len(flagged),
                         ", ".join(f"[{x}]" for x in flagged[:4]))

                if not args.dry_run:
                    n = retranslate_entity_entries(pt_file, set(flagged),
                                                  glossary, tm, dry_run=False)
                    if n:
                        total_entries += n
                        total_files += 1
                else:
                    total_entries += len(flagged)

    if not args.dry_run:
        save_tm(tm)

    log.info("─" * 60)
    if args.dry_run:
        log.info("DRY-RUN total: %d entries need translation", total_entries)
    else:
        log.info("Done: %d entries translated in %d files", total_entries, total_files)


# ── Phase 3: flag dubious translations ───────────────────────────────────────

# Patterns that suggest a bad/literal translation
_DUBIOUS = [
    (re.compile(r"⟦\d+⟧"), "token não substituído"),
    (re.compile(r"</think>|<think>", re.I), "tag <think> vazada"),
    (re.compile(r"\b(station|crew|department|round|shift)\b", re.I),
     "termo de jogo em inglês"),
    (re.compile(r"\b(the|is are|was|were|has have)\b", re.I),
     "palavra funcional inglesa"),
    (re.compile(r"\[(?:cor|itálico|negrito|fonte)[\]=]", re.I),
     "tag SS14 em português"),
    (re.compile(r"\[color=(?:vermelho|verde|amarelo|ciano|azul)\]", re.I),
     "nome de cor em português"),
]


def phase3(args, pt_root: Path, en_root: Path) -> None:
    log.info("=== PHASE 3: Flag dubious translations ===")

    parser = FluentParser(with_spans=False)
    serializer = FluentSerializer()
    report_path = TOOLS_DIR / "revisao-pendente.md"

    results = []

    if args.folder:
        en_files = sorted((en_root / args.folder).rglob("*.ftl"))
    else:
        en_files = sorted(en_root.rglob("*.ftl"))

    for en_file in en_files:
        pt_file = pt_root / en_file.relative_to(en_root)
        if not pt_file.exists():
            continue
        try:
            pt_src = pt_file.read_text(encoding="utf-8")
            en_src = en_file.read_text(encoding="utf-8-sig")
        except Exception:
            continue

        pt_res = parser.parse(pt_src)
        en_res = parser.parse(en_src)
        en_map = {_entry_id(e): e for e in en_res.body if isinstance(e, (F.Message, F.Term))}

        for e in pt_res.body:
            if not isinstance(e, (F.Message, F.Term)):
                continue
            eid = _entry_id(e)
            en_entry = en_map.get(eid)
            if en_entry is None:
                continue

            text = _extract_all_text(e)
            reasons = []
            for pattern, reason in _DUBIOUS:
                if pattern.search(text):
                    reasons.append(reason)

            if reasons:
                results.append({
                    "file": str(pt_file.relative_to(pt_root)),
                    "key": eid,
                    "en": serializer.serialize_entry(en_entry).strip(),
                    "pt": serializer.serialize_entry(e).strip(),
                    "reasons": reasons,
                })

    log.info("Found %d dubious entries", len(results))
    for r in results[:30]:
        log.info("  [%s] %s ← %s", r["key"], r["file"], r["reasons"])
    if len(results) > 30:
        log.info("  ... and %d more (see report)", len(results) - 30)

    if not args.dry_run:
        lines = [
            "# Traduções para Revisão Manual\n\n",
            f"Gerado por `ss14-launch-prep.py --phase 3` — **{len(results)} entradas**.\n\n",
        ]
        for r in results:
            lines.append(f"### `{r['key']}` — `{r['file']}`\n\n")
            lines.append(f"**Motivos:** {', '.join(r['reasons'])}\n\n")
            lines.append(f"**en-US:**\n```\n{r['en']}\n```\n\n")
            lines.append(f"**pt-BR atual:**\n```\n{r['pt']}\n```\n\n")
            lines.append("---\n\n")
        report_path.write_text("".join(lines), encoding="utf-8")
        log.info("Report → %s", report_path)
    else:
        log.info("(dry-run: report not written)")


# ── Main ──────────────────────────────────────────────────────────────────────

def main() -> None:
    ap = argparse.ArgumentParser(
        description="SS14 pt-BR launch preparation",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__,
    )
    ap.add_argument("--phase", type=int, choices=[2, 3], required=True)
    ap.add_argument("--repo", type=Path, default=Path(__file__).parent.parent)
    ap.add_argument("--folder", metavar="SUBDIR",
                    help="Limit to this en-US subfolder (e.g. 'actions')")
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("--verbose", "-v", action="store_true")
    args = ap.parse_args()

    if args.verbose:
        import logging
        logging.getLogger().setLevel(logging.DEBUG)

    en_root = find_en_us(args.repo)
    pt_root = en_root.parent / "pt-BR"

    if args.phase == 2:
        phase2(args, pt_root, en_root)
    elif args.phase == 3:
        phase3(args, pt_root, en_root)


if __name__ == "__main__":
    main()
