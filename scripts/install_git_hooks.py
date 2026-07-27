#!/usr/bin/env python3
"""
Copy GoldenAltos git hooks into .git/hooks/ (one-time setup per clone).

Usage from repo root:
  python scripts/install_git_hooks.py
"""

from __future__ import annotations

import shutil
import stat
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[1]
SRC = REPO_ROOT / "scripts" / "hooks" / "pre-commit"
DEST_DIR = REPO_ROOT / ".git" / "hooks"
DEST = DEST_DIR / "pre-commit"


def main() -> int:
    if not (REPO_ROOT / ".git").is_dir():
        print("ERROR: .git directory not found. Run from a git clone.")
        return 1
    if not SRC.is_file():
        print(f"ERROR: Hook source missing: {SRC}")
        return 1

    DEST_DIR.mkdir(parents=True, exist_ok=True)
    shutil.copy2(SRC, DEST)
    DEST.chmod(DEST.stat().st_mode | stat.S_IEXEC | stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH)
    print(f"Installed pre-commit hook -> {DEST}")
    print("Commits that change catalog.4DCatalog will run scripts/validate_catalog.py.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
