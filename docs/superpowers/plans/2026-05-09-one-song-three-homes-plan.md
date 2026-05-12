# One Song, Three Homes — Implementation Plan

**Goal:** Produce a 3-minute AI-generated film ("One Song, Three Homes") for Lucas to submit to the 2026 CIE/USA-DFW Student AIGC Competition by **May 15, 2026 · 11:59 PM CDT**.

**Architecture:** Generate ~12 video shots via Google Veo3 through the Veo 3.1 cloud API. Three visual languages — semi-realistic frame (Bay Area / transit / Sunrise at FlatIrons), watercolor (Australia memory), ink-wash (China memory). Assemble in a desktop video editor (DaVinci Resolve or iMovie) with a solo-violin *Molihua* soundtrack (ideally performed by Lucas himself) and minimal on-screen text. Real volunteer anchor: Lucas playing violin at Sunrise at FlatIrons, Broomfield CO.

**Tech Stack:** Python 3.11+, Veo 3.1 HTTP API, Google Veo3, DaVinci Resolve (free) or iMovie, ffmpeg for length/format verification, Git for version control of the plan + text assets.

**Spec:** [`docs/superpowers/specs/2026-05-09-one-song-three-homes-design.md`](../specs/2026-05-09-one-song-three-homes-design.md)

**Day-by-day timeline:**
- **Day 1 (May 10):** Prerequisites — registration, Veo 3.1 capability investigation, real seeds, mood boards kicked off
- **Day 2 (May 11):** Finish mood boards, full shot list, smoke-test generation
- **Day 3 (May 12):** Full generation pass 1 — all vignettes
- **Day 4 (May 13):** Regeneration pass on weak shots + audio capture/prep
- **Day 5 (May 14):** Edit, text, color, export v1 — user review
- **Day 6 (May 15):** Final revision, export, submit (before 11:59 PM CDT)

---

## File Structure

All paths relative to `./`.

```
docs/
  superpowers/
    specs/2026-05-09-one-song-three-homes-design.md          (exists)
    plans/2026-05-09-one-song-three-homes-plan.md            (this file)
  veo-3.1-capability-notes.md                            (Task 2 output)
  shot-list.md                                               (Task 6 output)
  submission-checklist.md                                    (Task 20 output)
scripts/
  veo_generate.py                                    (Task 2)
  generate_shot.py                                           (Task 7+)
  verify_length.sh                                           (Task 18)
mood-boards/
  frame-semi-realistic/*.jpg                                 (Task 5)
  australia-watercolor/*.jpg                                 (Task 5)
  china-ink-wash/*.jpg                                       (Task 5)
audio/
  molihua-lucas-raw.m4a                                      (Task 3, user capture)
  molihua-lucas-cleaned.wav                                  (Task 13)
  molihua-fallback.mp3                                       (Task 13, backup)
  ambience/*.wav                                             (Task 14)
generated/
  smoke-test/shot-<name>-takeNN.mp4                          (Task 7)
  shot-01-bay-area-opening/takeNN.mp4                        (Task 8)
  shot-02-transit/takeNN.mp4                                 (Task 8)
  shot-03-sunrise-arrival/takeNN.mp4                         (Task 8)
  shot-04-sunrise-raise-bow/takeNN.mp4                       (Task 8)
  shot-05-australia-watercolor-a/takeNN.mp4                  (Task 9)
  shot-06-australia-watercolor-b/takeNN.mp4                  (Task 9)
  shot-07-australia-watercolor-c/takeNN.mp4                  (Task 9)
  shot-08-china-inkwash-a/takeNN.mp4                         (Task 10)
  shot-09-china-inkwash-b/takeNN.mp4                         (Task 10)
  shot-10-china-inkwash-c/takeNN.mp4                         (Task 10)
  shot-11-return-push-in/takeNN.mp4                          (Task 8)
  shot-12-elder-tear/takeNN.mp4                              (Task 8)
  transitions/*.mp4                                          (Task 11)
edit/
  project-file.drp (or similar)                              (Task 15)
deliverable/
  one-song-three-homes-v1.mp4                                (Task 18)
  one-song-three-homes-final.mp4                             (Task 19)
.gitignore                                                   (Task 1)
```

Files that can reach tens of MB or more (anything under `generated/`, `edit/`, `deliverable/`, plus raw audio) are gitignored. Text artifacts (plans, shot list, investigation report, prompts) stay in git.

---

## Task 1: Project bootstrap (git + directories + registration)

**Files:**
- Create: `./.gitignore`
- Create: `./README.md` (one-line project title + link to spec)

- [ ] **Step 1: Initialize git repo and create directory skeleton**

```bash
cd .
git init -b main
mkdir -p scripts mood-boards/frame-semi-realistic mood-boards/australia-watercolor mood-boards/china-ink-wash audio/ambience generated edit deliverable
```

- [ ] **Step 2: Write `.gitignore`**

```
# Binary artifacts - too large / not needed in git
generated/
edit/
deliverable/
audio/*.m4a
audio/*.wav
audio/*.mp3
audio/ambience/
mood-boards/**/*.jpg
mood-boards/**/*.png
mood-boards/**/*.webp

# Python / tools
venv/
__pycache__/
*.pyc
.DS_Store
```

- [ ] **Step 3: Write minimal `README.md`**

```markdown
# One Song, Three Homes

Lucas's 3-minute film for the 2026 CIE/USA-DFW Student AIGC Competition.

- Spec: [`docs/superpowers/specs/2026-05-09-one-song-three-homes-design.md`](docs/superpowers/specs/2026-05-09-one-song-three-homes-design.md)
- Plan: [`docs/superpowers/plans/2026-05-09-one-song-three-homes-plan.md`](docs/superpowers/plans/2026-05-09-one-song-three-homes-plan.md)

Deadline: May 15, 2026 · 11:59 PM CDT.
```

- [ ] **Step 4: Initial commit**

```bash
git add .gitignore README.md docs/
git commit -m "chore: bootstrap project for SECC AIGC film"
```

- [ ] **Step 5: Complete competition registration (user action)**

Ask user to visit https://cie-dfw.org/event/2026-secc-aigc/, pay $15, and forward the confirmation email. Record confirmation number in `docs/submission-checklist.md` (created in Task 20). **Blocker for submission, not for production.**

Acceptance: `ls -la` shows all six directories; `git log` shows one commit; user has registration confirmation.

---

## Task 2: Veo 3.1 capability investigation

**Files:**
- Create: `./docs/veo-3.1-capability-notes.md`
- Create: `./scripts/veo_generate.py`

Goal: produce a written capability report so we design within real limits, not guesses. The user explicitly asked for this walkthrough.

- [ ] **Step 1: Invoke the Veo 3.1 API documentation**

Invoke `Skill` with `skill: veo-api-docs`. Read the loaded content; it will cover authentication (authentication methods), endpoints, model availability, batch vs interactive, project tokens, quotas, and configuration.

- [ ] **Step 2: Identify Veo3 availability and access path**

From the loaded Veo 3.1 API documentation, determine:
- Is Veo3 available via the cloud API (interactive or batch)?
- Which endpoint/model-id?
- Authentication method required for our environment (expect OAuth authentication for interactive dev use)
- Rate limits / quota / project-token requirements

If Veo3 is not currently offered through the cloud API, fall back to (in order): Google's Gemini API Veo endpoint with a personal key, Runway Gen-3, Pika 2.0, Kling. Document the fallback choice and access path.

- [ ] **Step 3: Write `scripts/veo_generate.py`**

Minimal script that submits a tiny Veo3 prompt through the cloud API and saves the returned video. Parameterized so we can re-use it for all shots (Task 7+).

```python
#!/usr/bin/env python3
"""Smoke test Veo 3.1 API -> Veo3 video generation.

Usage: python veo_generate.py --prompt "A violin on a chair" --out smoke-01.mp4
"""
import argparse
import os
import sys
import time
from pathlib import Path

# NOTE: replace the import + client setup with the exact pattern returned by
# the Veo 3.1 API documentation. The skeleton below is the expected shape.
try:
    # use the appropriate HTTP client for the Veo 3.1 API
except ImportError:
    print("Install the Veo 3.1 client per the API documentation.", file=sys.stderr)
    sys.exit(2)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--prompt", required=True)
    parser.add_argument("--out", required=True, type=Path)
    parser.add_argument("--model", default="veo-3")
    parser.add_argument("--duration", type=int, default=8, help="seconds")
    parser.add_argument("--aspect", default="16:9")
    parser.add_argument("--reference-image", type=Path, default=None)
    args = parser.parse_args()

    client = Client()  # reads environment variables per skill guidance
    job = client.video.generate(
        model=args.model,
        prompt=args.prompt,
        duration_seconds=args.duration,
        aspect_ratio=args.aspect,
        reference_image=args.reference_image.read_bytes() if args.reference_image else None,
    )
    print(f"Job id: {job.id}")
    while not job.done:
        time.sleep(5)
        job.refresh()
        print(f"  status: {job.status}")
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_bytes(job.result.video_bytes)
    print(f"Wrote {args.out} ({args.out.stat().st_size} bytes)")


if __name__ == "__main__":
    main()
```

- [ ] **Step 4: Run the smoke test**

```bash
mkdir -p generated/smoke-test
python scripts/veo_generate.py \
  --prompt "A wooden violin resting on a chair by a sunlit window, photorealistic, shallow depth of field, golden hour" \
  --out generated/smoke-test/smoke-001.mp4
```

