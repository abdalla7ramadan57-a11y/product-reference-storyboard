# Output schema v3

## Interaction states are NOT JSON

Never emit JSON for:
- missing reference video;
- missing product image;
- Yes/No upload questions;
- Video/Storyboard selection;
- attachment instructions;
- readiness/status messages.

Use concise normal-language UI for those states.

## Video mode

Top-level fields:
- `skill`: `product-reference-storyboard`
- `version`: `3.0.0`
- `mode`: `video`
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

Each `timeline` shot:
`shot_id`, `start_time`, `end_time`, `duration_seconds`, `reference_observation`, `environment`, `composition`, `product_role`, `camera`, `lighting`, `color_grade`, `effects`, `motion`, `transition_in`, `transition_out`, `prompt`, `negative_prompt`, `confidence`.

## Storyboard mode

Top-level fields:
- `skill`
- `version`
- `mode`: `storyboard`
- `reference_summary`
- `product_identity_lock`
- `reference_visual_fingerprint`
- `storyboard`
- `continuity_lock`
- `fidelity_priority`

Each `storyboard` shot:
`shot_id`, `start_time`, `end_time`, `duration_seconds`, `reference_observation`, `environment`, `composition`, `product_role`, `camera`, `lighting`, `color_grade`, `effects`, `motion`, `transition_in`, `transition_out`, `continuity`, `prompt`, `negative_prompt`, `confidence`.

## JSON validity

Final machine outputs use valid JSON only by default: double quotes, no comments, no trailing commas, no prose outside the JSON object.
