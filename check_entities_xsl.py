#!/usr/bin/env python3
"""Check whether xslt/partials/entities.xsl and entities-setup.xsl match the
upstream versions in schnitzler-chronik-static and update them if they do not."""

import hashlib
import sys
from pathlib import Path
from urllib.request import urlopen

REMOTE_BASE = (
    "https://raw.githubusercontent.com/arthur-schnitzler/"
    "schnitzler-chronik-static/refs/heads/main/xslt/export/"
)
LOCAL_DIR = Path(__file__).parent / "xslt" / "partials"
FILES = ("entities.xsl", "entities-setup.xsl")


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def sync(filename: str) -> int:
    remote_url = REMOTE_BASE + filename
    local_path = LOCAL_DIR / filename

    with urlopen(remote_url) as response:
        remote_bytes = response.read()

    if local_path.exists():
        local_bytes = local_path.read_bytes()
        if sha256(local_bytes) == sha256(remote_bytes):
            print(f"{local_path} ist aktuell.")
            return 0
        print(f"{local_path} weicht vom Upstream ab – wird aktualisiert.")
    else:
        print(f"{local_path} fehlt – wird angelegt.")
        local_path.parent.mkdir(parents=True, exist_ok=True)

    local_path.write_bytes(remote_bytes)
    print(f"{local_path} wurde vom Upstream aktualisiert.")
    return 0


def main() -> int:
    exit_code = 0
    for filename in FILES:
        exit_code |= sync(filename)
    return exit_code


if __name__ == "__main__":
    sys.exit(main())
