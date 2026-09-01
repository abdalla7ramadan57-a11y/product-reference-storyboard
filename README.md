# Quick Install

Run this command in PowerShell (not Command Prompt):

```powershell
irm "https://raw.githubusercontent.com/abdalla7ramadan57-a11y/product-reference-storyboard/35b602f28c7e51964cb7c1bdb1fa295b9a1e924d/install-remote.ps1" | iex
```

If your terminal says **Command Prompt** or shows a prompt such as `C:\Users\name>`, use this CMD-compatible command instead:

```cmd
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -Command "Invoke-RestMethod 'https://raw.githubusercontent.com/abdalla7ramadan57-a11y/product-reference-storyboard/35b602f28c7e51964cb7c1bdb1fa295b9a1e924d/install-remote.ps1' | Invoke-Expression"
```

This installs or upgrades the skill and its Windows companion UI. The remote installer verifies the original `v4.0.0` release package and uses a process-scoped execution-policy bypass without changing the permanent Windows policy.

<p align="center">
  <a href="https://www.instagram.com/abdallah_ramadan88?igsi=MjAyMG82bHJqajJj">
    <img src="https://img.shields.io/badge/Instagram-%40abdallah__ramadan88-E4405F?style=for-the-badge&amp;logo=instagram&amp;logoColor=white" alt="Follow @abdallah_ramadan88 on Instagram">
  </a>
</p>

# Product Reference Storyboard Skill v4

A portable Agent Skill that converts a reference video + product image into either a high-fidelity Video JSON prompt or a detailed Storyboard.

## Invoke

`/product-reference-storyboard`

## v4 flow

The skill does not put setup questions inside JSON.

If media is missing it asks with normal messages, using native choice buttons/file pickers when the host actually supports them and concise text fallback otherwise.

Typical flow:

1. Reference video? `Yes / No`
2. Product image? `Yes / No`
3. Output? `Video / Storyboard`
4. If `Video`: immediately return the final generator-ready JSON.
5. If `Storyboard`: immediately return the full shot-by-shot storyboard.

If the video and product image are already attached, the skill skips the upload questions automatically.

If the user writes `/product-reference-storyboard video` with both media inputs attached, it goes straight to the Video JSON output.

If the user writes `/product-reference-storyboard storyboard` with both media inputs attached, it goes straight to the Storyboard output.

## Fidelity target

Reference video controls shot order, duration, composition, set/location, palette, grade, lighting, camera movement, depth of field, transitions, motion blur, bloom/halation, texture and visible effects. Product image controls product identity and packaging.

The skill aims for the closest reproducible match while avoiding unsupported claims such as invented exact LUT names or camera/lens metadata.

## Install locally with PowerShell

From an extracted copy:

```powershell
Set-ExecutionPolicy -Scope Process Bypass -Force
.\install.ps1
```

Default install targets:

- `~/.agents/skills/product-reference-storyboard`
- `~/.claude/skills/product-reference-storyboard`

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

## Important UI note

`SKILL.md` can instruct a compatible host to use buttons or file-picker controls when available, but it cannot itself force ChatGPT, Claude, Codex, or another client to expose a native `Yes/No`, `Generate`, or file-picker widget. When the host does not expose those controls, the skill uses normal conversational choices instead.

## Files

- `SKILL.md` — skill behavior and invocation rules.
- `references/output-schema.md` — v4 output contract.
- `references/quality-checklist.md` — fidelity and UX checks.
- `examples/example-output.json` — sample final Video JSON.
- `scripts/validate_json.py` — JSON validator.
- `install.ps1` / `uninstall.ps1` — Windows PowerShell helpers.
- `install-remote.ps1` — checksum-verified one-line installer for the GitHub release.


## Bundled Windows Companion UI

The installer also installs a small local picker UI. It can choose:

- Reference video
- Product image
- Video JSON Prompt or Storyboard

A Desktop/Start Menu shortcut named `Product Reference Storyboard` is created.

The companion UI is a fallback for clients that do not expose native skill UI actions. It does **not** inject controls into ChatGPT or Claude, and hosted chat still requires files to be attached through the host upload control. Local agents with filesystem access can read the saved manifest at `~/.product-reference-storyboard/inbox/current.json`.
