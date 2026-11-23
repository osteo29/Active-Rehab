# Active-Rehab video verification, entries 1-40

Checked 23 November 2026. Read-only review, no repository changes.

39 entries have an accepted mapping, including 9 replacements. EX-018 remains unresolved under strict sustained-hold matching. The JSON uses a null youtubeId for that entry, so it cannot be mistaken for an approved replacement.

## What changed

| Entry | Correction |
|---|---|
| EX-015 Bear Crawl Hold | Low-knee-hover bear plank replaces a DNS bear/leg-lift progression. |
| EX-022 Reverse Crunch | PureGym pelvis-curl demo replaces a video that avoids lifting the pelvis. |
| EX-028 Kettlebell Swing | PT-clinic hip-hinge swing replaces an overhead CrossFit swing. |
| EX-030 Nordic Hamstring Curl | Floor-based E3 Rehab demo replaces GHD setup. |
| EX-031 Fire Hydrant | Quadruped Zion PT demo replaces standing single-leg variant. |
| EX-036 Bulgarian Split Squat | Full E3 Rehab tutorial, correct section begins 3:28, replaces front-foot-elevated progression. |
| EX-037 Step-Up with Hip Drive | Explicit knee-drive tutorial replaces a generic glute-biased step-up. See interpretation caveat below. |
| EX-038 Reverse Hyper Extension | Dedicated reverse-hyper machine demo replaces inclined-bench/band variation. |
| EX-039 Standing Hip Thrust Machine | PureGym standing Booty Builder demo replaces reclined hip-thrust machine. |

## Unresolved

EX-018 Superman Hold: the supplied Children's Hospital Colorado demo uses repeated 1-2-second raises and an alternating progression. A sustained-hold OPEX candidate is live and embeddable, but its available storyboard was too blurry for strict visual signoff. Do not substitute automatically. Both candidate URLs and live flags are in the JSON.

## Caveats that matter

- EX-007 is a broader university spine video; the curl-up appears late, around 3:00. It is not a dedicated curl-up clip.
- EX-009 is a short-lever, knee-supported Copenhagen plank. If the intended prescription is long-lever/ankle-supported, do not treat this as interchangeable.
- EX-014 is a Short. Its exercise was visually confirmed, but no useful narration was recovered.
- EX-036 starts with regular split squats; use the dedicated rear-foot-elevated section at 3:28. A bare video ID starts from the beginning unless the player supports a start time.
- EX-037's name is ambiguous. The replacement explicitly adds opposite-knee drive, supported by an exercise page using the same name. The repository's heel-drive cue alone does not define the finish. Keep that interpretation visible rather than claiming perfect semantic certainty.
- EX-005 is a mixed-footage ab-wheel tutorial. This review confirms the movement, not the channel's professional credentials.
- General-fitness or strength-coach sources remain for some exercises. A correct movement and embeddable player do not prove clinical suitability or accuracy of every spoken claim.

## Verification standard

Every original candidate returned current YouTube player status OK and playableInEmbed=true. Every accepted replacement passed the same check. A bare embed page was not used as a failure test, because missing player referer context can produce Error 153 independently of embedding permission.

Visual review used distributed storyboard samples and larger crops, plus a live player view for the low-resolution Copenhagen storyboard. Primary video narration, descriptions, and clinic pages were reviewed where available. This is a movement-match and current-player check, not a full-length clinical-content review or a guarantee of future regional playback. Several primary pages provide no narration, which is not treated as invented transcript evidence.

The JSON supplies exact observed watch URLs, current titles/channels, per-entry evidence and caveats. Evidence images show the inspected original candidates and corrected cases. No patient treatment recommendation is implied.