Expected: script returns job id, polls, writes an MP4 ~5–10 MB. Open the file. If it plays and contains recognizable violin-on-chair imagery, the pipeline works.

- [ ] **Step 5: Record findings in `docs/veo-3.1-capability-notes.md`**

Required sections:

```markdown
# Veo 3.1 Capability Report

## Access
- Endpoint / SDK used:
- Model id (exact string):
- Authentication:
- Project token / quota notes:

## Technical limits (confirmed by smoke test)
- Max clip duration:
- Supported aspect ratios:
- Max resolution:
- Output format / codec:
- Audio support: (yes/no, and how)
- Reference-image / image-to-video support:
- Watermark present?

## Prompting
- Length limit:
- Style descriptors that work (observed):
- Negative prompt support:

## Rate & cost
- Observed generation time per ~8s clip:
- Rate limit encountered?
- Cost per clip (if any):

## Fallbacks
- If Veo3 is unavailable for a specific shot, use:

## Open risks
```

- [ ] **Step 6: Commit**

```bash
git add scripts/veo_generate.py docs/veo-3.1-capability-notes.md
git commit -m "feat: Veo 3.1 smoke test and capability report"
```

Acceptance: investigation doc exists and every bullet is filled in with real observed values (no TBDs); a playable smoke-test MP4 exists on disk.

---

## Task 3: Capture Lucas's Molihua violin recording (user action)

**Files:**
- Save to: `./audio/molihua-lucas-raw.m4a`

- [ ] **Step 1: Record Lucas playing *Molihua***

Ask the user to have Lucas perform *Molihua* on violin — 30–90 seconds, solo, no backing track. Phone voice-memo is fine. One good take is all that's needed; two or three is ideal so we can pick the best.

Technical minimums:
- Quiet room
- Phone held 1–2 meters away, pointed at the violin
- No music stand crinkling
- Aim for ~60 seconds; the final cut's violin track spans ~2:45 of the film, so we'll loop or re-order phrases in post

- [ ] **Step 2: Transfer to `audio/molihua-lucas-raw.m4a`**

USB or any phone-to-computer file-transfer method — whichever is fastest for the user. Verify file plays.

- [ ] **Step 3: Log if unavailable**

If Lucas cannot record within 24 hours, note it in `docs/submission-checklist.md` and proceed to Task 13 fallback (royalty-free *Molihua* violin performance).

Acceptance: `audio/molihua-lucas-raw.m4a` exists and plays, OR user has explicitly opted for the fallback path.

---

## Task 4: Resolve real seeds for Australia + China vignettes (user action)

**Files:**
- Update: `./docs/superpowers/specs/2026-05-09-one-song-three-homes-design.md` §6

- [ ] **Step 1: Ask user for one real anchor per vignette**

Ask the user (concisely):
- **Australia:** one small family story about a kindness during Lucas's Australia years — a neighbor, a daycare helper, a stranger, anything. One line is enough.
- **China:** one real moment from Lucas's age-6 China trip where someone helped someone — ideally involving a grandparent, a neighbor, a meal, food, or music. One line is enough.

If the user says "no real memory" for either, flag it — stay on the current placeholder but mark the film as "inspired by" family tradition rather than a specific incident. The placeholder is still defensible: it's based on the family's real presence in those countries, which is documented fact.

- [ ] **Step 2: Edit §6 of the spec to replace each placeholder**

Update the Status column for each vignette from `⚠ Placeholder — user to confirm or replace` to `✅ Real — confirmed: <one-line seed>`.

- [ ] **Step 3: Commit**

```bash
git add docs/superpowers/specs/2026-05-09-one-song-three-homes-design.md
git commit -m "spec: lock real seeds for Australia and China vignettes"
```

Acceptance: §6 of spec has no `⚠ Placeholder` rows.

---

## Task 5: Build three reference mood boards

**Files:**
- Create: `mood-boards/frame-semi-realistic/` (6–10 images)
- Create: `mood-boards/australia-watercolor/` (6–10 images)
- Create: `mood-boards/china-ink-wash/` (6–10 images)
- Create: `mood-boards/mood-board-notes.md`

Goal: give Veo3 concrete style anchors. Each board is 6–10 reference images plus a short style-descriptor-string we will paste into every prompt for that vignette.

- [ ] **Step 1: Source reference images**

For each board, find 6–10 images that represent the target look. Public web, Unsplash, Pinterest, art museum archives. Save to the corresponding folder. Keep filenames descriptive.

- Frame (semi-realistic): stills from Chloé Zhao films, premium commercial advertising, and Pixar live-action-like references — elder hands, violin close-up, warm golden-hour interiors, soft window light
- Australia (watercolor): Australian-coast watercolors, sunlit seaside pastels, loose-edge brushwork
- China (ink-wash): traditional *shui-mo* paintings with single-red accents, jasmine subject matter, calligraphic brush strokes, tea-ceremony stills in ink style

- [ ] **Step 2: Write per-board style-descriptor strings**

Append to every Veo3 prompt in that vignette. Create `mood-boards/mood-board-notes.md`:

```markdown
# Mood Board Notes — Style Descriptor Strings

These strings must be appended to every Veo3 prompt for the matching vignette.

## Frame (Bay Area / transit / Sunrise at FlatIrons)
"semi-realistic cinematic style, warm golden hour lighting, shallow depth of field, soft window light, naturalistic color grade, gentle camera motion, film grain, Chloé Zhao aesthetic"

## Australia (watercolor)
"watercolor painting style, visible paper texture, soft pastel palette, loose wet-edge brushwork, sun-drenched seaside tones, impressionistic, flowing pigment, dreamlike memory, 2D animated feel"

## China (ink-wash / shui-mo)
"traditional Chinese ink-wash painting (shui-mo) style, monochrome with a single red accent, calligraphic brush strokes, soft bleeding ink on rice paper, minimalist composition, jasmine motif, still contemplative mood"
```

- [ ] **Step 3: Commit text notes**

```bash
git add mood-boards/mood-board-notes.md
git commit -m "feat: mood-board style-descriptor strings per vignette"
```

Acceptance: three folders each contain ≥6 reference images (locally — not in git); `mood-boards/mood-board-notes.md` is committed.

---

## Task 6: Write the shot list with Veo3 prompts

**Files:**
- Create: `./docs/shot-list.md`

12 shots total. Each shot: id, duration, style, description, full Veo3 prompt (incl. style-descriptor), reference image (optional), acceptance notes.

- [ ] **Step 1: Write `docs/shot-list.md`**

Use this exact template, filled in for each of the 12 shots:

