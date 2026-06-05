#!/usr/bin/env python3
"""
ss14-verificacao.py — Verificação geral e correção do pt-BR.

Fases:
  1  Fixes determinísticos: markup quebrado + dataset hallucinations
  2  TIPO 2: entidades/reagentes ainda em inglês (usa Ollama)
  3  TIPO 4: relatório de textos longos demais

Uso:
  python tools/ss14-verificacao.py --fase 1 --dry-run
  python tools/ss14-verificacao.py --fase 1
  python tools/ss14-verificacao.py --fase 2 --dry-run
  python tools/ss14-verificacao.py --fase 2
  python tools/ss14-verificacao.py --fase 3
"""

import argparse
import importlib.util
import json
import re
import sys
from pathlib import Path

# ── Import infra do translate.py ──────────────────────────────────────────────
_translate_path = Path(__file__).parent / "ss14-translate.py"
_spec = importlib.util.spec_from_file_location("ss14_translate", _translate_path)
_mod = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(_mod)

FluentParser         = _mod.FluentParser
FluentSerializer     = _mod.FluentSerializer
F                    = _mod.F
call_ollama          = _mod.call_ollama
translate_entry      = _mod.translate_entry
load_glossary        = _mod.load_glossary
load_tm              = _mod.load_tm
save_tm              = _mod.save_tm
find_en_us           = _mod.find_en_us
log                  = _mod.log
TOOLS_DIR            = _mod.TOOLS_DIR

REPO = Path(__file__).parent.parent
EN_ROOT = REPO / "Resources/Locale/en-US"
PT_ROOT = REPO / "Resources/Locale/pt-BR"


# ═══════════════════════════════════════════════════════════════════════════════
# FASE 1 — FIXES DETERMINÍSTICOS
# ═══════════════════════════════════════════════════════════════════════════════

