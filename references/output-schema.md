# Canonical JSON Output Schema

Return one JSON object. This is a semantic schema; fields may be extended for a named target model, but core fields should remain.

```json
{
  "schema_version": "1.0",
  "task": "reference_video_to_product_storyboard",
  "output_format": "json",
  "source_summary": {
    "reference_video_count": 1,
    "product_image_count": 1,
    "target_duration_seconds": null,
    "aspect_ratio": null,
    "target_generator": null
  },
  "product_identity": {
    "status": "observed",
    "category": "",
    "identity_lock": [],
    "visible_text": [],
    "materials": [],
    "colors": [],
    "geometry": [],
    "do_not_change": [],
    "uncertain_or_unseen": []
  },
  "reference_analysis": {
    "status": "observed",
    "overall_location": "",
    "environment_lock": [],
    "lighting_language": "",
    "camera_language": "",
    "color_grade": "",
    "pacing": "",
    "continuity_lock": [],
    "uncertainties": []
  },
  "storyboard": [
    {
      "shot_id": "S01",
      "source_timecode": {
        "start": "00:00.000",
        "end": "00:02.000"
      },
      "duration_seconds": 2.0,
      "reference_observation": {
        "location": "",
        "foreground": "",
        "subject_plane": "",
        "background": "",
        "composition": "",
        "camera": {
          "shot_size": "",
          "height": "",
          "angle": "",
          "lens_feel": "",
          "movement": ""
        },
        "lighting": {
          "source": "",
          "direction": "",
          "quality": "",
          "temperature": "",
          "contrast": ""
        },
        "action": "",
        "focus_and_dof": "",
        "transition_in": "",
        "transition_out": "",
        "confidence": 0.0
      },
      "recreation": {
        "keep_from_reference": [],
        "replace_with_product": "",
        "product_pose": "",
        "continuity_notes": [],
        "generation_prompt": "",
        "negative_prompt": []
      }
    }
  ],
  "global_generation_constraints": {
    "must_preserve": [],
    "must_avoid": [],
    "continuity": [],
    "rendering_notes": []
  },
  "final_master_prompt": "",
  "quality_control": {
    "json_valid": true,
    "product_identity_consistent": true,
    "reference_location_consistent": true,
    "shot_continuity_consistent": true,
    "known_limitations": []
  }
}
```

## Field rules

- `confidence`: number from 0.0 to 1.0.
- `source_timecode`: use real timecodes if observable; otherwise use relative labels and state that timing is estimated.
- `generation_prompt`: one generator-ready instruction for that shot.
- `negative_prompt`: array of concrete failure modes, especially product redesign, wrong label/logo, wrong package shape, duplicate products, wrong surface, wrong background architecture, wrong camera angle, wrong lighting direction, floating objects, warped geometry, unreadable brand marks, and inconsistent continuity.
- `final_master_prompt`: optional concatenated/director-level instruction tying all shots together. Keep it consistent with per-shot prompts.
- When the target generator has no negative-prompt concept, retain `negative_prompt` in the canonical JSON as constraints unless the user requests the generator's native schema only.
