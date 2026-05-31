#!/usr/bin/env python3
"""
ss14-update.py — Incremental pt-BR locale update.

Compares the current en-US locale against a stored snapshot to detect
what changed since the last translation run, then:

  + NEW keys (added to en-US)          → translate
  ~ CHANGED keys (en-US value changed) → re-translate
  - REMOVED keys (deleted from en-US)  → remove from pt-BR
  = UNCHANGED keys                     → skip

First use (after initial full translation):
  python tools/ss14-update.py --init

After pulling upstream changes:
  python tools/ss14-update.py
  python tools/ss14-update.py --dry-run   # preview without writing
"""

import argparse
import copy
import hashlib
import importlib.util
import json
import logging
import sys
from pathlib import Path

# ── Import shared infrastructure from ss14-translate.py ──────────────────────
# (The hyphen in the filename requires importlib instead of a plain import)
_translate_path = Path(__file__).parent / "ss14-translate.py"
_spec = importlib.util.spec_from_file_location("ss14_translate", _translate_path)
_mod = importlib.util.module_from_spec(_spec)  # type: ignore[arg-type]
_spec.loader.exec_module(_mod)  # type: ignore[union-attr]

FluentParser         = _mod.FluentParser
FluentSerializer     = _mod.FluentSerializer
F                    = _mod.F
call_ollama          = _mod.call_ollama
translate_entry      = _mod.translate_entry
translate_file       = _mod.translate_file
validate_translation = _mod.validate_translation
_entry_id            = _mod._entry_id
load_glossary        = _mod.load_glossary
load_tm              = _mod.load_tm
save_tm              = _mod.save_tm
find_en_us           = _mod.find_en_us
log                  = _mod.log
TOOLS_DIR            = _mod.TOOLS_DIR

# ── Snapshot ──────────────────────────────────────────────────────────────────
SNAPSHOT_FILE = TOOLS_DIR / "en-us-snapshot.json"


def _entry_hash(entry) -> str:
    """MD5 of the serialized entry — captures both structure and text."""
    text = FluentSerializer().serialize_entry(entry)
    return hashlib.md5(text.encode()).hexdigest()


def build_snapshot(en_root: Path) -> dict:
    """Hash every message in en-US. Returns {rel_path: {msg_id: md5}}."""
    snapshot: dict = {}
    parser = FluentParser(with_spans=False)
    for ftl in sorted(en_root.rglob("*.ftl")):
        rel = str(ftl.relative_to(en_root))
        src = ftl.read_text(encoding="utf-8-sig")
        resource = parser.parse(src)
        file_snap = {
            _entry_id(e): _entry_hash(e)
            for e in resource.body
            if isinstance(e, (F.Message, F.Term))
        }
        if file_snap:
            snapshot[rel] = file_snap
    return snapshot


def load_snapshot() -> dict:
    if SNAPSHOT_FILE.exists():
        return json.loads(SNAPSHOT_FILE.read_text(encoding="utf-8"))
    return {}


def save_snapshot(snapshot: dict) -> None:
    # compact JSON — no pretty-print needed, file is machine-read only
    SNAPSHOT_FILE.write_text(
        json.dumps(snapshot, ensure_ascii=False, separators=(",", ":")),
        encoding="utf-8",
    )


# ── Per-file update ───────────────────────────────────────────────────────────