def fase1(dry_run: bool) -> None:
    log.info("=== FASE 1: Fixes determinísticos ===")
    fixed = 0

    # ── 1a. TIPO 3: Dataset / name hallucinations ─────────────────────────────
    direct_fixes = [
        # (arquivo_pt, chave, valor_correto)
        ("species/species.ftl",          "species-name-human",          "Humano"),
        ("species/species.ftl",          "species-name-slime",          "Pessoa Slime"),
        ("metabolism/metabolizer-types.ftl", "metabolizer-type-human",  "Humano"),
        ("datasets/names/operation_prefix.ftl", "names-operation-prefix-dataset-44", "Humano"),
        ("datasets/names/operation_suffix.ftl", "names-operation-suffix-dataset-49", "Máquina"),
        ("datasets/names/ai.ftl",        "names-ai-dataset-45",         "Tudo"),
        ("datasets/names/last.ftl",      "names-last-dataset-479",      "Styles"),
        # Vox name: restore from en-US
        ("datasets/names/vox.ftl",       "names-vox-dataset-495",       "Herecrerivi"),
    ]

    for rel, key, correct_value in direct_fixes:
        p = PT_ROOT / rel
        if not p.exists():
            log.warning("  NOT FOUND: %s", p)
            continue
        parser = FluentParser(with_spans=False)
        serializer = FluentSerializer()
        src = p.read_text()
        res = parser.parse(src)
        changed = False
        for i, entry in enumerate(res.body):
            if not isinstance(entry, (F.Message, F.Term)):
                continue
            if entry.id.name == key:
                # Check if it needs fixing
                current_ser = serializer.serialize_entry(entry)
                if correct_value in current_ser:
                    break
                # Replace value
                if entry.value and isinstance(entry.value, F.Pattern):
                    entry.value.elements = [F.TextElement(correct_value)]
                    changed = True
                    if dry_run:
                        log.info("  [DRY] %s [%s] → %s", rel, key, correct_value)
                    else:
                        log.info("  FIX %s [%s] → %s", rel, key, correct_value)
                break
        if changed and not dry_run:
            p.write_text(serializer.serialize(res))
            fixed += 1

    # ── 1b. TIPO 3: Pirate accent hallucinations ──────────────────────────────
    pirate_fixes = [
        ("accent-pirate-replaced-21", "canção"),
        ("accent-pirate-replaced-23", "não"),
    ]
    p = PT_ROOT / "accent/pirate.ftl"
    if p.exists():
        parser = FluentParser(with_spans=False)
        serializer = FluentSerializer()
        src = p.read_text()
        res = parser.parse(src)
        changed = False
        for entry in res.body:
            if not isinstance(entry, (F.Message, F.Term)):
                continue
            for key, val in pirate_fixes:
                if entry.id.name == key:
                    current = serializer.serialize_entry(entry)
                    if val in current and len(current.strip()) < len(val) + 20:
                        break  # already correct
                    if entry.value:
                        entry.value.elements = [F.TextElement(val)]
                        changed = True
                        log.info("  FIX accent/pirate.ftl [%s] → %s", key, val)
        if changed and not dry_run:
            p.write_text(serializer.serialize(res))
            fixed += 1

    # ── 1c. TIPO 1: cartridges.ftl — rewrite wanted-list-status-label ─────────
    p = PT_ROOT / "cartridge-loader/cartridges.ftl"
    en_p = EN_ROOT / "cartridge-loader/cartridges.ftl"
    if p.exists() and en_p.exists():
        txt = p.read_text()
        correct_entry = (
            "wanted-list-status-label = [color=darkgray]status:[/color]{ $status ->\n"
            "        [suspected] [color=yellow]suspeito[/color]\n"
            "        [wanted] [color=red]procurado[/color]\n"
            "        [detained] [color=#b18644]detido[/color]\n"
            "        [paroled] [color=green]liberado[/color]\n"
            "        [discharged] [color=green]descarregado[/color]\n"
            "        [hostile] [color=darkred]hostil[/color]\n"
            "        [eliminated] [color=gray]eliminado[/color]\n"
            "       *[other] nenhum\n"
            "    }\n"
        )
        # Find and replace the broken entry using regex
        broken_re = re.compile(
            r'wanted-list-status-label = .*?\n(?:[ \t]+.*?\n)*', re.DOTALL
        )
        # More targeted: find from the key to the closing }
        key_re = re.compile(
            r'(wanted-list-status-label\s*=\s*\[color=darkgray\]status:\[/color\]\s*\{\s*\$status\s*->.*?^\s*\})',
            re.DOTALL | re.MULTILINE
        )
        m = key_re.search(txt)
        if m:
            new_txt = txt[:m.start()] + correct_entry.rstrip() + "\n" + txt[m.end():]
            if not dry_run:
                p.write_text(new_txt)
                fixed += 1
                log.info("  FIX cartridges.ftl [wanted-list-status-label]")
            else:
                log.info("  [DRY] cartridges.ftl [wanted-list-status-label]")
        else:
            log.warning("  SKIP cartridges.ftl — pattern not matched (may already be fixed)")

    # ── 1d. TIPO 1: book-authorbooks.ftl — missing [/color] ──────────────────
    p = PT_ROOT / "paper/book-authorbooks.ftl"
    if p.exists():
        txt = p.read_text()
        old = "[bold][color=black][head=3]As Histórias de um Zelador Cansado[/head][/bold]"
        new = "[bold][color=black][head=3]As Histórias de um Zelador Cansado[/head][/color][/bold]"
        if old in txt and new not in txt:
            if dry_run:
                log.info("  [DRY] book-authorbooks.ftl: add missing [/color]")
            else:
                p.write_text(txt.replace(old, new))
                fixed += 1
                log.info("  FIX book-authorbooks.ftl: add missing [/color]")

    # ── 1e. TIPO 1: Wizard.xml — € → c ───────────────────────────────────────
    wizard = REPO / "Resources/ServerInfo/Guidebook/Antagonist/Wizard.xml"
    if wizard.exists():
        txt = wizard.read_text()
        old = "[color=#00FF00]€[/color]"
        new = "[color=#00FF00]c[/color]"
        if old in txt:
            if dry_run:
                log.info("  [DRY] Wizard.xml: € → c in Wizcoins")
            else:
                wizard.write_text(txt.replace(old, new))
                fixed += 1
                log.info("  FIX Wizard.xml: € → c in Wizcoins")

    # ── 1f. TIPO 3: datasets/names/ai.ftl — fix hallucinated entry ───────────
    p = PT_ROOT / "datasets/names/ai.ftl"
    if p.exists():
        txt = p.read_text()
        # names-ai-dataset-45 has multi-line LLM text
        bad_re = re.compile(
            r'(names-ai-dataset-45\s*=\s*\n\s+Aqui está.*?(?:\n\n|\Z))',
            re.DOTALL
        )
        m = bad_re.search(txt)
        if m:
            replacement = "names-ai-dataset-45 = Tudo\n"
            if dry_run:
                log.info("  [DRY] ai.ftl [names-ai-dataset-45] → Tudo")
            else:
                p.write_text(txt[:m.start()] + replacement + txt[m.end():])
                fixed += 1
                log.info("  FIX ai.ftl [names-ai-dataset-45] → Tudo")

    # ── 1g. TIPO 3: vox.ftl — fix hallucinated entry ─────────────────────────
    p = PT_ROOT / "datasets/names/vox.ftl"
    if p.exists():
        txt = p.read_text()
        bad_re = re.compile(
            r'(names-vox-dataset-495\s*=\s*\n\s+Aqui está.*?(?=\nnames-vox-dataset-496|\Z))',
            re.DOTALL
        )
        m = bad_re.search(txt)
        if m:
            replacement = "names-vox-dataset-495 = Herecrerivi\n"
            if dry_run:
                log.info("  [DRY] vox.ftl [names-vox-dataset-495] → Herecrerivi")
            else:
                p.write_text(txt[:m.start()] + replacement + txt[m.end():])
                fixed += 1
                log.info("  FIX vox.ftl [names-vox-dataset-495] → Herecrerivi")

    # ── 1h. TIPO 3: species-name-human/metabolizer multi-line fix ────────────
    # These are already handled by direct_fixes above, but need regex for multi-line LLM responses
    multi_line_fixes = [
        ("species/species.ftl", "species-name-human", "Humano"),
        ("metabolism/metabolizer-types.ftl", "metabolizer-type-human", "Humano"),
    ]
    for rel, key, val in multi_line_fixes:
        p = PT_ROOT / rel
        if not p.exists(): continue
        txt = p.read_text()
        bad_re = re.compile(
            rf'({re.escape(key)}\s*=\s*Prefixes de operação[^\n]*\n?)',
            re.IGNORECASE
        )
        m = bad_re.search(txt)
        if m:
            if dry_run:
                log.info("  [DRY] %s [%s] → %s", rel, key, val)
            else:
                p.write_text(txt[:m.start()] + f"{key} = {val}\n" + txt[m.end():])
                fixed += 1
                log.info("  FIX %s [%s] → %s", rel, key, val)

    log.info("─" * 50)
    log.info("Fase 1: %d fixes %s", fixed, "(dry-run)" if dry_run else "aplicados")


