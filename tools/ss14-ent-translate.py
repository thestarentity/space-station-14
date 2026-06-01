#!/usr/bin/env python3
"""
ss14-ent-translate.py — Translate entity names/descriptions from YAML prototypes.

SS14 entities have `name` and `description` fields in YAML prototypes.
The game localizes them by looking for `ent-<Id>` keys in locale files.
This script:
  1. Scans Resources/Prototypes/**/*.yml for `type: entity` entries
  2. Skips abstract entities, entities with locale-key names, and already-translated ones
  3. Generates .ftl files in Resources/Locale/pt-BR/entities/<prototype-relative-path>/
  4. Translates via Ollama using the shared glossary + translation memory

Usage:
  # Test with a small folder first:
  python tools/ss14-ent-translate.py --proto-folder Entities/Objects/Tools --dry-run

  # Translate for real:
  python tools/ss14-ent-translate.py --proto-folder Entities/Objects/Tools

  # All entities (takes a long time):
  python tools/ss14-ent-translate.py --all
"""

import argparse
import importlib.util
import re
import sys
from pathlib import Path

import yaml  # PyYAML

# ── Import shared infra ───────────────────────────────────────────────────────
_translate_path = Path(__file__).parent / "ss14-translate.py"
_spec = importlib.util.spec_from_file_location("ss14_translate", _translate_path)
_mod = importlib.util.module_from_spec(_spec)  # type: ignore
_spec.loader.exec_module(_mod)                  # type: ignore

FluentParser         = _mod.FluentParser
FluentSerializer     = _mod.FluentSerializer
F                    = _mod.F
call_ollama          = _mod.call_ollama
validate_translation = _mod.validate_translation
load_glossary        = _mod.load_glossary
load_tm              = _mod.load_tm
save_tm              = _mod.save_tm
find_en_us           = _mod.find_en_us
log                  = _mod.log
TOOLS_DIR            = _mod.TOOLS_DIR
MAX_RETRIES          = _mod.MAX_RETRIES

# ── Prototype parsing ─────────────────────────────────────────────────────────

# Locale-key prefixes — names that already point to a locale key, skip these
_LOCALE_KEY_PREFIXES = (
    "ent-", "item-", "comp-", "examine-", "verb-",
    "action-", "reagent-", "job-", "species-",
)

_MARKUP_RE = re.compile(r"\[[^\]]+\]")


# Custom YAML loader that silently ignores SS14's !type:Foo custom tags
class _SS14Loader(yaml.SafeLoader):
    pass


def _ignore_unknown(loader: yaml.SafeLoader, tag_suffix: str, node: yaml.Node):
    if isinstance(node, yaml.MappingNode):
        return loader.construct_mapping(node, deep=True)
    if isinstance(node, yaml.SequenceNode):
        return loader.construct_sequence(node, deep=True)
    return loader.construct_scalar(node)


_SS14Loader.add_multi_constructor("", _ignore_unknown)


def _is_locale_key(name: str) -> bool:
    return any(name.startswith(p) for p in _LOCALE_KEY_PREFIXES)


def extract_entities(yml_file: Path) -> list[dict]:
    """
    Parse a YAML prototype file and return a list of translatable entities.
    Each dict has: id, name, description (optional), source_file.
    """
    try:
        text = yml_file.read_text(encoding="utf-8-sig", errors="ignore")
        prototypes = yaml.load(text, Loader=_SS14Loader)  # noqa: S506
    except Exception:
        return []

    if not isinstance(prototypes, list):
        return []

    entities = []
    for proto in prototypes:
        if not isinstance(proto, dict):
            continue
        if proto.get("type") != "entity":
            continue
        if proto.get("abstract"):
            continue

        eid = proto.get("id")
        name = proto.get("name", "")
        desc = proto.get("description", "")

        if not eid or not name:
            continue
        if _is_locale_key(str(name)):
            continue
        # Skip entities whose name is only markup (no translatable text)
        name_text = _MARKUP_RE.sub("", str(name)).strip()
        if not any(c.isalpha() for c in name_text):
            continue

        entities.append({
            "id": str(eid),
            "name": str(name),
            "description": str(desc) if desc else "",
            "source_file": yml_file,
        })

    return entities


# ── FTL generation ────────────────────────────────────────────────────────────

def _already_translated(eid: str, pt_entries: dict) -> bool:
    return f"ent-{eid}" in pt_entries


def _translate_entity_name(name: str, eid: str, glossary: dict, tm: dict) -> str:
    """
    Translate an entity name, preserving any [markup] tags by tokenizing them.
    """
    # Extract markup tags
    tags = _MARKUP_RE.findall(name)
    if not tags:
        return call_ollama(name, f"ent-{eid}", glossary, tm)

    # Replace markup with tokens
    tokenized = name
    for i, tag in enumerate(tags):
        tokenized = tokenized.replace(tag, f"⟦{i}⟧", 1)

    translated_tokenized = call_ollama(tokenized, f"ent-{eid}", glossary, tm)

    # Restore tokens
    for i, tag in enumerate(tags):
        translated_tokenized = translated_tokenized.replace(f"⟦{i}⟧", tag)

    return translated_tokenized


