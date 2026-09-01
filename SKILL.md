---
name: product-reference-storyboard
description: Analyze reference video(s) plus a product image and produce either a generator-ready Video JSON prompt or a detailed Storyboard. Match the reference's observable shot sequence, timing, palette, grading, lighting, camera, transitions, motion, atmosphere, and effects while preserving the user's product identity. Invoke with /product-reference-storyboard.
metadata:
  author: openai-generated
  version: "4.0.0"
  compatibility: Agent Skills compatible clients including ChatGPT Skills, Claude/Claude Code, OpenAI Codex, and clients supporting the Agent Skills open format. Visual/video analysis capability is required for direct media understanding.
---

# Product Reference Storyboard v4

## Invocation

`/product-reference-storyboard`

## Core UX rule

Never put missing-input notices, upload requests, mode questions, or setup messages inside JSON.

JSON is output only after the required media is available and a generation mode has been selected or clearly requested.

When an input is missing, communicate with a short normal-language UI message.

If the host supports interactive controls, use native buttons/choice chips and an attachment/file-picker action. If the host does not expose such controls to the skill, fall back to concise text choices. Do not pretend a native button or file picker exists when it does not.


## Bundled Companion UI fallback

The package includes `ui/launch-ui.ps1`, a Windows companion picker installed with the skill.

UI priority:

1. If the host exposes native buttons/file-picker actions, use those.
2. Otherwise, if running in a local agent with shell/filesystem access on Windows, launch the bundled Companion UI with `powershell.exe -NoProfile -ExecutionPolicy Bypass -File <skill-root>\ui\launch-ui.ps1`.
3. The Companion UI lets the user choose a reference video, product image, and `Video` or `Storyboard`; it writes `~/.product-reference-storyboard/inbox/current.json` containing the selected local paths and copies the invocation command to the clipboard.
4. A local agent that can read those paths may consume the manifest automatically.
5. A hosted/cloud chat cannot receive local files merely because the Companion UI selected them; in that case tell the user to attach the selected files using the host upload control. Never claim local selection uploaded a file to a hosted conversation.

Do not try to inject or modify ChatGPT/Claude client UI. The Companion UI is a separate local fallback.

## Input collection flow

### Reference video

If no reference video is attached, show a normal-language prompt equivalent to:

`Reference video?  Yes   No`

- If `Yes`: ask the user to attach/select the reference video. If the host supports a native file picker, use it.
- If `No`: continue to the next input.
- Never emit JSON for this step.

### Product image

If no product image is attached, show a normal-language prompt equivalent to:

`Product image?  Yes   No`

- If `Yes`: ask the user to attach/select the product image. If the host supports a native image/file picker, use it.
- If `No`: continue only when the requested task can be completed without a product lock; otherwise explain briefly that exact product replacement needs an image.
- Never emit JSON for this step.

### Auto-detect already attached media

Before asking anything, inspect conversation attachments/current message context:

- If a reference video is already present, do not ask for it again.
- If a product image is already present, do not ask for it again.
- If both are present, skip all upload questions.

## Mode selection

Once the required media is available, determine the requested output mode.

Primary user-facing choices are:

1. `Video`
2. `Storyboard`

If the user already wrote `video`, `videos`, `generate video`, `storyboard`, or a clear equivalent, do not ask again.

If the invocation contains only `/product-reference-storyboard` and the required media is already attached, show a normal-language choice:

`عايز Video ولا Storyboard؟`

If interactive controls are supported, render `Video` and `Storyboard` as quick choices. Otherwise use text.

Do not use JSON for the choice screen.

## Mode: Video

`Video` means: produce the best generator-ready JSON specification for recreating the supplied reference video with the user's product substituted into the matching visual role.

After `Video` is selected, do not ask unnecessary follow-up questions. Analyze immediately and return the final JSON prompt.

If the host has a real video-generation action available, the interface may expose a `Generate` action after the specification. The skill itself must not claim it generated a video unless a real video-generation tool/action was actually executed.

The generated specification must target the closest reproducible reference match for all observable characteristics while changing only what is required for the user's product.

## Mode: Storyboard

After `Storyboard` is selected, analyze immediately and return a shot-by-shot storyboard for the supplied product using the reference video as the visual master.

The storyboard must include detailed composition, location/set, product action, camera, lighting, palette/color grade, effects, motion, timing, transitions, continuity, generation prompt and negative constraints for every meaningful shot.

## Fidelity objective

Treat the reference video as the master for all observable video characteristics except product identity. Aim for the closest reproducible match, but never promise literal pixel-perfect reconstruction when hidden or unrecoverable information exists.