# ═══════════════════════════════════════════════════════════════════════════════
# FASE 2 — TIPO 2: entidades/reagentes em inglês
# ═══════════════════════════════════════════════════════════════════════════════

EN_WORDS = frozenset("""the a an is are was were it this that has have been will can your you with
from for they them their there when where what who also use using keep keeps kept
makes make made allows allow prevents prevent causes cause provides provide""".split())

def _looks_english(text: str) -> bool:
    clean = re.sub(r'[\[{][^\]}]+[\]}]', ' ', text)
    clean = re.sub(r'[^a-zA-Z\s]', ' ', clean)
    words = clean.lower().split()
    if len(words) < 3: return False
    return sum(1 for w in words if w in EN_WORDS) >= 2

def _entry_text(entry) -> str:
    parts = []
    def walk(pat):
        if not pat: return
        for e in pat.elements:
            if isinstance(e, F.TextElement): parts.append(e.value)
            elif isinstance(e, F.Placeable) and isinstance(e.expression, F.SelectExpression):
                for v in e.expression.variants: walk(v.value)
    walk(getattr(entry, "value", None))
    for a in getattr(entry, "attributes", []): walk(a.value)
    return " ".join(parts)

def _entry_id(e) -> str:
    return e.id.name if isinstance(e, F.Message) else f"-{e.id.name}"