def update_file(
    src: Path,
    dst: Path,
    file_snapshot: dict | None,
    glossary: dict,
    tm: dict,
    dry_run: bool,
) -> tuple[int, int, int, int, int]:
    """
    Bring dst (pt-BR) in sync with src (en-US).
    file_snapshot=None means the file is brand-new in en-US.
    Returns (new, changed, removed, unchanged, failed).
    """
    original_en = src.read_text(encoding="utf-8-sig")
    parser = FluentParser(with_spans=False)
    en_resource = parser.parse(original_en)

    en_entries: dict = {
        _entry_id(e): e
        for e in en_resource.body
        if isinstance(e, (F.Message, F.Term))
    }

    # Brand-new file → full translation via existing translate_file()
    if file_snapshot is None:
        success = translate_file(src, dst, glossary, tm, dry_run)
        n = len(en_entries)
        return (n, 0, 0, 0, 0) if success else (0, 0, 0, 0, n)

    # Classify each en-US message
    new_ids:       set[str] = set()
    changed_ids:   set[str] = set()
    unchanged_ids: set[str] = set()

    for eid, entry in en_entries.items():
        h = _entry_hash(entry)
        if eid not in file_snapshot:
            new_ids.add(eid)
        elif file_snapshot[eid] != h:
            changed_ids.add(eid)
        else:
            unchanged_ids.add(eid)

    # Keys in old snapshot that no longer exist in en-US
    removed_ids = set(file_snapshot) - set(en_entries)

    if not new_ids and not changed_ids and not removed_ids:
        return (0, 0, 0, len(unchanged_ids), 0)  # file unchanged — skip

    # Load existing pt-BR translations
    pt_entries: dict = {}
    if dst.exists():
        pt_resource = parser.parse(dst.read_text(encoding="utf-8"))
        pt_entries = {
            _entry_id(e): e
            for e in pt_resource.body
            if isinstance(e, (F.Message, F.Term))
        }

    def translate_fn(text: str, ctx: str, hint: str = "") -> str:
        return call_ollama(text, ctx, glossary, tm, hint)

    # Rebuild pt-BR body following en-US order
    # - unchanged → substitute existing pt-BR translation
    # - new/changed → translate fresh from en-US
    # - removed → skip (they no longer exist in en-US either)
    new_body = []
    failed_ids: set[str] = set()

    for node in en_resource.body:
        if not isinstance(node, (F.Message, F.Term)):
            new_body.append(node)  # preserve comments / whitespace from en-US
            continue

        eid = _entry_id(node)

        if eid in unchanged_ids and eid in pt_entries:
            new_body.append(pt_entries[eid])  # keep existing translation as-is
            continue

        # removed_ids are not in en_entries, so they'll never appear here;
        # but guard anyway in case of an unexpected state
        if eid in removed_ids:
            continue

        # New or changed — translate a deep copy so we never mutate en_resource
        entry_copy = copy.deepcopy(node)
        try:
            translate_entry(entry_copy, translate_fn, eid)
            new_body.append(entry_copy)
        except Exception as exc:
            log.error("    FAILED [%s]: %s", eid, exc)
            failed_ids.add(eid)
            # Fallback: keep old translation if available, else keep English
            new_body.append(pt_entries.get(eid, node))

    en_resource.body = new_body

    # Serialize
    try:
        translated_src = FluentSerializer().serialize(en_resource)
    except Exception as exc:
        log.error("    Serializer error: %s", exc)
        return (0, 0, 0, len(unchanged_ids), len(new_ids) + len(changed_ids))

    # Validate against current en-US
    errors = validate_translation(original_en, translated_src)
    if errors:
        log.error("    Validation FAILED:")
        for err in errors:
            log.error("      %s", err)
        return (0, 0, 0, len(unchanged_ids), len(new_ids) + len(changed_ids))

    counts = (
        len(new_ids), len(changed_ids), len(removed_ids),
        len(unchanged_ids), len(failed_ids),
    )

    if dry_run:
        if new_ids or changed_ids or removed_ids:
            sep = "─" * 56
            print(f"\n{sep}")
            print(f"  {src.name}  "
                  f"+{len(new_ids)} new  ~{len(changed_ids)} changed  -{len(removed_ids)} removed")
            for eid in sorted(new_ids):
                print(f"    + {eid}")
            for eid in sorted(changed_ids):
                print(f"    ~ {eid}")
            for eid in sorted(removed_ids):
                print(f"    - {eid}")
        return counts

    # Write
    dst.parent.mkdir(parents=True, exist_ok=True)
    dst.write_text(translated_src, encoding="utf-8")
    return counts