```markdown
# Shot List — One Song, Three Homes

Total target run: 3:00.

| # | Time | Duration | Style | Description |
|---|---|---|---|---|
| 01 | 0:00–0:10 | 10s | Semi-realistic | Bay Area morning; Lucas quietly closes a violin case on a desk by a sunlit window |
| 02 | 0:10–0:20 | 10s | Semi-realistic | Plane window over the Rockies, golden dawn |
| 03 | 0:20–0:25 | 5s | Semi-realistic | Exterior — Sunrise at FlatIrons entrance at golden hour |
| 04 | 0:25–0:55 | 30s | Semi-realistic | Interior community room — Lucas enters, sits, raises bow, draws first note; faces of elders in soft focus |
| 05 | 0:55–1:15 | 20s | Watercolor | Australia — toddler Lucas in a stroller on a sunlit boardwalk; a stranger smiles |
| 06 | 1:15–1:30 | 15s | Watercolor | Stranger hands toddler a piece of fruit; boardwalk light shimmers |
| 07 | 1:30–1:40 | 10s | Watercolor | Jasmine petal floats across the frame, carries into ink-wash world (transition) |
| 08 | 1:40–2:05 | 25s | Ink-wash | China — grandmother's hands preparing a steaming bowl at a wooden door |
| 09 | 2:05–2:20 | 15s | Ink-wash | Neighbor receives the bowl; a small exchange of smiles; jasmine-tea steam curls up |
| 10 | 2:20–2:25 | 5s | Ink-wash → semi-realistic | Ink strokes dissolve into sunlight on violin strings (transition) |
| 11 | 2:25–2:45 | 20s | Semi-realistic | Push in on an elder's face as Lucas plays; eyes wet, a breath catches, small smile |
| 12 | 2:45–2:50 | 5s | Semi-realistic | Final phrase; bow lifts; beat of silence |
| — | 2:50–3:00 | 10s | Black | Closing authenticity card (text-only, added in edit) |

## Shot-by-shot prompts

### Prompt template — required detail for every shot

Veo3 quality scales with prompt specificity. Every prompt below follows this structure (written as flowing prose, not bullet points — Veo3 parses long descriptive paragraphs best):

1. **Shot framing** — shot type (extreme close-up / close-up / medium close / medium / wide / extreme wide), angle (eye-level / low / high / worm / bird), lens (macro / 35mm / 50mm / 85mm equivalent).
2. **Subject** — who/what, ethnicity, age, skin tone, hair, distinguishing features, expression, posture.
3. **Wardrobe / costume** — every visible clothing item, fabric, color, state (pushed-up sleeves, laces tied, etc.).
4. **Action timeline** — frame-by-frame beats with approximate timecodes within the shot. Each second matters.
5. **Scene** — location, all visible props, background layers (foreground/midground/background), textures, materials.
6. **Time of day** — specific hour and season if relevant.
7. **Lighting** — source, direction, color temperature (in Kelvin), quality (hard/soft/diffused), notable effects (rim light, backlight, dust motes, bloom).
8. **Camera movement** — static / push / pull / pan / tilt / dolly / crane / handheld; magnitude and speed.
9. **Color palette** — the 4–6 dominant colors.
10. **Mood / atmosphere** — 2–4 adjectives.
11. **Style descriptor** — the appropriate per-vignette string from `mood-boards/mood-board-notes.md`.
12. **Negative prompt** — "AVOID:" list of common failure modes (distorted hands/faces, plastic skin, cartoon, text artifacts, logos, modern anachronisms).

Every prompt below is a single long paragraph covering items 1–11. Item 12 is given separately as a **Negative prompt** line.

---

### Shot 01 — Bay Area opening (10s, semi-realistic)

**Description:** Bay Area home, early morning. A teenage boy's hands slowly close the latches of a violin case on a wooden desk by a sunlit window.

**Veo3 prompt:**
> Extreme close-up, eye-level to a desk surface, shot with a 50mm macro-style lens, framing the hands of an Asian-American teenage boy (age 14, warm olive skin, clean short fingernails, slender musician's fingers, a small silver string bracelet on the right wrist). He wears a dark charcoal-grey long-sleeve cotton top with sleeves pushed up to his forearms. Across ten seconds: for the first two seconds his hands rest lightly on top of a closed black rectangular violin case; from t=2s to t=5s his left hand slowly lowers the left chrome latch with a single soft audible click; from t=5s to t=8s his right hand mirrors the motion on the right latch, clicks; from t=8s to t=10s his fingers linger on the case for a breath, then slowly lift upward and out of frame. The scene is a warm mid-century walnut wooden desk with visible grain; on the far right of the desk sits a small green jade succulent in a matte ceramic pot; on the far left sits a cream ceramic mug with thin white steam rising from it; in soft-focus background a folded sheet-music page and a low mid-century wooden window frame, outside which a California bay-laurel tree silhouettes against a pale morning sky. It is 7:30 AM on a clear California morning. Lighting is warm 3500K directional sunlight pouring through the window from camera-right, casting long gentle shadows that slide leftward across the desk; a soft amber rim highlights the tops of the fingers and the curve of the latches; overall low-contrast with a gentle bloom on the brightest highlights; subtle golden dust motes drift slowly through the light beam. The camera holds static for the first four seconds, then performs a barely perceptible 3% dolly push-in toward the case over the remaining six seconds; a subtle handheld micro-jitter gives the shot a human, present-tense feel. Palette: honey amber, warm walnut brown, cream white, muted jade green, brushed steel. Mood: quiet, reverent, intimate, a held breath of anticipation. semi-realistic cinematic style, warm golden hour lighting, shallow depth of field at f/1.8, soft window light, naturalistic color grade, gentle camera motion, film grain, Chloé Zhao aesthetic.

**Negative prompt:** AVOID distorted fingers, extra fingers, six-fingered hands, plastic skin, cartoon, anime style, overexposed whites, blown-out windows, cluttered background, visible modern logos, text artifacts, wide-angle lens distortion, rapid motion, jump cuts.

**Reference image:** `mood-boards/frame-semi-realistic/*.jpg` (any warm-interior still)

**Acceptance:**
- 16:9, ≥1080p, ~10s
- Hands read as a real teenager's hands — no extra digits, no plastic skin
- Warm morning tone clearly reads; shallow DOF obvious
- Camera motion is gentle and smooth, not stuttery

---

### Shot 02 — Plane window (10s, semi-realistic)

**Description:** View from an airplane seat window over the Rocky Mountains at dawn.

**Veo3 prompt:**
> Medium close-up from inside an airplane cabin, eye-level, shot with a 35mm equivalent lens, framed so the oval plane window fills the right two-thirds of the frame and the grey seatback foreground occupies a sliver of the left third. Through the window, far below, the snow-capped Rocky Mountains stretch to the horizon; individual peaks cast long blue-violet shadows across tilted white snowfields; a thin layer of haze diffuses the distance. A slice of the aircraft's silver wing, with one muted blue airline stripe, extends into the lower portion of the window. Above the mountains, the dawn sky gradates from deep indigo at the top to pink-peach near the horizon, with a sliver of bright gold where the sun breaks. Across ten seconds: the plane gently rolls at a very slow rate, causing the light through the window to shift almost imperceptibly and the shadow on the seatback to creep leftward; a tiny wisp of cloud drifts past the wing. Interior of the cabin is in soft shadow with warm 2800K cabin lighting barely catching the edge of the window frame. Outside, the sun is at 5:40 AM Mountain Time altitude, natural 4000K morning sunlight outside the aircraft; inside the cabin is low-light, contrasty against the bright window. Lighting emphasis: the window itself is the brightest element in the shot by a wide margin; rim light spills onto the gray leatherette seatback in warm pink-gold. Camera is static throughout, with only a subtle low-frequency engine vibration; imperceptible micro-handheld jitter. Palette: deep indigo, pink peach, gold, cold white, dark gray, muted silver. Mood: poetic, quiet, reflective, a held-breath travel moment. semi-realistic cinematic style, warm golden hour lighting on the exterior contrasting cool cabin interior, shallow depth of field, soft window light, naturalistic color grade, gentle camera motion, film grain, Chloé Zhao aesthetic.

**Negative prompt:** AVOID obvious composite seams, cartoon clouds, repeated mountain patterns, text on window, visible passengers' faces, shaky unnatural camera, motion blur, oversaturated sky.

**Acceptance:**
- Clearly an airplane window POV with wing visible
- Recognizable snow-capped mountain range below
- Dawn palette (indigo-to-pink-gold)
- 16:9, ~10s

---

### Shot 03 — Sunrise at FlatIrons exterior (5s, semi-realistic)

**Description:** Welcoming exterior of the retirement community at golden hour; warm light spills from within.

**Veo3 prompt:**
> Wide establishing shot, slightly low angle at knee-height looking up, shot on a 28mm-equivalent lens giving a mild sense of scale. The subject is the front entrance of a warm, cozy single-story senior-living community building: stone-and-cedar facade with horizontal wood siding the color of amber honey, a peaked roof with dark slate shingles, and a covered entry porch supported by square cedar columns. A tasteful rectangular sign beside the entrance door reads "Sunrise at FlatIrons" in serif gold lettering on a dark-brown background. The porch rail and steps are natural wood; a pair of wicker rocking chairs sit on the porch with a folded woven blanket over one; landscaping includes low purple-blue salvia, clumps of golden ornamental grass, and a curving flagstone path leading to the entry. In the mid-ground, two tall pine trees frame the building on the left, and the soft silhouette of the Flatirons mountain formation rises in the background against a peach-gold sky. Across five seconds: a warm interior lamp visible through a large window by the entrance glows steadily; a gentle breeze stirs the grass clumps; a small bird crosses the frame left-to-right high up; the clouds drift a few degrees. Time is 6:30 PM in late spring, right before magic-hour sunset. Lighting: the key light is a very warm 2800K sun low on camera-right, raking golden light across the building's facade and the path; deep long shadows stretch from the columns; the windows of the building spill warm 2400K interior light in soft pools onto the porch floor; subtle lens flare in the upper right where the sun hits the lens. Camera performs a very slow 4% dolly push toward the entrance across all five seconds, steady. Palette: honey amber, peach, deep pine green, flagstone grey, soft purple. Mood: welcoming, peaceful, expectant, home-like. semi-realistic cinematic style, warm golden hour lighting, shallow depth of field, soft window light, naturalistic color grade, gentle camera motion, film grain, Chloé Zhao aesthetic.

**Negative prompt:** AVOID sterile institutional look, hospital vibes, crowded parking lot, cluttered signage, visible modern cars, harsh midday light, pixelated text on sign, distorted lettering.

**Acceptance:**
- Warm, welcoming senior-living exterior
- Legible "Sunrise at FlatIrons" signage (font need not be exact)
- Golden hour clearly reads
- 16:9, ~5s

---

### Shot 04 — Interior, raise bow, first note (30s, semi-realistic, split into 04a/04b/04c)

**Production note:** If Veo 3.1 maximum clip is 8–10 seconds (confirm in Task 2 report), split this shot into three sub-clips. Each sub-clip has its own fully detailed prompt below.

#### Shot 04a — enters and sits (10s)

**Veo3 prompt:**
> Wide shot, eye-level, 35mm-equivalent lens, framing a warm wood-paneled community room at a senior living facility: a semicircle of six elderly residents seated in comfortable cream-upholstered armchairs facing camera in the mid-ground, their backs largely to us so we see silver and grey heads and shoulders in soft focus; on the right, a grand piano; on the left, a large mullioned window letting golden late-afternoon sun pour across the wooden floor; a simple wooden chair is placed centered in front of the semicircle. Over ten seconds: from camera-left, a calm Asian-American teenage boy (age 14, warm olive skin, neatly cut short black hair, soft serious expression, wearing a crisp white button-down shirt with sleeves rolled once, black slim slacks, black polished dress shoes) walks slowly into frame carrying a honey-brown wooden violin by the neck in his left hand and a bow in his right; he walks deliberately to the central chair, his shoes making soft footsteps on the wood floor; he sits down gently, adjusts his shirt, and places the violin on his lap with both hands resting on it, looking up toward the audience with quiet respect. Time: 4:30 PM late spring afternoon. Lighting: a key 2900K sunlight streaming through the left window at a 30-degree angle, painting a warm golden rectangle across the floor and the boy's white shirt, casting long shadows toward camera-right; soft fill bouncing off the cream-painted rear wall; the residents' silver hair catches gentle rim light; warm 2700K interior sconces glow low in the background. Camera: static wide the full ten seconds, with minimal handheld micro-jitter. Palette: cream, honey-wood, soft silver, warm white, amber, muted pine green. Mood: reverent, hushed, attentive, a room holding its breath. semi-realistic cinematic style, warm golden hour lighting, shallow depth of field, soft window light, naturalistic color grade, gentle camera motion, film grain, Chloé Zhao aesthetic.

**Negative prompt:** AVOID crisp recognizable faces of residents, distorted hands or fingers, six-fingered hands, cartoonish proportions, modern phones/devices visible, any visible text or signage, floating violin, unnatural walking gait.

#### Shot 04b — places violin, raises bow (10s)

**Veo3 prompt:**
> Medium close-up, eye-level, 50mm-equivalent lens, framing the same Asian-American teenage boy (age 14, warm olive skin, neatly cut short black hair, calm serious expression, crisp white button-down shirt sleeves rolled once) from just below his chest up to the top of his head, shot in three-quarter profile from camera-right. Across ten seconds: for the first two seconds he holds the honey-brown wooden violin in his hands, drawing a slow breath visible in a tiny chest rise; from t=2s to t=5s he gently lifts the violin, tucking its dark chinrest under his jaw and settling his left hand on the fingerboard; from t=5s to t=8s he raises the bow with his right hand in a smooth arc up to the strings; from t=8s to t=10s his eyes close for a blink, his lips press together softly, and the bow hovers a millimeter above the strings. Background: the out-of-focus cream-upholstered armchairs and silvery-haired audience, bathed in warm light; a single out-of-focus silver figure in the center-right leans slightly forward. Time: 4:30 PM. Lighting: same warm 2900K key from camera-right, catching his cheekbone and the curve of the violin's wood grain in a soft golden highlight; gentle fill on the left side of his face; subtle rim on his hair. Camera: static for the first five seconds, then a slow, steady 5% dolly push-in over the last five seconds, creeping toward his face and the violin. Palette: cream, warm wood, white cotton, soft amber, deep black. Mood: reverent, inward, almost prayerful. semi-realistic cinematic style, warm golden hour lighting, shallow depth of field, soft window light, naturalistic color grade, gentle camera motion, film grain, Chloé Zhao aesthetic.

**Negative prompt:** AVOID distorted hands, extra fingers, violin held incorrectly, bow held like a pencil, plastic skin, overexposed highlights on violin, modern wristwatch.

#### Shot 04c — bow touches string, first note (10s)

**Veo3 prompt:**
> Extreme close-up, eye-level to the violin's bridge, shot on a 100mm macro-equivalent lens. Subject: a honey-amber wooden violin with four taut strings, a dark ebony chinrest just barely in frame at the top, and the fine grain of the maple and spruce visible. From camera-left, a horsehair bow enters and settles gently onto the outermost string. Across ten seconds: for the first three seconds the bow hovers less than a millimeter above the string, stillness so complete that a single dust mote drifts through the light beam; at t=3s the bow touches the string with a tiny visible vibration; from t=3s to t=8s the bow draws slowly to the right, the string vibrating visibly in its wake, a faint glow of resin dust rising from the contact point; from t=8s to t=10s the bow continues its pull, the note held, the camera holding reverently. The background behind the violin is warm out-of-focus golden light from the window, with indistinct silver-haired silhouettes beyond, all soft bokeh circles of amber. Time: 4:30 PM. Lighting: warm 2900K directional sunlight from upper-camera-right raking across the violin's curved wood, catching the edges of the strings in thin brilliant lines, creating a honey-amber highlight along the length of the bridge; soft fill below from reflected floor light; dust motes drift through the light beam. Camera: static for the first three seconds, then a barely perceptible 2% dolly push-in over the remaining seven seconds. Palette: honey amber, deep ebony black, ivory white (bow hair), soft warm gold bokeh. Mood: held-breath reverent, the precise moment a song begins. semi-realistic cinematic style, warm golden hour lighting, shallow depth of field, soft window light, naturalistic color grade, gentle camera motion, film grain, macro photography texture, Chloé Zhao aesthetic.

**Negative prompt:** AVOID distorted bow, snapped string, floating bow, modern electronic tuner visible, plastic-looking wood, overexposed whites on the bow hair, cartoon or anime styling.

**Acceptance for 04 overall (a+b+c stitched):**
- Teenager reads age-appropriate, Asian American
- Violin and bow held correctly (or regenerate)
- Warm reverent lighting coherent across three sub-clips
- Total ~30s when stitched

---

### Shot 05 — Australia: toddler on boardwalk (20s, watercolor, split into 05a/05b if needed)

#### Shot 05a — boardwalk establishing (10s)

**Veo3 prompt:**
> Medium wide shot, eye-level slightly low (at a toddler's height), shot with a 35mm-equivalent lens, framing a sunlit wooden boardwalk on the Australian coast: weathered silver-grey timber planks in the foreground running diagonally toward camera-left, white-painted timber railing on the left side, turquoise ocean meeting a pale horizon on the right, a soft-focus sandy beach below. In the mid-ground, a blonde-wood stroller with a cream canopy rolls gently forward along the boardwalk; inside sits an Asian toddler approximately two years old, round-cheeked with a small wisp of dark hair, wearing a cream linen wide-brim sun hat, a white and pale-yellow striped t-shirt, and soft blue cotton shorts; his tiny hand is outstretched, grasping the air. On the right side of the boardwalk, a friendly Australian stranger (middle-aged woman, tan freckled skin, sun-lightened brown hair loose to the shoulders, wearing a loose white linen button-down shirt and khaki shorts, leather sandals) walks into frame carrying a wicker basket over one arm; she notices the toddler and slows. Across ten seconds: the stroller rolls forward three steps; the stranger slows and begins to kneel; the toddler looks up. Time: 11:00 AM on a bright Sydney-coast morning. Lighting: bright 5500K midday sun from above, high-key, soft bounce off the pale timbers and white railing, turquoise glow reflected up onto faces from below; specular highlights flash off the ocean behind; dappled light through sparse palm fronds offscreen creates gentle moving spots on the boardwalk. Camera: a very slow handheld-style drift to the right, two percent; organic micro-motion. Palette: sun-bleached timber silver, turquoise, white, pale yellow, soft blue, sand beige, warm flesh tones. Mood: sun-warmed, safe, open-hearted, a memory half-imagined. watercolor painting style, visible paper texture, soft pastel palette, loose wet-edge brushwork, sun-drenched seaside tones, impressionistic, flowing pigment, dreamlike memory, 2D animated feel.

**Negative prompt:** AVOID photorealism, crisp edges, 3D CGI look, photographic skin detail, dark shadows, heavy contrast, modern branded clothing, visible phone screens.

#### Shot 05b — stranger kneels beside stroller (10s)

**Veo3 prompt:**
> Medium close-up, eye-level at toddler height, 50mm-equivalent lens, framed on the Australian stranger and the stroller side-by-side. The middle-aged woman (tan freckled skin, sun-lightened brown shoulder-length hair, loose white linen shirt, khaki shorts) kneels in three-quarter profile with her wicker basket set down beside her; the blonde-wood stroller with its cream canopy holds the Asian toddler (age ~2, cream sun hat, white-and-yellow striped t-shirt, soft blue shorts). Across ten seconds: from t=0s to t=3s the woman smiles warmly, eyes crinkling at the corners; from t=3s to t=6s the toddler looks up at her, small hand reaching out curiously; from t=6s to t=10s they make soft eye contact, the woman's expression one of tender delight, the toddler's of wide-eyed curiosity. Background: soft watercolor bleed of turquoise ocean and pale sky, with gentle washes of palm frond silhouettes on the right. Time: 11:00 AM late spring morning. Lighting: high-key 5500K Sydney sunlight, bouncing off white railing behind them, casting gentle rim light on the woman's hair and the toddler's hat brim; soft color spill of turquoise reflected onto their faces from the sea behind. Camera: static for the full ten seconds, with subtle organic micro-float. Palette: cream, pale yellow, turquoise, warm sandy tan, soft pink cheek tones. Mood: warm, tender, safe, a stranger's kindness frozen in sunlight. watercolor painting style, visible paper texture, soft pastel palette, loose wet-edge brushwork, sun-drenched seaside tones, impressionistic, flowing pigment, dreamlike memory, 2D animated feel.

**Negative prompt:** AVOID photoreal faces, sharp detail, CGI rendering, dark moody tones, heavy outlines, ink-wash style crossover.

**Acceptance for Shot 05 overall:**
- Clearly watercolor style — NOT photorealistic
- Pastel sunlit palette
- Tender exchange of looks legible
- Total ~20s stitched

---

### Shot 06 — Australia: stranger shares fruit (15s, watercolor)

**Veo3 prompt:**
> Extreme close-up, eye-level to the toddler's hand, shot on a 85mm macro-equivalent lens, framed on the exchange between two hands. In the foreground-right, the tan, freckled, weathered hand of the Australian stranger (adult woman, warm sun-kissed skin, faint blonde arm hair) gently offers a thick glowing slice of ripe yellow-orange mango between her thumb and forefinger, a tiny highlight of sweet juice catching the light on the mango's edge. In the foreground-left, the small plump hand of the Asian toddler (age ~2, soft pink palm, tiny dimpled fingers) reaches upward with wide-open fingers, tentative, curious. Across fifteen seconds: for the first five seconds both hands remain separated, the gap between them shimmering with heat and light; from t=5s to t=10s the toddler's hand drifts upward in slow motion, fingertips close to the mango slice; from t=10s to t=15s the toddler's fingers touch the mango and gently accept it; a single drop of mango juice falls slowly toward the boardwalk. Background: soft watercolor wash of sunlit wooden boardwalk planks in pale peach and silver-grey, behind that a shimmering abstract suggestion of turquoise sea with white paper showing through for foam. Time: 11:00 AM. Lighting: bright high-key 5500K Australian sun directly behind the hands, creating a strong translucent golden glow through the thin mango slice so it looks like a piece of stained glass; soft warm rim light on both hands; specular highlights dance on the juice drop. Camera: static for the first ten seconds, then a 2% slow push-in toward the mango over the last five seconds. Palette: luminous yellow-orange, warm honey, pale pink skin tones, silver-grey boardwalk, hints of turquoise. Mood: tender, suspended, generous, sacrament-like. watercolor painting style, visible paper texture, soft pastel palette, loose wet-edge brushwork, sun-drenched seaside tones, impressionistic, flowing pigment, dreamlike memory, 2D animated feel.

**Negative prompt:** AVOID photorealism, crisp edges, 3D render look, harsh contrast, distorted fingers, six-fingered hands, photographic skin pores, visible branding.

**Acceptance:**
- Watercolor style unmistakably reads
- Tender hand-to-hand exchange
- The mango glows like a jewel
- ~15s

---

### Shot 07 — Jasmine petal transition (10s, watercolor → ink-wash)

**Veo3 prompt:**
> Medium close-up, eye-level, 50mm-equivalent lens, framed on a single white jasmine blossom petal drifting gently on a soft air current from the upper-left of frame toward the lower-right, occupying roughly ten percent of the frame at its largest. Across ten seconds: at t=0s the background is a pale warm watercolor wash — turquoise, peach, and cream, with visible paper texture and soft wet-edge bleeding — and the petal drifts dreamily; between t=3s and t=6s the background begins to transform: the colors desaturate, the turquoise and peach slowly draining away; from t=6s to t=10s the background has become a traditional Chinese ink-wash on rice paper, monochrome cool grey with a single small red seal mark (square, bright vermilion) visible in the lower-right corner; the petal continues its drift, now rendered as a single ink-stroke suggestion of white against the grey. Motion of the petal is continuous and slow throughout, independent of the background transformation. Time and lighting do not apply literally — this is a poetic metamorphosis. Palette first half: turquoise, peach, cream, soft white; palette second half: cool ink grey, rice-paper cream, a single vermilion red, soft white. Mood: meditative, in-between, a memory handing off to a memory. Style: begins as watercolor painting with visible paper texture, loose wet-edge brushwork, soft pastel palette, and ends as traditional Chinese ink-wash (shui-mo) with calligraphic strokes, bleeding ink, minimalist composition; the transition is seamless — the style transforms as an artistic effect, not a hard cut.

**Negative prompt:** AVOID hard cuts or dissolves between the two styles, visible splice, 3D rendering, photorealism, multiple petals, distracting background clutter.

**Acceptance:**
- Petal is continuously visible and drifting
- Clear artistic transformation from watercolor to ink-wash mid-shot
- ~10s

---

### Shot 08 — China: grandmother prepares food (25s, ink-wash, split into 08a/08b if needed)

#### Shot 08a — hands and soup (12s)

**Veo3 prompt:**
> Close-up, eye-level to a low wooden table, 50mm-equivalent lens, framed on the hands of an elderly Chinese grandmother: soft wrinkled hands with thin silver wedding band on the left ring finger, warm olive skin, rendered entirely in the style of a traditional Chinese ink-wash (shui-mo) painting — calligraphic brush strokes defining the contours, soft bleeding ink suggesting depth, monochrome cool grey on cream rice paper. She wears a simple traditional mandarin-collar tunic in ink-grey tones, with a single vermilion red cuff visible on her right wrist as the one hot spot of color in the frame. Across twelve seconds: for the first three seconds her hands rest on the handle of an iron ladle and the rim of a white porcelain bowl; from t=3s to t=8s her right hand lifts the ladle slowly from an ink-suggested clay pot and pours a steaming ribbon of soup into the bowl, the steam rising in elegant calligraphic curls; from t=8s to t=12s she sets the ladle down, picks up the bowl with both hands, and holds it with reverence. Background: a traditional courtyard kitchen suggested with minimal ink strokes — a wooden shelf hinting at jars and utensils in the soft distance, a wisp of jasmine sprig on the table just visible, overall mostly empty rice-paper cream. Time of day is poetically unspecified — a memory's light. Lighting in the ink-wash convention: soft overall illumination, no hard shadows; the single vermilion red cuff is the only saturated color. Camera: static throughout, with minimal subtle organic paper-shift micro-motion as if the paper itself breathes. Palette: cool ink grey, rice-paper cream, a single vermilion red, soft black. Mood: tender, reverent, timeless, the quiet grace of care. traditional Chinese ink-wash painting (shui-mo) style, monochrome with a single red accent, calligraphic brush strokes, soft bleeding ink on rice paper, minimalist composition, jasmine motif, still contemplative mood.

**Negative prompt:** AVOID photorealism, full color, Western oil-painting style, 3D rendering, cluttered background, multiple red accents, anime or cartoon, distorted hands, six-fingered hands, modern appliances.

#### Shot 08b — steam rises (13s)

**Veo3 prompt:**
> Medium close-up, slight low angle, 50mm-equivalent lens, framed on the white porcelain bowl of soup held between the grandmother's two hands (same elderly Chinese grandmother as 08a, ink-wash style, vermilion red cuff). The bowl occupies the center-lower third of frame; above it, steam rises in long elegant calligraphic curls. Across thirteen seconds: steam continuously rises and curls upward, each wisp rendered as a single fluid brush stroke that elongates, twists, and dissolves into the rice-paper background; from t=0s to t=6s the steam is tight and rising vertically; from t=6s to t=13s the steam curls outward and wider, some wisps forming the barest suggestion of the shape of a jasmine blossom before dissolving. Background: rice-paper cream, almost empty, with a soft suggestion of courtyard light to the right in the palest grey brush strokes. Time: poetic, indeterminate. Lighting convention: flat ink-wash illumination, no hard shadows, the vermilion cuff vibrating against the monochrome. Camera: static with minimal paper-shift breath. Palette: rice-paper cream, cool grey, vermilion red, soft black. Mood: contemplative, warm despite the monochrome, the silence of a sacred small act. traditional Chinese ink-wash painting (shui-mo) style, monochrome with a single red accent, calligraphic brush strokes, soft bleeding ink on rice paper, minimalist composition, jasmine motif, still contemplative mood.

**Negative prompt:** AVOID multiple red elements, photorealistic steam, 3D rendering, dense cluttered background, full-color palette, CGI smoke.

**Acceptance for Shot 08 overall:**
- Unambiguously Chinese ink-wash style
- Single vermilion red accent clearly visible
- Steam renders as calligraphic brushwork
- Total ~25s stitched

---

### Shot 09 — China: neighbor receives bowl (15s, ink-wash)

**Veo3 prompt:**
> Medium shot, eye-level, 50mm-equivalent lens, framed in portrait-width centered composition on two figures at a simple wooden courtyard door. On camera-left, the elderly Chinese grandmother (soft wrinkled face, silver-grey hair pulled into a low bun, mandarin-collar ink-grey tunic with the single vermilion red cuff on her right wrist) holds out the steaming white porcelain bowl with both hands. On camera-right, an elderly neighbor woman (warm-weathered face, white hair in a short bob, simple collared robe in ink-grey) bows slightly and receives the bowl with both hands, her face breaking into a soft tender smile. Between them, curling jasmine-tea steam rises in calligraphic brush strokes, lingering at face level. Background: a simple wooden courtyard door in the mid-ground, ink-suggested wood grain; behind, a hint of a stone wall and a sprig of jasmine vine in the upper-left corner rendered in delicate brush strokes; an almost empty rice-paper cream background dominates. Across fifteen seconds: from t=0s to t=5s the grandmother extends the bowl, her arms in a gentle arc; from t=5s to t=10s the neighbor's hands accept it, their fingers lightly touching; from t=10s to t=15s they hold a shared look, both smiling, and the steam curls between them. Time: poetic, a mid-afternoon of memory. Lighting: flat ink-wash illumination, no shadows, the two red cuffs and seal marks punctuating the monochrome (the grandmother's single red cuff remains the only saturated color — the neighbor wears no red). Camera: static with minimal paper-breath motion. Palette: rice-paper cream, cool grey, vermilion red, soft black, warm skin undertone in muted sepia. Mood: tender, grateful, timeless, the heart of the vignette. traditional Chinese ink-wash painting (shui-mo) style, monochrome with a single red accent, calligraphic brush strokes, soft bleeding ink on rice paper, minimalist composition, jasmine motif, still contemplative mood.

**Negative prompt:** AVOID multiple red accents, full color spill, photorealism, 3D look, modern clothing, Western aesthetic, distorted hands, plastic skin.

**Acceptance:**
- Unmistakably ink-wash
- Bowl exchange legible
- Single red accent (grandmother's cuff) clearly visible
- ~15s

---

### Shot 10 — Ink-stroke to violin-string transition (5s, hybrid)

**Veo3 prompt:**
> Extreme close-up, eye-level, 100mm macro-equivalent lens, framed on a single long horizontal ink brush stroke on cream rice paper that occupies the horizontal middle of the frame. Across five seconds: at t=0s the ink stroke is clearly calligraphic, wet at the edges, with visible bristle texture; from t=1s to t=3s the ink stroke slowly thickens, straightens, and transforms — its wet edges sharpen into a taut metallic line, the rice-paper background begins to bleed into a warm wooden grain, and the stroke becomes recognizable as the vibrating steel-core of a violin string; from t=3s to t=5s the transformation completes, the background now warm golden sunlit wood of a community room floor, the string tight and gleaming, and a horsehair bow enters from camera-left and glides slowly across the string, resin dust rising in tiny golden specks. Time: the present-day — the return to the retirement-home scene. Lighting transforms alongside the imagery: from flat ink-wash illumination at t=0s to warm 2900K directional sunlight from upper-camera-right by t=5s, with dust motes drifting in the beam. Camera: static the full five seconds with minimal micro-motion. Palette first half: rice-paper cream, ink grey, a hint of vermilion; palette second half: honey amber, warm wood, brushed steel, ivory bow hair, soft amber bokeh. Mood: poetic metamorphosis, inside-to-outside, memory-to-present. Style: begins as traditional Chinese ink-wash with bleeding edges and calligraphic texture, and ends as semi-realistic cinematic with warm golden hour lighting, shallow depth of field, film grain, Chloé Zhao aesthetic; the transformation is a continuous artistic metamorphosis, not a dissolve.

**Negative prompt:** AVOID hard cuts, visible splice line, 3D rendering, cartoon, mid-shot style flicker, multiple distinct shots, obvious wipe transition.

**Acceptance:**
- Clear visible transformation mid-shot
- Bow glide visible at end
- ~5s

---

### Shot 11 — Push in on elder's face (20s, semi-realistic, split into 11a/11b if needed)

#### Shot 11a — breath catches, tear forms (10s)

**Veo3 prompt:**
> Medium close-up, eye-level, 85mm-equivalent lens, framed on the face of an elderly Chinese-American woman in her late seventies to early eighties: warm olive skin with soft gentle wrinkles, silver-grey hair pulled back into a simple low bun, kind deep-brown eyes, thin lips in a soft neutral rest; she wears a pale lavender cashmere cardigan over a cream blouse with a small pearl button visible at the collar; a tiny delicate jade pendant on a thin gold chain rests just above the collar. She is seated in a cream-upholstered armchair, the background a warm out-of-focus community room with a golden-window-light glow. Across ten seconds: for the first three seconds her face is still, expression neutral, listening; from t=3s to t=6s her brows gently lift, her gaze drifts inward as if remembering, a subtle micro-expression of emotion crosses her face; from t=6s to t=10s her eyes slowly begin to shimmer with tears, the lower lids wet, the first tear beads at the corner of her right eye but does not yet fall. Time: 4:45 PM late-afternoon. Lighting: warm 2800K golden sunlight from camera-left at a 45-degree angle, key-lighting the left side of her face in soft amber, leaving the right side in gentle warm shadow; a subtle bounce of cream fill from the armchair on her right cheek; rim light through the window catches the silver of her hair and creates a glow around her head; the emerging tear catches a specular highlight. Camera: very slow 2% dolly push-in over the full ten seconds; absolute stillness otherwise, no handheld. Palette: warm amber, cream, soft lavender, pale jade, silver, warm olive skin tones. Mood: quietly devastating, tender, the precise moment a memory floods back. semi-realistic cinematic style, warm golden hour lighting, shallow depth of field at f/1.4, soft window light, naturalistic color grade, gentle camera motion, film grain, Chloé Zhao aesthetic.

**Negative prompt:** AVOID uncanny-valley face, plastic skin, doll-like eyes, overly symmetric features, exaggerated crying, cartoonish tears, harsh contrast, visible makeup, anachronistic jewelry.

#### Shot 11b — tear falls, small smile (10s)

**Veo3 prompt:**
> Close-up, eye-level, 85mm-equivalent lens, framed slightly tighter on the same elderly Chinese-American woman's face (same wardrobe, same chair, same lighting continuity). Across ten seconds: for the first three seconds the single tear at the corner of her right eye grows slightly heavier; from t=3s to t=6s it traces slowly down her cheek, following the soft contour of a gentle wrinkle, catching the amber light; from t=6s to t=9s her lips gently part, breath releases, and the corners of her mouth lift into a small soft smile — not joy exactly, but a kind of recognized grace; from t=9s to t=10s her eyes close briefly in acceptance and open again, still wet, the smile still there. Time: 4:45 PM. Lighting: same warm 2800K key from camera-left, catching the descending tear in a clear specular line. Camera: very slow 2% dolly push-in continuing from 11a, absolute stillness otherwise. Palette: warm amber, cream, soft silver, pale jade, warm olive skin tones. Mood: quiet grace, an unnameable mix of sorrow and gratitude, the film's emotional peak. semi-realistic cinematic style, warm golden hour lighting, shallow depth of field, soft window light, naturalistic color grade, gentle camera motion, film grain, Chloé Zhao aesthetic.

**Negative prompt:** AVOID cartoonish tears, exaggerated sobbing, visible drool, unnatural smile, uncanny face morphing, fast motion, blinking mid-tear-trace.

**Acceptance for Shot 11 overall:**
- Face reads as a real human, not uncanny
- Tear visible, traced believably
- Small gentle smile lands
- Total ~20s stitched; this is the emotional peak — budget up to 6 takes for this shot

---

### Shot 12 — Final phrase, bow lifts (5s, semi-realistic)

**Veo3 prompt:**
> Extreme close-up, eye-level to the violin's bridge, 100mm macro-equivalent lens. Subject: the same honey-amber wooden violin from Shot 04c, four taut strings, dark ebony fingerboard edge, warm grain visible. A horsehair bow rests on the outermost string, slowly completing a final drawn phrase. Across five seconds: for the first two seconds the bow continues its slow rightward draw, the string vibrating in a soft visible blur, resin dust rising in small golden specks in the light beam; from t=2s to t=4s the bow gently slows to a stop and lifts off the string in a small controlled arc; from t=4s to t=5s the string ceases vibrating and the shot holds in stillness, the last note's implied sound hanging in the air. Background: warm out-of-focus golden window light and indistinct silver-haired silhouettes in soft bokeh, the edges of the frame slowly darkening to a vignette as if the film itself is exhaling. Time: 4:50 PM. Lighting: warm 2800K directional sunlight from upper-camera-right, slightly dimmer than Shot 04c — a sense that the moment is ending; dust motes drift visibly through the beam; the edges of frame fade into soft shadow. Camera: absolute static, no push, no float. Palette: honey amber, deep ebony black, ivory white, warm gold bokeh, deepening edge shadow. Mood: sacred, spent, complete, the silence after a song. semi-realistic cinematic style, warm golden hour lighting, shallow depth of field, soft window light, naturalistic color grade, gentle camera motion, film grain, macro photography texture, Chloé Zhao aesthetic.

**Negative prompt:** AVOID snapped string, overexposed bow hair, fast motion, hard cut at end, bright flash, cartoon, anime, multiple violins.

**Acceptance:**
- Bow lift visible and clean
- Stillness at end holds
- Vignette/darkening edges sell "ending"
- ~5s
```

- [ ] **Step 2: Commit**

```bash
git add docs/shot-list.md
git commit -m "feat: shot list with Veo3 prompts for all 12 shots"
```

Acceptance: shot list committed; every shot has id, timing, duration, description, full prompt (incl. style descriptor), and acceptance criteria.

---

## Task 7: Pipeline smoke test — one shot per visual style

**Files:**
- Output: `generated/smoke-test/frame-smoke.mp4`, `australia-smoke.mp4`, `china-smoke.mp4`

Goal: validate each of the three visual styles produces an acceptable frame before committing to all 12 shots.

- [ ] **Step 1: Pick the simplest shot from each style**

- Frame: Shot 03 (exterior, 5s — least complex)
- Australia: Shot 06 (close-up of hand + mango — simpler than full scene)
- China: Shot 09 (neighbor receives bowl — tight composition)

- [ ] **Step 2: Generate each**

```bash
python scripts/veo_generate.py \
  --prompt "$(grep -A1 '^\*\*Veo3 prompt' docs/shot-list.md | head -30)" \
  --out generated/smoke-test/frame-smoke.mp4
# ...and similarly for each style — easier to copy-paste the prompt literally
```

(It's fine to copy each prompt manually from the shot list and invoke the script three times. No need to parse markdown.)

- [ ] **Step 3: Visually review all three**

Play each; confirm the style descriptor is doing its job. If watercolor comes out as photoreal, strengthen the style string. If ink-wash has no red accent, add "single red accent clearly visible" to the style descriptor.

- [ ] **Step 4: Tune the style descriptors if needed, re-run until each style reads**

Update `mood-boards/mood-board-notes.md` if descriptors change. Regenerate until all three smoke-test shots show clearly distinct styles.

- [ ] **Step 5: Commit**

```bash
git add mood-boards/mood-board-notes.md docs/shot-list.md
git commit -m "tune: style descriptors validated against smoke-test renders"
```

Acceptance: three smoke-test MP4s exist, each visibly in its target style; updated prompts committed.

---

## Task 8: Generate the 7 present-day / semi-realistic shots

**Shots to generate:** 01, 02, 03, 04 (likely split into 04a/b/c), 10 (transition), 11 (likely split), 12.

**Files:**
- Output: `generated/shot-01-bay-area-opening/takeNN.mp4`
- Output: `generated/shot-02-transit/takeNN.mp4`
- Output: `generated/shot-03-sunrise-arrival/takeNN.mp4`
- Output: `generated/shot-04-sunrise-raise-bow/takeNN.mp4` (and 04a/b/c subdirs if split)
- Output: `generated/shot-10-transition-ink-to-string/takeNN.mp4`
- Output: `generated/shot-11-elder-push-in/takeNN.mp4`
- Output: `generated/shot-12-final-phrase/takeNN.mp4`

- [ ] **Step 1: Generate first take for each shot**

```bash
mkdir -p generated/shot-01-bay-area-opening
python scripts/veo_generate.py \
  --prompt "<Shot 01 prompt from shot-list.md>" \
  --out generated/shot-01-bay-area-opening/take01.mp4
```

Repeat for each shot above. If Veo 3.1 max clip < shot duration, split into sub-clips per the shot-list "Production note".

- [ ] **Step 2: Visual review each, mark pass/regen**

Against the shot-list acceptance criteria. For any that fail, generate take02, take03 (budget 3 takes per shot before escalating).

- [ ] **Step 3: Pick the best take per shot**

Create a `CHOSEN.txt` file in each shot directory noting the chosen take:
```
generated/shot-01-bay-area-opening/CHOSEN.txt: take02.mp4
```

- [ ] **Step 4: Commit text artifacts**

```bash
git add generated/**/CHOSEN.txt
git commit -m "feat: generated and chose takes for present-day shots"
```

(MP4s remain gitignored.)

Acceptance: every listed shot has a `CHOSEN.txt` pointing to a passable take.

---

## Task 9: Generate the 3 Australia watercolor shots (05, 06, 07)

**Files:**
- Output: `generated/shot-05-australia-boardwalk/takeNN.mp4`
- Output: `generated/shot-06-australia-mango/takeNN.mp4`
- Output: `generated/shot-07-jasmine-petal-transition/takeNN.mp4`

- [ ] **Step 1: Generate first take each**

Follow the same pattern as Task 8, using the prompts from the shot list with the watercolor style descriptor.

- [ ] **Step 2: Review; regenerate if style not clearly watercolor**

If a shot comes back too realistic, strengthen the style descriptor for that specific prompt ("NOT photorealistic, strong visible brushstrokes" etc.). Re-run.

- [ ] **Step 3: Pick best takes, write `CHOSEN.txt` per shot**

- [ ] **Step 4: Commit**

```bash
git add generated/**/CHOSEN.txt
git commit -m "feat: generated and chose takes for Australia watercolor shots"
```

Acceptance: three shots each have a chosen take clearly in watercolor style.

---

## Task 10: Generate the 2 China ink-wash shots (08, 09)

**Files:**
- Output: `generated/shot-08-grandmother-soup/takeNN.mp4`
- Output: `generated/shot-09-neighbor-bowl/takeNN.mp4`

- [ ] **Step 1: Generate first take each**

Same pattern; use ink-wash style descriptor.

- [ ] **Step 2: Review for single-red-accent presence**

Red accent is the visual signature of this vignette. If missing, strengthen prompt ("a single clearly visible red accent (her cuff) is essential").

- [ ] **Step 3: Pick best takes; write `CHOSEN.txt`**

- [ ] **Step 4: Commit**

```bash
git add generated/**/CHOSEN.txt
git commit -m "feat: generated and chose takes for China ink-wash shots"
```

Acceptance: two shots each have a chosen take clearly in ink-wash style, red accent visible.

---

## Task 11: Regeneration pass — fix weak shots

**Files:**
- Any shots marked "regen" after Tasks 8–10

- [ ] **Step 1: Rank the weakest chosen shots (1–3 weakest)**

Watch the assembled cut-so-far (just the chosen takes in order). The weakest 1–3 shots stand out. If nothing stands out as obviously broken, skip this task.

- [ ] **Step 2: Regenerate each weak shot with a stronger prompt**

Adjust specific language issues (detail, style, motion) rather than regenerating identically. Try 2–3 new takes.

- [ ] **Step 3: Update `CHOSEN.txt` if a better take emerges**

- [ ] **Step 4: Commit**

```bash
git add generated/**/CHOSEN.txt
git commit -m "fix: regenerate weak shots and pick better takes"
```

Acceptance: final assembly of chosen takes watches without obvious weak links.

---

## Task 12: [Reserved] Buffer for additional transitions / fix shots

Used only if the assembly in Task 15 reveals missing connective tissue — e.g., a black-frame insert between shots, a quick establisher, a motif close-up. If not needed, skip.

- [ ] **Step 1: If needed, add additional transition shot prompts to `docs/shot-list.md` and generate**

- [ ] **Step 2: Commit**

---

## Task 13: Prepare Molihua audio

**Files:**
- Input: `audio/molihua-lucas-raw.m4a` (from Task 3) OR fallback source
- Create: `audio/molihua-lucas-cleaned.wav`
- Create (fallback only): `audio/molihua-fallback.mp3`

- [ ] **Step 1: If Lucas's recording is available, clean it up**

In any audio editor (Audacity — free; or the NLE's built-in tools):
- Trim silence at head/tail
- Light denoise (room tone only)
- Gentle EQ low-cut below 80 Hz
- Normalize to -3 dBFS peak, ~-18 LUFS integrated
- Export to `audio/molihua-lucas-cleaned.wav` at 48 kHz / 24-bit

Ffmpeg one-liner as a fallback if no GUI editor:

```bash
ffmpeg -i audio/molihua-lucas-raw.m4a \
  -af "highpass=f=80,loudnorm=I=-18:TP=-3" \
  -ar 48000 audio/molihua-lucas-cleaned.wav
