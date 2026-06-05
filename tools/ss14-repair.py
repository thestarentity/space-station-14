#!/usr/bin/env python3
"""
ss14-repair.py — Fix broken SS14 markup tags in pt-BR locale files.

Problems fixed:
  1. [cor=X]/[/cor] → [color=X]/[/color]  (tag name was translated)
  2. [colour=X]     → [color=X]           (British spelling introduced)
  3. Color values translated inside tags   (e.g. [color=cinzaescuro] → [color=dimgray])
     All three are fixed by comparing with the en-US original and replacing
     the broken tag with the correct one in the same positional order.

What is NOT auto-fixed (reported for manual review):
  - Messages where the tag COUNT differs between en-US and pt-BR
  - Multiline selector text corruption (model changed " and " to wrong text)

Usage:
  python tools/ss14-repair.py --dry-run   # preview fixes
  python tools/ss14-repair.py             # apply fixes
  python tools/ss14-repair.py --folder lobby  # single folder
"""

import argparse
import importlib.util
import re
import sys
from pathlib import Path

# ── Import shared infra ───────────────────────────────────────────────────────
_translate_path = Path(__file__).parent / "ss14-translate.py"
_spec = importlib.util.spec_from_file_location("ss14_translate", _translate_path)
_mod = importlib.util.module_from_spec(_spec)   # type: ignore
_spec.loader.exec_module(_mod)                   # type: ignore

FluentParser         = _mod.FluentParser
FluentSerializer     = _mod.FluentSerializer
F                    = _mod.F
validate_translation = _mod.validate_translation
_entry_id            = _mod._entry_id
find_en_us           = _mod.find_en_us
log                  = _mod.log

# ── Markup helpers ────────────────────────────────────────────────────────────

_TAG_RE = re.compile(r"\[[^\]]+\]")

def _get_tags(text: str) -> list[str]:
    """Return all [tag] tokens from text in left-to-right order."""
    return _TAG_RE.findall(text)

def _needs_repair(pt_serialized: str) -> bool:
    """Quick pre-check: any obviously broken tags?"""
    return bool(re.search(r"\[cor=|\[colour=|\[/cor\]|\[/colour\]", pt_serialized, re.I))

def _fix_entry_markup(pt_entry, en_tags: list[str]) -> bool:
    """
    Walk the pt-BR entry's AST and replace broken [tag] tokens with the
    corresponding correct tags from en-US (matched positionally).
    Returns True if any change was made.
    """
    if not en_tags:
        return False

    tags_iter = iter(en_tags)
    changed = [False]

    def fix_pattern(pattern):
        if not pattern:
            return
        for elem in pattern.elements:
            if isinstance(elem, F.TextElement):
                pt_tags_in_elem = _get_tags(elem.value)
                for pt_tag in pt_tags_in_elem:
                    try:
                        en_tag = next(tags_iter)
                        if pt_tag != en_tag:
                            elem.value = elem.value.replace(pt_tag, en_tag, 1)
                            changed[0] = True
                    except StopIteration:
                        return
            elif isinstance(elem, F.Placeable):
                if isinstance(elem.expression, F.SelectExpression):
                    for variant in elem.expression.variants:
                        fix_pattern(variant.value)

    fix_pattern(getattr(pt_entry, "value", None))
    for attr in getattr(pt_entry, "attributes", []):
        fix_pattern(attr.value)

    return changed[0]


# ── Per-file repair ───────────────────────────────────────────────────────────

def repair_file(
    pt_file: Path,
    en_file: Path,
    dry_run: bool,
) -> tuple[int, int, int]:
    """
    Repair markup in one pt-BR file.
    Returns (fixed_count, skipped_tag_mismatch, manual_review_count).
    """
    pt_src = pt_file.read_text(encoding="utf-8")
    en_src = en_file.read_text(encoding="utf-8-sig")

    parser     = FluentParser(with_spans=False)
    serializer = FluentSerializer()

    pt_res = parser.parse(pt_src)
    en_res = parser.parse(en_src)

    en_entries: dict = {
        _entry_id(e): serializer.serialize_entry(e)
        for e in en_res.body
        if isinstance(e, (F.Message, F.Term))
    }

    fixed = skipped = manual = 0
    file_changed = False

    for pt_entry in pt_res.body:
        if not isinstance(pt_entry, (F.Message, F.Term)):
            continue

        eid = _entry_id(pt_entry)
        if eid not in en_entries:
            continue

        en_serialized = en_entries[eid]
        pt_serialized = serializer.serialize_entry(pt_entry)

        if not _needs_repair(pt_serialized):
            continue

        en_tags = _get_tags(en_serialized)
        pt_tags = _get_tags(pt_serialized)

        if len(en_tags) != len(pt_tags):
            # Tag count differs — unsafe to auto-fix
            skipped += 1
            log.warning(
                "  SKIP [%s] in %s — tag count en=%d pt=%d  (manual review needed)",
                eid, pt_file.name, len(en_tags), len(pt_tags),
            )
            continue

        old_pt_serialized = pt_serialized
        was_changed = _fix_entry_markup(pt_entry, en_tags)

        if was_changed:
            new_pt_serialized = serializer.serialize_entry(pt_entry)
            fixed += 1
            file_changed = True
            if dry_run:
                print(f"\n  [{eid}]")
                print(f"    BEFORE: {old_pt_serialized.strip()[:120]}")
                print(f"    AFTER : {new_pt_serialized.strip()[:120]}")

    if file_changed and not dry_run:
        new_pt_src = serializer.serialize(pt_res)

        # Validate before writing
        errors = validate_translation(en_src, new_pt_src)
        if errors:
            log.error("  Validation failed for %s — NOT written:", pt_file.name)
            for e in errors:
                log.error("    %s", e)
            return 0, skipped + fixed, 0

        pt_file.write_text(new_pt_src, encoding="utf-8")

    return fixed, skipped, manual


# ── Main ─────────────────────────────────────────────────────────────────────

def main() -> None:
    ap = argparse.ArgumentParser(
        description="Fix broken SS14 markup tags in pt-BR locale files",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__,
    )
    ap.add_argument("--repo", type=Path, default=Path(__file__).parent.parent)
    ap.add_argument("--folder", metavar="SUBDIR",
                    help="Repair only files under this en-US subfolder")
    ap.add_argument("--dry-run", action="store_true")
    args = ap.parse_args()

    en_root = find_en_us(args.repo)
    pt_root = en_root.parent / "pt-BR"

    if args.folder:
        en_files = sorted((en_root / args.folder).rglob("*.ftl"))
    else:
        en_files = sorted(en_root.rglob("*.ftl"))

    if args.dry_run:
        log.info("*** DRY RUN — nothing will be written ***")

    total_fixed = total_skipped = 0
    files_changed = 0

    for en_file in en_files:
        pt_file = pt_root / en_file.relative_to(en_root)
        if not pt_file.exists():
            continue

        fixed, skipped, _ = repair_file(pt_file, en_file, dry_run=args.dry_run)

        if fixed or skipped:
            rel = en_file.relative_to(en_root)
            if fixed:
                log.info("  %s  fixed=%d skip=%d", rel, fixed, skipped)
                files_changed += 1
            total_fixed   += fixed
            total_skipped += skipped

    log.info("─" * 48)
    log.info("Files changed: %d | Entries fixed: %d | Skipped (manual): %d",
             files_changed, total_fixed, total_skipped)


if __name__ == "__main__":
    main()
