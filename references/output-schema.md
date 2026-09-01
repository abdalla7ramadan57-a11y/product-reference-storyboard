# Output schema v2

The skill supports two modes. Both default to strict JSON.

## Shared top-level fields
- `skill`: `product-reference-storyboard`
- `version`: `2.0.0`
- `mode`: `storyboard` or `json_prompt`
- `reference_analysis`
- `product_identity_lock`
- `reference_visual_fingerprint`
- `fidelity_priority`

## reference_visual_fingerprint
Capture observable/estimated:
- palette: dominant/secondary/accent colors; values may be approximate and must be marked estimated
- color_grade: temperature, tint, contrast, saturation, black/highlight character
- lighting_signature: direction, softness, key/fill/rim behavior, practicals, specular response
- camera_signature: framing, angle, perspective/lens feel, movement
- motion_signature: speed, easing, stabilization, motion blur
- effects_signature: bloom, halation, haze, diffusion, grain, speed ramps, transitions, overlays
- texture_signature: skin/product/surface rendering character
- environment_signature: set/location, surfaces, props, spatial relationships

## Storyboard mode
Top-level `storyboard` array. Each shot contains:
`shot_id`, `start_time`, `end_time`, `duration_seconds`, `reference_observation`, `environment`, `composition`, `product_role`, `camera`, `lighting`, `color_grade`, `effects`, `motion`, `transition_in`, `transition_out`, `continuity`, `prompt`, `negative_prompt`, `confidence`.

## JSON Prompt mode
Top-level fields additionally include `goal`, `reference_lock`, `global_video_settings`, `timeline`, `global_negative_constraints`, `continuity_lock`.
Each `timeline` item uses the same shot fields, optimized as generator instructions.

## Validity
Valid JSON only by default: double quotes, no comments, no trailing commas, no prose outside the JSON object.
