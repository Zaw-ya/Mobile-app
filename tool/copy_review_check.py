"""Copy-review safety check for the translation files.

Usage (from the repo root, before every copy-review commit):

    python tool/copy_review_check.py            # compare working tree against HEAD
    python tool/copy_review_check.py --base main

Checks:
  1. ar.json / en.json are valid JSON with no duplicate keys.
  2. EN <-> AR key parity: no key may be missing from one file unless it was
     already missing at the base revision (pre-existing gaps are reported only).
  3. Placeholder parity: for every key whose value changed since the base, the
     placeholders ({}, {name}) and the number of line breaks (\\n) are unchanged.
  4. Lists every added / removed / changed key so it can be matched to the
     commit's 02_MAPPING rows.

Exit code 0 = OK, 1 = at least one error.
"""

import argparse
import json
import re
import subprocess
import sys

FILES = {
    "ar": "assets/translations/ar.json",
    "en": "assets/translations/en.json",
}
PLACEHOLDER = re.compile(r"\{[A-Za-z_]*\}")


def _no_duplicates(pairs):
    seen = {}
    dups = []
    for k, v in pairs:
        if k in seen:
            dups.append(k)
        seen[k] = v
    if dups:
        raise ValueError(f"duplicate keys: {', '.join(dups)}")
    return seen


def load(text, label):
    try:
        return json.loads(text, object_pairs_hook=_no_duplicates)
    except ValueError as e:
        raise SystemExit(f"ERROR {label}: {e}")


def read_base(ref, path):
    out = subprocess.run(
        ["git", "show", f"{ref}:{path}"], capture_output=True, check=True
    )
    return out.stdout.decode("utf-8-sig")


def signature(value):
    return sorted(PLACEHOLDER.findall(value)), value.count("\n")


def main():
    sys.stdout.reconfigure(encoding="utf-8")
    parser = argparse.ArgumentParser()
    parser.add_argument("--base", default="HEAD", help="git revision to compare with")
    args = parser.parse_args()

    errors = []
    cur, base = {}, {}
    for lang, path in FILES.items():
        with open(path, encoding="utf-8-sig") as f:
            cur[lang] = load(f.read(), path)
        base[lang] = load(read_base(args.base, path), f"{args.base}:{path}")
        print(f"OK   {path}: valid JSON, {len(cur[lang])} keys, no duplicates")

    # 2. key parity
    for a, b in (("en", "ar"), ("ar", "en")):
        missing = set(cur[a]) - set(cur[b])
        was_missing = set(base[a]) - set(base[b])
        for k in sorted(missing - was_missing):
            errors.append(f"key parity: '{k}' is in {a} but not in {b}")
        for k in sorted(missing & was_missing):
            print(f"NOTE pre-existing gap: '{k}' only in {a}")

    # 3 + 4. changed keys and placeholder parity
    for lang in FILES:
        old, new = base[lang], cur[lang]
        for k in sorted(set(new) - set(old)):
            print(f"ADD  {lang} {k}")
        for k in sorted(set(old) - set(new)):
            print(f"DEL  {lang} {k}")
        for k in sorted(set(old) & set(new)):
            if old[k] == new[k]:
                continue
            print(f"CHG  {lang} {k}")
            if signature(old[k]) != signature(new[k]):
                errors.append(
                    f"placeholder parity: {lang} '{k}' {signature(old[k])} -> {signature(new[k])}"
                )

    # cross-language placeholder check for keys touched in this diff
    touched = {k for lang in FILES for k in cur[lang] if base[lang].get(k) != cur[lang][k]}
    for k in sorted(touched):
        if k in cur["ar"] and k in cur["en"]:
            pa = sorted(PLACEHOLDER.findall(cur["ar"][k]))
            pe = sorted(PLACEHOLDER.findall(cur["en"][k]))
            if pa != pe:
                errors.append(f"AR/EN placeholder mismatch in '{k}': ar {pa} vs en {pe}")

    if errors:
        for e in errors:
            print(f"ERROR {e}")
        return 1
    print("PASS")
    return 0


if __name__ == "__main__":
    sys.exit(main())