def fase2(dry_run: bool) -> None:
    log.info("=== FASE 2: Entidades/reagentes em inglês ===")
    if dry_run:
        log.info("    (DRY-RUN)")

    glossary = load_glossary()
    tm = load_tm()
    parser = FluentParser(with_spans=False)
    serializer = FluentSerializer()

    total_checked = 0
    total_untranslated = 0
    total_fixed = 0

    def translate_fn(text, ctx, hint=""):
        if hint:
            k = text.strip()
            if k in tm: del tm[k]
        return call_ollama(text, ctx, glossary, tm, hint)

    for en_file in sorted(EN_ROOT.rglob("*.ftl")):
        pt_file = PT_ROOT / en_file.relative_to(EN_ROOT)
        if not pt_file.exists(): continue

        en_src = en_file.read_text(errors='replace')
        pt_src = pt_file.read_text()

        en_res = parser.parse(en_src)
        pt_res = parser.parse(pt_src)

        en_map = {_entry_id(e): e for e in en_res.body if isinstance(e, (F.Message, F.Term))}
        changed = False

        for i, pt_entry in enumerate(pt_res.body):
            if not isinstance(pt_entry, (F.Message, F.Term)): continue
            eid = _entry_id(pt_entry)
            en_entry = en_map.get(eid)
            if not en_entry: continue

            total_checked += 1
            pt_text = _entry_text(pt_entry).strip()
            en_text = _entry_text(en_entry).strip()

            # Consider untranslated if: exact match AND text is English prose
            if pt_text.lower() == en_text.lower() and _looks_english(en_text):
                total_untranslated += 1
                rel = str(pt_file.relative_to(PT_ROOT))
                log.info("  [UNTRANSLATED] %s [%s]: %s", rel, eid, en_text[:60])

                if not dry_run:
                    import copy
                    fresh = copy.deepcopy(en_entry)
                    try:
                        translate_entry(fresh, translate_fn, eid)
                        pt_res.body[i] = fresh
                        changed = True
                        total_fixed += 1
                        log.info("    → traduzido")
                    except Exception as exc:
                        log.warning("    → falhou: %s", exc)

        if changed and not dry_run:
            new_src = serializer.serialize(pt_res)
            pt_file.write_text(new_src)

    if not dry_run:
        save_tm(tm)

    log.info("─" * 50)
    log.info("Fase 2: %d verificados, %d em inglês, %d traduzidos", total_checked, total_untranslated, total_fixed)


# ═══════════════════════════════════════════════════════════════════════════════
# FASE 3 — TIPO 4: Textos longos (relatório de layout)
# ═══════════════════════════════════════════════════════════════════════════════

def fase3() -> None:
    log.info("=== FASE 3: Textos possivelmente longos demais ===")

    # Recipe context: GuideReagentEmbed items show "quantity × chemical" style
    # Long reagent descriptions can overflow. Check desc length.
    parser = FluentParser(with_spans=False)
    long_items = []

    for ftl in sorted(PT_ROOT.rglob("*.ftl")):
        src = ftl.read_text(errors='replace')
        res = parser.parse(src)
        for entry in res.body:
            if not isinstance(entry, (F.Message, F.Term)): continue
            eid = _entry_id(entry)
            # Only check names (not descs) that might be used inline in UI buttons/labels
            if not (eid.startswith("reagent-name-") or eid.endswith("-name") or
                    eid.startswith("ent-") and ".desc" not in eid):
                continue
            text = _entry_text(entry).strip()
            if len(text) > 40 and "desc" not in eid.lower():
                long_items.append((str(ftl.relative_to(PT_ROOT)), eid, len(text), text[:80]))

    long_items.sort(key=lambda x: -x[2])
    log.info("Nomes/labels com >40 chars (candidatos a overflow): %d", len(long_items))
    for f, eid, n, t in long_items[:30]:
        log.info("  [%d] %s [%s]: %s", n, f, eid, t)


# ═══════════════════════════════════════════════════════════════════════════════
# MAIN
# ═══════════════════════════════════════════════════════════════════════════════

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--fase", type=int, choices=[1, 2, 3], required=True)
    ap.add_argument("--dry-run", action="store_true")
    args = ap.parse_args()

    if args.fase == 1:
        fase1(args.dry_run)
    elif args.fase == 2:
        fase2(args.dry_run)
    elif args.fase == 3:
        fase3()

if __name__ == "__main__":
    main()
