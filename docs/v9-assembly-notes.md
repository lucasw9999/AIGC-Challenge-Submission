# v9 Assembly Notes

Date: 2026-05-11
Output: `deliverable/one-song-three-homes-v9.mp4` (2:27, 1920×1080 H.264 + AAC)

## Change from v8

- **Shot 16 trimmed another second to 6 seconds total** — 2:16 of v8 still showed a hint of wrong bow direction. Cut it.
- Fade-out shifted to run 5s→6s.
- **Total film: 147s (2:27).** Still well inside the 2:00–3:00 rule.
- Closing card now plays 2:15–2:27.

## If 2:15 also shows wrong bow

Source is `edit/intermediates/shot-16-slowed.mp4` — the first 4s of the v4 take slowed to 8s at 2x speed. Each successive 1s trim removes the last 0.5s of the original's first 4s. If v9's final frame still shows wrong direction, the fix is to rebuild from a shorter source slice (e.g., first 2.5s of original slowed to 6s at 2.4x speed), guaranteeing we never reach the bad motion.