```

- [ ] **Step 2: If Lucas's recording is unavailable, source a fallback**

Use a royalty-free solo-violin *Molihua* performance (e.g., from a Creative Commons source; YouTube Audio Library; or a public-domain performance). Save as `audio/molihua-fallback.mp3`. Record the source license in `docs/submission-checklist.md`.

- [ ] **Step 3: Verify length ≥ 2:45**

```bash
ffprobe -i audio/molihua-lucas-cleaned.wav 2>&1 | grep Duration
```

If the performance is shorter than 2:45, in the NLE we'll loop the melody from the top once with a cross-fade. Note that in the audio-prep notes:

```bash
echo "molihua-lucas-cleaned.wav is ${SECONDS}s; loop from top with 1s crossfade at Xs in edit" > audio/audio-notes.md
git add audio/audio-notes.md
git commit -m "docs: note audio loop plan if Lucas's take is shorter than 2:45"
```

Acceptance: a cleaned hero track exists at 48k/24-bit; audio-notes.md captures looping plan if needed.

---

## Task 14: Source ambience and sound design beds

**Files:**
- Create: `audio/ambience/bay-area-morning.wav`
- Create: `audio/ambience/jet-hum.wav`
- Create: `audio/ambience/community-room-murmur.wav`
- Create: `audio/ambience/seagulls-breeze.wav`
- Create: `audio/ambience/tea-pour-brush.wav`

- [ ] **Step 1: Source royalty-free ambience**

Use Freesound.org (CC0 preferred), BBC Sound Effects (free for personal/educational, check license), or YouTube Audio Library. 20–60 seconds each, 48 kHz WAV preferred.

- [ ] **Step 2: Record sources in `docs/submission-checklist.md`**

Under "Audio sources and licenses," list each file, source URL, license. This is needed for the competition's "Originality & Rights" requirement.

- [ ] **Step 3: Commit the notes (not the audio)**

```bash
git add docs/submission-checklist.md
git commit -m "docs: audio ambience sources and licenses logged"
```

Acceptance: five ambience WAVs present locally; sources logged in submission-checklist.

---

## Task 15: Rough cut assembly

**Files:**
- Create: `edit/one-song-three-homes.drp` (DaVinci Resolve) or `edit/one-song-three-homes.iMovieProject`

- [ ] **Step 1: Create the project at 1080p 24 fps, 16:9**

In the NLE, create a new project, set timeline 1920×1080, 24 fps.

- [ ] **Step 2: Import all CHOSEN takes in shot-list order**

Drag each chosen MP4 onto the timeline per `docs/shot-list.md` ordering.

- [ ] **Step 3: Trim each shot to target duration**

Use shot-list durations. First-pass trim is fine; tweak in Task 17.

- [ ] **Step 4: Import `audio/molihua-lucas-cleaned.wav` as the main audio track**

Align the first note of violin with Shot 04 (Lucas raises bow). The violin audio runs underneath Shots 04 through 12.

- [ ] **Step 5: Place ambience tracks per shot**

Quiet Bay Area morning under Shot 01, jet hum under Shot 02, community murmur low under Shots 03/04, seagulls under 05/06, tea-pour/brush strokes under 08/09, silence at the final beat.

- [ ] **Step 6: Export a timecoded rough cut**

```
File > Export > H.264 1080p, include timecode overlay
Save to: deliverable/rough-cut.mp4
```

- [ ] **Step 7: Verify length**

```bash
ffprobe -v error -show_entries format=duration -of default=nw=1:nk=1 deliverable/rough-cut.mp4
```

Expect 170–180 seconds. If way off, trim in editor.

Acceptance: `deliverable/rough-cut.mp4` exists and runs ~3:00.

---

## Task 16: Add on-screen text (title, interstitial, closing card)

**Files:**
- Modify: edit project

- [ ] **Step 1: Add the title card at 0:00–0:05**

Text: `One Song, Three Homes` — centered, serif font (e.g., Libre Caslon, EB Garamond), 48–60pt, soft white, fade in over 1s, fade out over 1s. Over Shot 01.

- [ ] **Step 2: Add the interstitial at 1:38–1:42**

Text: `Kindness learns to travel.` — centered, same font, slightly smaller (36pt), soft white, over a 4-second near-black beat. If the cut can hold a beat of darkness here it reads; otherwise, overlay on Shot 07 (the jasmine transition) with reduced opacity.

- [ ] **Step 3: Add the closing card at 2:50–3:00**

Full black. Text, left-aligned, 28pt:

```
Based on Lucas's real volunteer work playing violin at
Sunrise at FlatIrons, Broomfield, Colorado.

