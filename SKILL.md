---
name: product-reference-storyboard
description: Analyze reference video(s) plus a product image and produce either a visual storyboard or a strict JSON video-recreation prompt. Match the reference's observable shot sequence, timing, palette, grading, lighting, camera, transitions, motion, atmosphere, and effects while preserving the user's product identity. Invoke with /product-reference-storyboard.
metadata:
  author: openai-generated
  version: "2.0.0"
  compatibility: Agent Skills compatible clients including ChatGPT Skills, Claude/Claude Code, OpenAI Codex, and clients supporting the Agent Skills open format. Visual/video analysis capability is required for direct media understanding.
---

# Product Reference Storyboard v2

## Invocation

`/product-reference-storyboard`

## Mandatory mode selection

When invoked, determine the requested output mode. There are two primary modes:

1. `storyboard` — a shot-by-shot visual production storyboard, still returned as strict JSON by default.
2. `json_prompt` — a generator-ready JSON prompt designed to recreate the reference video as closely as observable, substituting the user's product while matching the reference visual treatment.

If the user has NOT selected a mode, ask only:

`اختار الإخراج: 1) Storyboard  2) JSON Prompt`

If the user already says storyboard, prompt, JSON, or an equivalent clear request, do not ask again.

## Fidelity objective

Treat the reference video as the master for all observable video characteristics except product identity. Aim for the closest reproducible match, but never promise literal pixel-perfect or physically exact reconstruction.

Lock and reproduce, shot by shot:

- shot count and cut order;
- shot durations and overall duration;
- aspect ratio and framing;
- location/environment appearance and spatial layout;
- background, surfaces, props, atmosphere and practical elements;
- dominant, secondary and accent colors;
- approximate palette values when visually inferable;
- exposure, contrast, saturation, white balance and color temperature;
- highlight rolloff, black level, bloom/halation, haze, glow and diffusion;
- camera height, angle, shot size, lens feel and perspective;
- camera motion, direction, speed, easing and stabilization character;
- depth of field, focus plane and focus transitions;
- subject/product motion and timing;
- transitions, speed ramps, motion blur, whip effects, match cuts, fades and other visible effects;
- reflections, shadows, specular highlights and material response;
- grain/noise/texture and final color-grade character.

Do not invent an exact LUT name, lens model, focal length, camera body, location address, RGB/HEX value, or effect setting unless it can be supported by the reference. When estimated, mark it as `estimated`.

## Product identity lock

The uploaded product image is the master for the replacement product. Preserve visible silhouette, geometry, proportions, materials, transparency, formula/product color, cap/closure, logo, label placement, typography arrangement and distinguishing marks. Do not silently redesign it. Never replace it with the reference brand/product.

When packaging text cannot reliably be generated, instruct the generator to preserve the supplied product-reference image rather than inventing text.

## Analysis workflow

### 1. Product analysis
Build `product_identity_lock` from the supplied product image(s).

### 2. Reference timeline decomposition
Inspect the full reference and identify every meaningful shot/cut. Record exact or estimated start/end timestamps and duration.

### 3. Visual fingerprint
Create a `reference_visual_fingerprint` containing:

- `palette`
- `color_grade`
- `lighting_signature`
- `camera_signature`
- `motion_signature`
- `effects_signature`
- `texture_signature`
- `environment_signature`

### 4. Shot reconstruction
For every shot describe the source visual, then map the user's product into the same visual role. Maintain temporal continuity and reference timing.

### 5. Fidelity pass
Before output, compare every shot against the reference and explicitly prevent drift in palette, lighting, environment, camera, effects, timing and product identity.

## Mode: storyboard

Return strict JSON unless the user explicitly requests another format. Include:

- reference summary and duration;
- product identity lock;
- reference visual fingerprint;
- shot-by-shot storyboard;
- for every shot: timestamp, duration, scene, composition, product placement/action, camera, lighting, color, effects, transition, continuity, generation prompt and negative constraints;
- final global continuity rules.

Storyboard prompts must be production-ready rather than generic prose.

## Mode: json_prompt

Return ONE strict JSON object optimized as a complete video-generation specification. It must include:

- `mode: "json_prompt"`;
- `goal`;
- `reference_lock`;
- `product_identity_lock`;
- `global_video_settings`;
- `reference_visual_fingerprint`;
- `timeline` with every shot in order;
- `global_negative_constraints`;
- `continuity_lock`;
- `fidelity_priority`.

Each timeline shot must include:

- `shot_id`
- `start_time`
- `end_time`
- `duration_seconds`
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

The prompt should explicitly tell the target generator to use the supplied reference video for temporal/visual guidance and the supplied product image for identity whenever the target system supports reference conditioning.

## Target model adaptation

If the user names Sora, Veo, Kling, Runway or another generator, preserve the canonical JSON but adapt wording/fields to capabilities that are actually known. Do not fabricate unsupported parameters. If no generator is named, use model-neutral JSON.

## Output rules

- JSON is the default machine-readable format in BOTH modes.
- No Markdown fences around final JSON unless explicitly requested.
- Double quotes only; no comments; no trailing commas.
- Keep observations distinct from estimates.
- Use `confidence` or `estimated: true` where needed.
- Never claim an exact match when information is hidden or technically unrecoverable.
- User instruction > product image for product identity > reference video for visual/timing language > generator constraints > clearly marked inference.

## Missing inputs

If video is missing, request/reference it. If product image is missing, request/reference it. If both are available and mode is known, proceed without unnecessary questions.

## References

- `references/output-schema.md`
- `references/quality-checklist.md`
- `examples/example-output.json`
