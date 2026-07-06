#!/usr/bin/env python3
"""
Validate Project/Sources/catalog.4DCatalog before commit or 4D structure sync.

Default mode catches the recurring catastrophic bug (same UUID on table + all fields),
forbidden placeholders, invalid UUID length, XML errors, and section order.

Usage:
  python scripts/validate_catalog.py           # default (recommended for pre-commit)
  python scripts/validate_catalog.py --strict  # also check index/relation refs and all field dupes

Exit 0 = OK, 1 = validation errors, 2 = file missing.
"""

from __future__ import annotations

import argparse
import re
import sys
from collections import Counter
from pathlib import Path
from xml.etree import ElementTree as ET

REPO_ROOT = Path(__file__).resolve().parents[1]
CATALOG_PATH = REPO_ROOT / "Project" / "Sources" / "catalog.4DCatalog"

UUID_RE = re.compile(r"^[0-9A-Fa-f]{32}$")

FORBIDDEN_PLACEHOLDERS = frozenset(
    {
        "42324532463341344235433634373839",
        "4A314532463341344235433634373839",
        "00000000000000000000000000000000",
        "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF",
    }
)


def err(errors: list[str], msg: str) -> None:
    errors.append(msg)


def validate_uuid_format(errors: list[str], uuid: str, context: str) -> None:
    if not UUID_RE.match(uuid):
        err(errors, f"{context}: invalid UUID '{uuid}' (must be exactly 32 hex chars, got {len(uuid)})")
    if uuid in FORBIDDEN_PLACEHOLDERS:
        err(errors, f"{context}: forbidden placeholder UUID '{uuid}'")


def parse_tables_from_xml(root: ET.Element) -> list[dict]:
    tables: list[dict] = []
    for table_el in root.findall("table"):
        name = table_el.get("name", "")
        table_uuid = table_el.get("uuid", "")
        table_id = table_el.get("id", "")
        fields: dict[str, str] = {}
        for field_el in table_el.findall("field"):
            fields[field_el.get("name", "")] = field_el.get("uuid", "")
        pk_el = table_el.find("primary_key")
        pk_name = pk_el.get("field_name", "") if pk_el is not None else ""
        pk_uuid = pk_el.get("field_uuid", "") if pk_el is not None else ""
        tables.append(
            {
                "name": name,
                "id": table_id,
                "table_uuid": table_uuid,
                "fields": fields,
                "pk_name": pk_name,
                "pk_uuid": pk_uuid,
            }
        )
    return tables


def validate_table_blocks(errors: list[str], tables: list[dict], strict: bool) -> None:
    seen_ids: dict[str, str] = {}
    seen_table_uuids: dict[str, str] = {}

    for t in tables:
        name = t["name"]
        table_uuid = t["table_uuid"]
        ctx = f'Table "{name}" (id={t["id"]})'

        validate_uuid_format(errors, table_uuid, ctx + " table uuid")

        if t["id"] in seen_ids:
            err(errors, f'Table id="{t["id"]}" reused by "{name}" and "{seen_ids[t["id"]]}"')
        seen_ids[t["id"]] = name

        if table_uuid in seen_table_uuids:
            err(errors, f'Table uuid collision: "{name}" and "{seen_table_uuids[table_uuid]}" share {table_uuid}')
        seen_table_uuids[table_uuid] = name

        field_uuids = list(t["fields"].values())

        for fname, fuuid in t["fields"].items():
            validate_uuid_format(errors, fuuid, f'{ctx} field "{fname}"')

        # Catastrophic pattern: one UUID reused for table and every field (Bank / JournalEntry bug).
        all_defs = [table_uuid] + field_uuids
        if field_uuids and len(set(all_defs)) == 1:
            err(
                errors,
                f"{ctx}: FATAL — same UUID on table and ALL fields ({table_uuid}). "
                "Each element needs its own 32-char hex UUID.",
            )

        if table_uuid in field_uuids:
            err(
                errors,
                f"{ctx}: table uuid equals at least one field uuid ({table_uuid})",
            )

        if strict:
            dup_fields = [u for u, n in Counter(field_uuids).items() if n > 1]
            for du in dup_fields:
                dup_names = [n for n, u in t["fields"].items() if u == du]
                err(errors, f'{ctx}: duplicate field uuid {du} on fields {dup_names}')

        if t["pk_name"]:
            if t["pk_name"] not in t["fields"]:
                err(errors, f'{ctx}: primary_key references unknown field "{t["pk_name"]}"')
            elif t["pk_uuid"] != t["fields"][t["pk_name"]]:
                err(
                    errors,
                    f'{ctx}: primary_key field_uuid must match field "{t["pk_name"]}"',
                )


