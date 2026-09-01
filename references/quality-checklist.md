# Fidelity and UX checklist v3

Before responding verify:

- detect existing video/image attachments before asking for uploads;
- missing-input messages are conversational text, never JSON;
- use native buttons/file picker only when the host actually supports them;
- otherwise use concise text fallback without pretending controls exist;
- mode is Video or Storyboard;
- if media + mode are known, execute immediately without status JSON;
- product identity comes from product image, not reference brand;
- all meaningful cuts are represented and ordered;
- total timeline approximately matches reference duration;
- environment and spatial relationships follow the reference;
- palette, temperature, contrast, saturation and highlight/black behavior are captured;
- visible bloom, haze, diffusion, grain, motion blur, speed ramps and transitions are captured;
- camera angle, framing, movement direction/speed and focus behavior are actionable;
- continuity prevents product, color, lighting, set and orientation drift;
- estimates are marked and unsupported technical values are not invented;
- negative constraints block wrong brand/product, packaging drift, color drift, location drift and effect drift;
- final JSON is syntactically valid when JSON output is requested/default.
