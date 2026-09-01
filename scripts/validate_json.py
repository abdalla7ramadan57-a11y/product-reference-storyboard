#!/usr/bin/env python3
import json
import sys
from pathlib import Path

REQUIRED_TOP = {
    "schema_version",
    "task",
    "output_format",
    "product_identity",
    "reference_analysis",
    "storyboard",
    "global_generation_constraints",
    "quality_control",
}


def fail(message: str) -> None:
    print(f"INVALID: {message}")
    raise SystemExit(1)


def main() -> None:
    if len(sys.argv) != 2:
        fail("usage: validate_json.py <output.json>")
    path = Path(sys.argv[1])
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except FileNotFoundError:
        fail(f"file not found: {path}")
    except json.JSONDecodeError as e:
        fail(f"JSON syntax error at line {e.lineno}, column {e.colno}: {e.msg}")

    if not isinstance(data, dict):
        fail("top-level JSON value must be an object")

    missing = REQUIRED_TOP - set(data)
    if missing:
        fail("missing top-level fields: " + ", ".join(sorted(missing)))

    if data.get("output_format") != "json":
        fail('output_format must be "json"')

    shots = data.get("storyboard")
    if not isinstance(shots, list):
        fail("storyboard must be an array")

    ids = []
    for i, shot in enumerate(shots, start=1):
        if not isinstance(shot, dict):
            fail(f"storyboard item {i} must be an object")
        sid = shot.get("shot_id")
        if not sid:
            fail(f"storyboard item {i} is missing shot_id")
        ids.append(sid)
        recreation = shot.get("recreation", {})
        if not recreation.get("generation_prompt"):
            fail(f"shot {sid} is missing recreation.generation_prompt")

    if len(ids) != len(set(ids)):
        fail("shot_id values must be unique")

    print(f"VALID: {path} ({len(shots)} shots)")


if __name__ == "__main__":
    main()