def generate_ftl_block(eid: str, name_pt: str, desc_pt: str) -> str:
    """Generate a single FTL entry for an entity."""
    # Escape any = in values (shouldn't be needed but defensive)
    block = f"ent-{eid} = {name_pt}\n"
    if desc_pt:
        block += f"    .desc = {desc_pt}\n"
    return block


# ── Per-file translation ──────────────────────────────────────────────────────

def translate_entities_in_file(
    yml_file: Path,
    proto_root: Path,
    pt_root: Path,
    glossary: dict,
    tm: dict,
    dry_run: bool,
) -> tuple[int, int, int]:
    """
    Translate all entities from yml_file into the matching pt-BR .ftl file.
    Returns (translated, skipped_exists, failed).
    """
    entities = extract_entities(yml_file)
    if not entities:
        return 0, 0, 0

    # Output path: pt-BR/entities/<yml relative path without .yml>.ftl
    rel = yml_file.relative_to(proto_root)
    out_ftl = pt_root / "entities" / rel.parent / (rel.stem + ".ftl")

    # Load existing translations to avoid re-doing
    existing_pt: dict = {}
    if out_ftl.exists():
        src = out_ftl.read_text(encoding="utf-8")
        res = FluentParser(with_spans=False).parse(src)
        for entry in res.body:
            if isinstance(entry, (F.Message, F.Term)):
                existing_pt[entry.id.name] = entry

    translated = failed = skipped = 0
    new_blocks: list[str] = []

    for ent in entities:
        eid = ent["id"]
        ftl_key = f"ent-{eid}"

        if ftl_key in existing_pt:
            skipped += 1
            continue

        name_en = ent["name"]
        desc_en = ent["description"]

        try:
            name_pt = _translate_entity_name(name_en, eid, glossary, tm)
            desc_pt = ""
            if desc_en:
                desc_pt = call_ollama(desc_en, f"ent-{eid}.desc", glossary, tm)

            block = generate_ftl_block(eid, name_pt, desc_pt)
            new_blocks.append(block)
            translated += 1

            if dry_run:
                print(f"  ent-{eid}:")
                print(f"    EN  name: {name_en}")
                print(f"    PT  name: {name_pt}")
                if desc_en:
                    print(f"    EN  desc: {desc_en[:80]}")
                    print(f"    PT  desc: {desc_pt[:80]}")

        except Exception as exc:
            log.error("  FAILED ent-%s: %s", eid, exc)
            failed += 1

    if new_blocks and not dry_run:
        content = "\n".join(new_blocks)
        out_ftl.parent.mkdir(parents=True, exist_ok=True)

        # Append to existing file or create new one
        if out_ftl.exists():
            out_ftl.write_text(
                out_ftl.read_text(encoding="utf-8") + "\n" + content,
                encoding="utf-8",
            )
        else:
            out_ftl.write_text(content, encoding="utf-8")

        log.info("  %s → %d entries → %s", yml_file.name, translated, out_ftl)

    return translated, skipped, failed


# ── Main ─────────────────────────────────────────────────────────────────────

def main() -> None:
    ap = argparse.ArgumentParser(
        description="Translate SS14 entity names/descriptions from YAML prototypes",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__,
    )
    ap.add_argument(
        "--repo", type=Path, default=Path(__file__).parent.parent,
        metavar="PATH",
    )
    ap.add_argument(
        "--proto-folder", metavar="SUBDIR",
        help="Subfolder under Resources/Prototypes/ (e.g. Entities/Objects/Tools)",
    )
    ap.add_argument("--all", action="store_true", help="Process all prototype files")
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("--verbose", "-v", action="store_true")
    args = ap.parse_args()

    import logging
    if args.verbose:
        log.setLevel(logging.DEBUG)

    proto_root = args.repo / "Resources" / "Prototypes"
    en_root    = find_en_us(args.repo)
    pt_root    = en_root.parent / "pt-BR"

    if args.proto_folder:
        yml_files = sorted((proto_root / args.proto_folder).rglob("*.yml"))
    elif args.all:
        yml_files = sorted(proto_root.rglob("*.yml"))
    else:
        ap.print_help()
        sys.exit(1)

    if not yml_files:
        log.error("No .yml files found.")
        sys.exit(1)

    glossary = load_glossary()
    tm = load_tm()
    log.info("Glossary: %d terms | TM: %d entries", len(glossary), len(tm))
    log.info("YAML files: %d", len(yml_files))
    if args.dry_run:
        log.info("*** DRY RUN — nothing will be written ***")

    total_translated = total_skipped = total_failed = 0

    for yml_file in yml_files:
        t, s, f = translate_entities_in_file(
            yml_file, proto_root, pt_root, glossary, tm, dry_run=args.dry_run,
        )
        total_translated += t
        total_skipped    += s
        total_failed     += f

    if not args.dry_run:
        save_tm(tm)
        log.info("TM saved (%d entries)", len(tm))

    log.info("─" * 40)
    log.info("Translated: %d | Already existed: %d | Failed: %d",
             total_translated, total_skipped, total_failed)
    if total_failed:
        sys.exit(1)


if __name__ == "__main__":
    main()