Lock and reproduce, shot by shot:

- shot count and cut order;
- shot durations and overall duration;
- aspect ratio and framing;
- location/environment appearance and spatial layout;
- background, surfaces, props, atmosphere and practical elements;
- dominant, secondary and accent colors;
- exposure, contrast, saturation, white balance and color temperature;
- highlight rolloff, black level, bloom/halation, haze, glow and diffusion;
- camera height, angle, shot size, lens feel and perspective;
- camera motion, direction, speed, easing and stabilization character;
- depth of field, focus plane and focus transitions;
- subject/product motion and timing;
- transitions, speed ramps, motion blur, whip effects, match cuts, fades and other visible effects;
- reflections, shadows, specular highlights and material response;
- grain/noise/texture and final color-grade character.

Do not invent exact LUT names, camera bodies, lens models, focal lengths, location addresses, RGB/HEX values, or effect settings unless supported by the reference. Mark inference as estimated.

## Product identity lock

The uploaded product image is the master for replacement-product identity. Preserve visible silhouette, geometry, proportions, materials, transparency, formula/product color, cap/closure, logo, label placement, typography arrangement and distinguishing marks.

Never silently redesign the product and never replace it with the reference brand/product.

When packaging text cannot reliably be regenerated, instruct the target generator to use/preserve the supplied product reference rather than inventing packaging text.

## Automatic execution rule

When all of these are true:

- `/product-reference-storyboard` has been invoked or the user clearly asks for this skill behavior;
- the reference video is present;
- the product image is present;
- the user selected or clearly requested `Video` or `Storyboard`;

then execute immediately. Do not respond with `ready`, `status`, `waiting`, `required_next_input`, or any other intermediate JSON envelope.

The next response must be the actual requested deliverable.

## Analysis workflow

1. Detect available media and missing media.
2. Collect missing inputs using normal-language UI only.
3. Resolve `Video` vs `Storyboard`.
4. Build `product_identity_lock` from product image(s).
5. Decompose the full reference timeline into meaningful shots/cuts.
6. Build the reference visual fingerprint: palette, grade, lighting, camera, motion, effects, textures and environment.
7. Reconstruct each shot with the user's product in the equivalent visual role.
8. Run a fidelity pass preventing drift in product identity, location, palette, lighting, camera, timing and effects.
9. Return only the final deliverable.

## Video JSON output

Return one strict JSON object. Use:

- `skill`
- `version`
- `mode: "video"`
- `goal`
- `reference_lock`
- `product_identity_lock`
- `global_video_settings`
- `reference_visual_fingerprint`
- `timeline`
- `global_negative_constraints`
- `continuity_lock`
- `fidelity_priority`
- `final_master_prompt`

Every timeline shot should include:

- `shot_id`
- `start_time`
- `end_time`
- `duration_seconds`
- `reference_observation`
- `environment`
- `composition`
- `product_role`
- `camera`
- `lighting`
- `color_grade`
- `effects`
- `motion`
- `transition_in`
- `transition_out`
- `prompt`
- `negative_prompt`
- `confidence`

## Storyboard output

Default to strict JSON unless the user explicitly requests a visual/text storyboard format.

Use:

- `skill`
- `version`
- `mode: "storyboard"`
- `reference_summary`
- `product_identity_lock`
- `reference_visual_fingerprint`
- `storyboard`
- `continuity_lock`
- `fidelity_priority`

Every storyboard shot should include timestamp, duration, reference observation, environment, composition, product placement/action, camera, lighting, color grade, effects, motion, transition, continuity, generation prompt, negative constraints and confidence.

## Target model adaptation

If the user names Sora, Veo, Kling, Runway or another generator, preserve the canonical content but adapt wording/fields only to capabilities that are actually known. Do not fabricate unsupported parameters.

If no generator is named, use model-neutral JSON.

## Output rules

- Missing-input and mode-selection messages are plain conversational text, never JSON.
- Final Video output is strict JSON by default.
- Final Storyboard output is strict JSON by default unless the user requests another storyboard presentation.
- No Markdown fences around final JSON unless explicitly requested.
- Double quotes only; no comments; no trailing commas.
- Keep observations separate from estimates.
- Use `confidence` and/or `estimated: true` where appropriate.
- Never claim an exact technical value that cannot be recovered from the reference.
- User instruction > product image for product identity > reference video for visual/timing language > generator constraints > clearly marked inference.

## References

- `references/output-schema.md`
- `references/quality-checklist.md`
- `examples/example-output.json`
