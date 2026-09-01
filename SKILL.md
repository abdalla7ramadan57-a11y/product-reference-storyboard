---
name: product-reference-storyboard
description: Analyze one or more reference videos plus a product image, then create a production-ready storyboard and generation prompts that preserve the product identity while matching the reference video's location, composition, camera language, lighting, pacing, and visual continuity. Use for product ads, UGC-style recreations, cinematic product shots, reference-to-storyboard tasks, or when the user asks to make a video "like this" from uploaded video/image references. Default output is strict JSON unless the user explicitly requests another prompt format.
metadata:
  author: openai-generated
  version: "1.0.0"
  compatibility: Agent Skills compatible clients including ChatGPT Skills, Claude/Claude Code, OpenAI Codex, and clients that support the Agent Skills open format. Visual/video analysis capability is required for direct media understanding.
---

# Product Reference Storyboard

Create a high-fidelity storyboard from reference video(s) and a product image. The product image defines product identity. The reference video defines scene language: location, staging, composition, camera, lighting, movement, pacing, transitions, and mood.

## Activation inputs

Use this skill when the user provides or refers to:

- one or more reference videos, clips, GIFs, or extracted frames;
- a product image or several product images;
- optionally a brand guide, logo, text, target duration, aspect ratio, or target video model.

If media is available, inspect it directly. Do not invent visual details that cannot be observed. When direct video inspection is unavailable, use any provided frames/transcript/description and mark uncertain fields accordingly.

## Core rules

1. **Product identity is immutable.** Preserve visible shape, proportions, colors, materials, label layout, logo placement, packaging geometry, cap/lid, texture, and distinctive product details. Do not silently redesign the product.
2. **Reference video controls visual language.** Recreate the observable location and scene structure as closely as the user's request permits: environment type, surfaces, architecture, props, spatial arrangement, time of day, lighting direction/quality, lens feel, camera height/angle, framing, depth of field, motion, blocking, pacing, and transitions.
3. **Do not confuse similarity with hallucination.** Separate observations from inferences. Use `confidence` fields when a detail is not fully visible.
4. **Continuity matters across shots.** Maintain product orientation, label direction, prop placement, lighting direction, surface, environment, wardrobe/hands (if any), and color treatment unless the reference intentionally changes them.
5. **Default output is strict JSON.** If the user does not explicitly request another prompt format, return JSON only: no Markdown fences, no prose before or after it.
6. **If the user names a target generator** (for example Sora, Veo, Runway, Kling, Midjourney, Flux, or another system), adapt prompt wording and supported fields while preserving the canonical JSON structure as much as possible.
7. **If the user asks for a different format**, follow that request instead of JSON.
8. Never claim pixel-perfect identity or exact physical-location reconstruction when the reference does not reveal enough information. Represent uncertainty explicitly.

## Workflow

### Step 1 — Inspect product identity

Build a compact product identity lock from the uploaded product image(s):

- category and silhouette;
- exact visible colors and materials;
- packaging geometry and proportions;
- label/logo/text placement;
- closures, handles, seams, embossing, transparency, reflections;
- distinguishing marks;
- angles that are safe to show without inventing unseen details.

Do not infer hidden label text or unseen sides as facts.

### Step 2 — Decompose the reference video

Break the reference into shots. For each shot capture:

- start/end time or relative order;
- location/environment;
- foreground / subject plane / background;
- product or actor placement;
- shot size and composition;
- camera height, angle, lens feel, camera movement;
- subject motion;
- lighting source, direction, hardness, color temperature, contrast;
- depth of field / focus behavior;
- key props, surfaces, architecture, weather, atmosphere;
- transition in/out;
- approximate duration and pacing;
- notable visual effect or grading.

If multiple cuts occur rapidly, still preserve shot boundaries unless the user asks for a simplified storyboard.

### Step 3 — Build the recreation plan

Map the user's product into the reference scene without redesigning it. Preserve the reference's composition and blocking where possible. If the reference subject has a different shape/size, adapt placement minimally so the user's product remains physically plausible.

For each shot, define:

- what from the reference must remain fixed;
- what is replaced by the user's product;
- product pose/orientation;
- exact camera and lighting intent;
- continuity notes to previous/next shot;
- generator-ready prompt;
- negative constraints to prevent product drift and scene drift.

### Step 4 — Output JSON

Use the canonical schema in `references/output-schema.md`.

The JSON must be syntactically valid. Use double quotes, no comments, no trailing commas, and no Markdown code fence.

For each shot, write the prompt as a dense production instruction, not a vague description. Include observable spatial relationships and camera behavior.

### Step 5 — Validate

Before returning the answer, mentally verify:

- valid JSON;
- every shot has a unique `shot_id`;
- durations are plausible and ordered;
- no product identity conflicts;
- location details remain consistent;
- camera and lighting instructions are actionable;
- unknown details are labeled as uncertain instead of fabricated.

If a local runtime is available, the agent may run:

`python scripts/validate_json.py <output.json>`

## Prompt-writing pattern

A strong shot prompt normally follows this semantic order inside one string:

`product identity lock -> exact environment -> product placement/action -> composition -> camera/lens/movement -> lighting -> materials/reflections -> depth/focus -> atmosphere/color grade -> continuity -> constraints`

Avoid empty adjectives such as "beautiful" or "premium" unless the reference visibly supports them. Prefer measurable visual descriptions.

## Reference fidelity hierarchy

When details conflict, apply this order:

1. explicit user instruction;
2. user's product image for product identity;
3. reference video for scene/camera/lighting/pacing;
4. target generator constraints;
5. reasonable production inference, clearly marked when uncertain.

## Missing inputs

If the product image is missing, still analyze the reference and return a storyboard template with `product_identity.status` set to `missing_input`.

If the video is missing, return a product identity analysis plus a storyboard shell and set `reference_analysis.status` to `missing_input`.

If both are present, do not ask unnecessary questions. Produce the best complete result from available evidence.

## Additional references

- Canonical JSON schema: `references/output-schema.md`
- Quality and fidelity checklist: `references/quality-checklist.md`
- Example output: `examples/example-output.json`