# ── Main ──────────────────────────────────────────────────────────────────────

def main() -> None:
    ap = argparse.ArgumentParser(
        description="Incremental pt-BR locale update — translates only what changed",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__,
    )
    ap.add_argument(
        "--repo", type=Path, default=Path(__file__).parent.parent,
        metavar="PATH", help="SS14 repo root (default: parent of tools/)",
    )
    ap.add_argument(
        "--init", action="store_true",
        help="Build/refresh snapshot from current en-US without translating",
    )
    ap.add_argument(
        "--dry-run", action="store_true",
        help="Show what would change without writing any file",
    )
    ap.add_argument("--verbose", "-v", action="store_true")
    args = ap.parse_args()

    if args.verbose:
        log.setLevel(logging.DEBUG)

    en_root = find_en_us(args.repo)

    # ── --init: snapshot only, no translation ────────────────────────────────
    if args.init:
        log.info("Building en-US snapshot...")
        snapshot = build_snapshot(en_root)
        save_snapshot(snapshot)
        total = sum(len(v) for v in snapshot.values())
        log.info("Saved: %d files, %d entries → %s", len(snapshot), total, SNAPSHOT_FILE)
        return

    # ── Update mode ──────────────────────────────────────────────────────────
    snapshot = load_snapshot()
    if not snapshot:
        log.error("No snapshot found. Initialize first:")
        log.error("  python tools/ss14-update.py --init")
        sys.exit(1)

    glossary = load_glossary()
    tm = load_tm()
    log.info("Glossary: %d terms | TM: %d entries", len(glossary), len(tm))
    if args.dry_run:
        log.info("*** DRY RUN — nothing will be written ***")

    en_files = {
        str(f.relative_to(en_root)): f
        for f in sorted(en_root.rglob("*.ftl"))
    }
    pt_root = en_root.parent / "pt-BR"

    total_new = total_changed = total_removed = total_unchanged = total_failed = 0
    files_touched = 0

    for rel_path, en_file in en_files.items():
        pt_file = pt_root / rel_path
        file_snap = snapshot.get(rel_path)  # None → new file

        new, changed, removed, unchanged, failed = update_file(
            en_file, pt_file, file_snap, glossary, tm, args.dry_run,
        )

        if new or changed or removed or failed:
            files_touched += 1
            log.info(
                "  %-52s  +%d ~%d -%d fail:%d",
                rel_path, new, changed, removed, failed,
            )

        total_new       += new
        total_changed   += changed
        total_removed   += removed
        total_unchanged += unchanged
        total_failed    += failed

    # ── Handle files deleted from en-US ──────────────────────────────────────
    deleted_files = set(snapshot) - set(en_files)
    for rel_path in sorted(deleted_files):
        pt_file = pt_root / rel_path
        if pt_file.exists():
            log.warning("  FILE REMOVED from en-US: %s", rel_path)
            if not args.dry_run:
                pt_file.unlink()
                log.info("    Deleted: %s", pt_file)

    # ── Persist ───────────────────────────────────────────────────────────────
    if not args.dry_run:
        log.info("Updating snapshot...")
        new_snapshot = build_snapshot(en_root)
        save_snapshot(new_snapshot)
        save_tm(tm)
        log.info("Snapshot and TM updated.")

    # ── Summary ───────────────────────────────────────────────────────────────
    log.info("─" * 48)
    if files_touched == 0 and not deleted_files:
        log.info("Everything is up-to-date. No changes needed.")
    else:
        log.info(
            "Files with changes: %d  |  Strings: +%d new  ~%d changed  "
            "-%d removed  %d unchanged  %d failed",
            files_touched,
            total_new, total_changed, total_removed, total_unchanged, total_failed,
        )

    if total_failed:
        sys.exit(1)


if __name__ == "__main__":
    main()
