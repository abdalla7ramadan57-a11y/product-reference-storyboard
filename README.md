# Quick Install

```powershell
irm "https://raw.githubusercontent.com/abdalla7ramadan57-a11y/product-reference-storyboard/main/install-remote.ps1" | iex
```

This installs the skill into the standard local Agent Skills and Claude-compatible skill directories. The remote installer downloads the original `v2.0.0` release package and verifies its SHA-256 checksum before running the bundled installer.

# Product Reference Storyboard Skill v2

A portable Agent Skill for turning reference video(s) + a product image into a high-fidelity product storyboard and generator-ready prompts.

## Default behavior

- Reference video defines location, camera, lighting, composition, pacing, motion, and transitions.
- Product image defines immutable product identity.
- Output is strict JSON unless the user explicitly asks for another format.
- Each shot includes observation, recreation instructions, generation prompt, negative constraints, continuity notes, and confidence.

## Install locally with PowerShell

From an extracted copy of this package:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\install.ps1
```

By default this installs to both:

- `~/.agents/skills/product-reference-storyboard` for cross-client Agent Skills convention.
- `~/.claude/skills/product-reference-storyboard` for Claude compatibility.

Choose one target:

```powershell
.\install.ps1 -Target Agents
.\install.ps1 -Target Claude
```

Replace an existing install:

```powershell
.\install.ps1 -Force
```

```text
/product-reference-storyboard
```

## ChatGPT

ChatGPT Skills are hosted in your ChatGPT account/workspace, so a local PowerShell script cannot install directly into the hosted product. Upload the ZIP through the ChatGPT Skills create/upload flow if your account/workspace has Skills enabled.

## Claude / compatible local agents

The package uses the open Agent Skills `SKILL.md` format. Local compatible clients can discover it from their supported skills directories. The installer writes both the cross-client `.agents/skills/` location and the common Claude `.claude/skills/` location.

## Example request

"Use this video as the exact visual reference and this image as the product. Recreate the storyboard shot by shot. Keep the same location, camera, lighting and pacing. Output JSON."

## Files

- `SKILL.md` — main instructions and activation metadata.
- `references/output-schema.md` — canonical JSON structure.
- `references/quality-checklist.md` — fidelity checks.
- `examples/example-output.json` — sample output.
- `scripts/validate_json.py` — optional JSON validator.
- `install.ps1` / `uninstall.ps1` — Windows PowerShell helpers.
- `install-remote.ps1` — checksum-verified one-line installer for the GitHub release.


## Output modes

Invoke with:

`/product-reference-storyboard`

Then choose:

- `1` — Storyboard: shot-by-shot reconstruction plan with prompts.
- `2` — JSON Prompt: one complete JSON video-generation specification matching the reference timeline, palette, grade, lighting, camera, transitions and visible effects while preserving the supplied product identity.

If the mode is not specified, the skill asks: `اختار الإخراج: 1) Storyboard  2) JSON Prompt`.
