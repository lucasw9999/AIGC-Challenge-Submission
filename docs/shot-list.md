# Shot List — One Song, Three Homes

All 16 shots were generated with **Google Veo 3.1** at 1080p / 16:9 / 8 seconds, using the prompt and negative-prompt files under `prompts/`. The full film runs 2:27.

## Running order

| # | Time | Shot | Style |
|---|---|---|---|
| 01 | 0:00–0:10 | Title: "One Song, Three Homes" | black + serif |
| 01 | 0:10–0:18 | Bay Area home — closing violin case | photorealistic |
| 02 | 0:18–0:26 | Plane window over the Rockies at dawn | photorealistic |
| 03 | 0:26–0:34 | Sunrise at FlatIrons exterior | photorealistic |
| 04 | 0:34–0:42 | First note inside the community room | photorealistic |
| 05 | 0:42–0:50 | Preschool: Lucas alone at a small table | photorealistic + memory grade |
| 06 | 0:50–0:58 | Preschool: teacher brings Emma over | photorealistic + memory grade |
| 07 | 0:58–1:06 | Preschool: sharing crayons with Emma | photorealistic + memory grade |
| 08 | 1:06–1:14 | Chinese market: lost and crying | photorealistic + memory grade |
| 09 | 1:14–1:22 | Chinese market: kind adult kneels (Mandarin) | photorealistic + memory grade |
| 10 | 1:22–1:30 | Chinese market: parents come running | photorealistic + memory grade |
| — | 1:30–1:34 | Interstitial: "Kindness learns to travel." | black + serif |
| 11 | 1:34–1:42 | Colorado: a bad ski fall | photorealistic + memory grade |
| 12 | 1:42–1:50 | Colorado: stranger skier helps up (dialogue) | photorealistic + memory grade |
| 13 | 1:50–1:58 | Colorado: stranger coaches the snowplow (dialogue) | photorealistic + memory grade |
| 14 | 1:58–2:06 | Return: wide of Lucas playing | photorealistic |
| 15 | 2:06–2:14 | Return: elder's warm smile | photorealistic |
| 16 | 2:14–2:20 | Final phrase, bow lifts (slow-motion) | photorealistic |
| — | 2:20–2:27 | Closing authenticity card | black + serif |

Timings above are approximate.

## How each shot was generated

Each shot was produced by sending its `prompts/shot-NN.txt` and `prompts/shot-NN.neg.txt` to the Veo 3.1 cloud API's `predictLongRunning` endpoint, polling until the long-running operation completed, and saving the returned MP4 into `generated/shot-NN/take01.mp4`.

**API parameters used for every shot:**
- `model` = Google Veo 3.1
- `resolution` = `1080p`
- `aspectRatio` = `16:9`
- `durationSeconds` = `8`
- `sampleCount` = `1`
- `personGeneration` = `allow_all`
- negative prompt included on every submit

Veo 3.1 returns MP4 with AAC stereo audio baked in, which captures both ambient sound and any lip-synced dialogue embedded in the prompt.

## Prompt style — sustained 8-second moments

Every prompt describes one continuous sustained moment held across the full 8 seconds. No `from t=Xs to t=Ys` language, no "first... then... finally" sequential beats — only ambient simultaneous motion (camera pushes, drifting dust, curling steam, slow breath). Sequential beats on Veo 3.1 would turn the 8-second clip into a mini-montage of separate scenes.

## Prompt structure

Each prompt is a single flowing paragraph covering:

1. Shot framing (shot type, angle, lens)
2. Subject (ethnicity, age, distinguishing features, expression, posture)
3. Wardrobe (every visible garment, fabric, color)
4. Action (one sustained moment across all 8 seconds)
5. Scene (location, props, foreground / mid-ground / background)
6. Time of day and lighting (hour, Kelvin, direction, quality)
7. Camera movement (static, slow push, dolly, magnitude as %)
8. Color palette and mood (4–6 dominant colors + 2–4 mood adjectives)
9. Style descriptor (photorealistic cinematic realism, + "memory grade" for vignettes)

## Full prompts

The complete text of every prompt and every negative prompt lives in the `prompts/` folder. Each `shot-NN.txt` file is ready to pipe directly to the Veo 3.1 API.