def validate_refs_strict(errors: list[str], root: ET.Element, tables: list[dict]) -> None:
    table_uuid_by_name = {t["name"]: t["table_uuid"] for t in tables}
    by_table = {t["name"]: t["fields"] for t in tables}

    for parent_tag in ("relation", "index"):
        for el in root.findall(parent_tag):
            for field_ref in el.findall(".//field_ref"):
                field_uuid = field_ref.get("uuid", "")
                field_name = field_ref.get("name", "")
                table_ref = field_ref.find("table_ref")
                if table_ref is None:
                    continue
                table_name = table_ref.get("name", "")
                ref_table_uuid = table_ref.get("uuid", "")
                validate_uuid_format(errors, field_uuid, f"Ref {table_name}.{field_name}")
                if table_name not in by_table:
                    err(errors, f'Ref points to unknown table "{table_name}" ({field_name})')
                    continue
                if table_uuid_by_name[table_name] != ref_table_uuid:
                    err(
                        errors,
                        f'Ref {table_name}.{field_name}: table_ref uuid mismatch',
                    )
                if field_name not in by_table[table_name]:
                    err(errors, f'Ref {table_name}.{field_name}: field does not exist')
                elif by_table[table_name][field_name] != field_uuid:
                    err(
                        errors,
                        f'Ref {table_name}.{field_name}: field_ref uuid mismatch',
                    )


def validate_section_order(errors: list[str], text: str) -> None:
    first_table = text.find("<table ")
    first_relation = text.find("<relation ")
    first_index = text.find("<index ")
    if first_table == -1:
        err(errors, "No <table> elements found")
        return
    if first_relation != -1 and first_relation < first_table:
        err(errors, "<relation> before <table> — wrong section order")
    if first_index != -1:
        if first_relation != -1 and first_index < first_relation:
            err(errors, "<index> before <relation> — wrong section order")
        last_table = text.rfind("</table>")
        if last_table != -1 and first_index < last_table:
            err(errors, "<index> inside tables section — wrong section order")


def validate_catalog(path: Path, strict: bool = False) -> list[str]:
    errors: list[str] = []
    if not path.is_file():
        err(errors, f"Catalog not found: {path}")
        return errors

    text = path.read_text(encoding="utf-8")

    for placeholder in FORBIDDEN_PLACEHOLDERS:
        if placeholder in text:
            err(errors, f"Forbidden placeholder UUID in catalog: {placeholder}")

    try:
        root = ET.parse(path).getroot()
    except ET.ParseError as e:
        err(errors, f"XML parse error: {e}")
        return errors

    for uuid in re.findall(r'uuid="([0-9A-Fa-f]+)"', text):
        validate_uuid_format(errors, uuid, "Global scan")

    validate_section_order(errors, text)
    tables = parse_tables_from_xml(root)
    validate_table_blocks(errors, tables, strict=strict)

    if strict:
        validate_refs_strict(errors, root, tables)

    return errors


def main() -> int:
    parser = argparse.ArgumentParser(description="Validate catalog.4DCatalog")
    parser.add_argument("path", nargs="?", default=str(CATALOG_PATH), help="Path to catalog file")
    parser.add_argument(
        "--strict",
        action="store_true",
        help="Also validate all field UUID duplicates and index/relation refs",
    )
    args = parser.parse_args()

    path = Path(args.path)
    errors = validate_catalog(path, strict=args.strict)

    if errors:
        print(f"CATALOG VALIDATION FAILED ({len(errors)} error(s)):", file=sys.stderr)
        print(f"  File: {path}", file=sys.stderr)
        for i, e in enumerate(errors, 1):
            print(f"  [{i}] {e}", file=sys.stderr)
        print(file=sys.stderr)
        print("Fix before commit or 4D structure sync. See .cursor/rules/4d-catalog-structure.mdc", file=sys.stderr)
        return 1

    mode = "strict" if args.strict else "default"
    print(f"OK: {path} passed catalog validation ({mode}).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
