# Video source checks

Videos remain hosted by their original publishers. The application embeds the publisher-enabled YouTube player and links back to YouTube; it does not download or redistribute the videos.

The source ledger records exact exercise matches, channel, title, public URL, check date, oEmbed success and publisher embedding permission. Availability, ads, sign-in and regional restrictions remain under YouTube control. No ad-free playback guarantee is made.

Unmatched or conditional variants retain the unavailable-video state. A similar-looking exercise is not silently substituted.

## Checked coverage (2026-11-23)

113 of 117 exercises have movement-matched YouTube demos; 4 have no verified exact match (seated calf raise, weighted tibialis bar raise, prone Y-T-W-L raises, subscapularis belly press). The 4 unmatched exercises keep the unavailable-video state rather than a substituted similar movement; their rejection notes are in video-sources.json. EX-007 starts at 180 seconds and EX-036 at 208 seconds to reach the matching tutorial section.

A local application-origin player check reached YouTube with `strict-origin-when-cross-origin`; YouTube then required sign-in to confirm the viewer was not a bot. Actual playback could not be confirmed in that environment. The direct YouTube link remains visible. Metadata and publisher embedding permission checks are not a guarantee of playback for every user or region.