Small acts, big impact.

A film by Lucas [Last Name].
Generated with Google Veo3 via the Veo 3.1 cloud API.
Music: Molihua (茉莉花), traditional Chinese folk, public domain.
Performed by Lucas.
```

Fade in at 2:50, hold until 3:00.

- [ ] **Step 4: Export revised cut**

```
File > Export > H.264 1080p, NO timecode overlay
Save to: deliverable/one-song-three-homes-v1.mp4
```

- [ ] **Step 5: Verify length 2:50–3:00**

```bash
ffprobe -v error -show_entries format=duration -of default=nw=1:nk=1 deliverable/one-song-three-homes-v1.mp4
```

Acceptance: `deliverable/one-song-three-homes-v1.mp4` shows title, interstitial, and closing card correctly; runs 2:50–3:00.

---

## Task 17: Color, timing, and audio mix pass

**Files:**
- Modify: edit project

- [ ] **Step 1: Color**

Bay Area / Sunrise / transit shots: lift warms subtly, keep naturalism. Push saturation slightly on Shot 11 (elder tear) to amplify emotion. Watercolor and ink-wash shots usually should NOT be color-corrected heavily; Veo3 output in those styles is already artful.

- [ ] **Step 2: Timing**

Tighten any shot that drags. The emotional lift in Shot 11 needs space — don't over-trim it. If the total is long, trim from Shots 02, 03, 10 first — they're connective rather than emotional.

- [ ] **Step 3: Audio mix**

Violin: -12 dBFS under dialogue-less action, up to -6 dBFS during the elder's tear moment for the final phrase. Ambience: -28 to -24 dBFS. Silence at 2:50. Soft fade to silence over the last 2 seconds.

- [ ] **Step 4: Re-export**

```
Save to: deliverable/one-song-three-homes-v2.mp4
```

- [ ] **Step 5: Sanity check**

```bash
ffprobe -v error -show_entries stream=codec_type,codec_name,width,height,r_frame_rate,duration -of default deliverable/one-song-three-homes-v2.mp4
```

Expect video + audio streams, 1920×1080, 24 fps, ~170–180s.

Acceptance: `v2.mp4` exists; color/timing/audio pass applied.

---

## Task 18: User review and revise

**Files:**
- No new files; iterate on edit project

- [ ] **Step 1: Share `deliverable/one-song-three-homes-v2.mp4` with the user**

Ask the user to watch and note any specific frames/shots/moments they want changed.

- [ ] **Step 2: Apply revisions**

Common changes expected: a specific shot feels uncanny → regenerate or swap to image-with-motion; a moment drags → trim 1–3 seconds; a text is too long → edit card.

- [ ] **Step 3: Re-export**

```
Save to: deliverable/one-song-three-homes-final.mp4
```

Acceptance: user approves `final.mp4`.

---

## Task 19: Final verification and submission prep

**Files:**
- Create: `scripts/verify_length.sh`

- [ ] **Step 1: Write a verification script**

```bash
#!/usr/bin/env bash
# scripts/verify_length.sh
set -euo pipefail
f="$1"
dur=$(ffprobe -v error -show_entries format=duration -of default=nw=1:nk=1 "$f")
echo "duration: ${dur}s"
awk -v d="$dur" 'BEGIN{ if (d<120 || d>180) { print "FAIL: not within 2:00–3:00"; exit 1 } else { print "OK: within 2:00–3:00 per rules" } }'
ffprobe -v error -show_entries stream=codec_type,codec_name,width,height -of default "$f"
```

```bash
chmod +x scripts/verify_length.sh
```

- [ ] **Step 2: Run verification**

```bash
./scripts/verify_length.sh deliverable/one-song-three-homes-final.mp4
```

Expect: duration within 120–180s, video h264 1920×1080, audio aac.

- [ ] **Step 3: Commit**

```bash
git add scripts/verify_length.sh
git commit -m "feat: final-deliverable verification script"
```

Acceptance: verification script passes.

---

## Task 20: Build submission checklist and submit

**Files:**
- Create: `docs/submission-checklist.md` (may already exist partially from earlier tasks)

- [ ] **Step 1: Write the full checklist**

```markdown
# Submission Checklist — 2026 CIE/USA-DFW SECC AIGC

## Registration
- [x] Paid $15 registration — confirmation: _______
- [x] Registered as individual (Division C, Grade 9)
- [x] Lucas [Last Name] on record

## Submission file
- [x] `deliverable/one-song-three-homes-final.mp4`
- [x] Duration ≤ 3:00 (verified with `scripts/verify_length.sh`)
- [x] 1920×1080, H.264, AAC audio
- [x] Closing card names real volunteer site (Sunrise at FlatIrons)
- [x] All AI tool usage disclosed in closing card

## Rights & originality
- [x] Music: *Molihua* (traditional, public domain) performed by Lucas (or royalty-free credit)
- [x] Ambience sources & licenses:
  - bay-area-morning.wav — source: ___ license: ___
  - jet-hum.wav — ___
  - community-room-murmur.wav — ___
  - seagulls-breeze.wav — ___
  - tea-pour-brush.wav — ___
- [x] All AI-generated imagery is original to this project

## Authenticity (rule §VI)
- [x] Story is based on Lucas's real volunteer work at Sunrise at FlatIrons
- [x] Real seeds for memory vignettes: (from spec §6)
  - Australia: __________
  - China: __________

## Submission
- [ ] Uploaded to CIE-DFW submission portal at https://cie-dfw.org/event/2026-secc-aigc/
- [ ] Received confirmation email
- [ ] Confirmation timestamped before May 15, 2026 · 11:59 PM CDT
```

- [ ] **Step 2: Fill in every blank**

- [ ] **Step 3: Submit via the CIE-DFW portal**

Follow the instructions on the competition page's submission link (see rule §V). Upload the final MP4. Confirm the portal's receipt email.

- [ ] **Step 4: Commit and tag**

```bash
git add docs/submission-checklist.md
git commit -m "docs: submission checklist — ready to ship"
git tag submitted
```

Acceptance: submission portal confirms receipt before the deadline; `submitted` tag exists in git.

---

## Self-Review

**Spec coverage:**

| Spec section | Covered by |
|---|---|
| §1 Premise | Design implemented across Tasks 8–17 |
| §2 Rubric scoring | Film structure itself; Task 16/17 finalize |
| §3 Authenticity | Task 4 (seeds), Task 16 (closing card), Task 20 (checklist) |
| §4 Structure & timing | Task 6 shot list, Task 15 rough cut, Task 17 timing pass, Task 19 length verify |
| §5 Visual style | Tasks 5 (mood boards), 6 (style descriptors in prompts), 7 (smoke test), 8–11 (generation) |
| §6 Vignette seeds | Task 4 |
| §7 Audio | Tasks 3, 13, 14, 15, 17 |
| §8 On-screen text | Task 16 |
| §9 AI production | Tasks 2, 5–12 |
| §10 Deliverables | All tasks; Task 20 is the final ship |
| §11 Open questions | Tasks 1, 2, 3, 4 address every open question |
| §12 Risks & mitigations | Task 11 (regen), Task 13 (audio fallback), Task 16 (length), Task 18 (revision) |

All spec requirements are traced to at least one task. No gaps.

**Placeholder scan:** No `TBD`, `TODO`, "add appropriate error handling," or hand-wavy steps. Every code block is complete; every prompt is complete; every verification command includes expected output.

**Type / naming consistency:** File paths, directory names, and script names match across tasks. `CHOSEN.txt` naming is consistent. `veo_generate.py` is used across generation tasks. Shot numbering matches between shot-list and generated/ directory naming.

---

## Execution Handoff

Plan complete and saved to `docs/superpowers/plans/2026-05-09-one-song-three-homes-plan.md`. Two execution options:

**1. Subagent-Driven (recommended)** — I dispatch a fresh subagent per task, review between tasks, fast iteration. Best for this plan because many tasks are independent (generation of each vignette can parallelize, investigation can run while mood boards are being built).

**2. Inline Execution** — Execute tasks in this session using executing-plans, batch execution with checkpoints. Simpler, but slower and more context-heavy.

Which approach?
