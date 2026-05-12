# Shot List — One Song, Three Homes

**Production settings:**
- Model: `veo-3.1-generate-001`
- Parameters: `resolution=1080p`, `durationSeconds=8`, `aspectRatio=16:9`, `sampleCount=1`, `personGeneration=allow_all`. Note: `veo-3.1-generate-001` does NOT honor `enhancePrompt=false`; server-side enhancement is always on. The prompts below are written to be safe under that (sustained-moment style, no sequential-beat language).
- Hard limit: 8 seconds per clip (shots longer than 8s are pre-split into sub-clips)
- Fallback chain if 3.1 unavailable: `veo-3.1-fast-generate-001` → `veo-3.0-generate-001` → `veo-3.0-fast-generate-001`
- **Prompt-style rule:** every prompt describes ONE sustained moment held across the full 8 seconds. No timestamps, no "from t=Xs to t=Ys", no "first... then... finally". Only ambient/simultaneous continuous motion (camera push, drifting dust, curling steam, slow breath). Sequential beats on 3.1 cause the 8-second clip to generate as a mini-montage of separate scenes.

**How to generate a shot:**
Each shot is produced by sending the corresponding `prompts/shot-NN.txt` and `prompts/shot-NN.neg.txt` to Google Veo 3.1 via its cloud API (the `predictLongRunning` endpoint for Vertex AI Veo models), polling until the long-running operation completes, and saving the returned MP4 into `generated/shot-NN/take01.mp4`. Parameters used: model `veo-3.1-generate-001`, `resolution=1080p`, `aspectRatio=16:9`, `durationSeconds=8`, `personGeneration=allow_all`.

---

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
> Extreme close-up, eye-level to a desk surface, shot with a 50mm macro-style lens, framing the hands of an Asian-American teenage boy (age 14, warm olive skin, clean short fingernails, slender musician's fingers, a small silver string bracelet on the right wrist). He wears a dark charcoal-grey long-sleeve cotton top with sleeves pushed up to his forearms. One sustained held moment across the full eight seconds: his hands rest slowly and deliberately on top of a closed black rectangular violin case, fingertips curved over the chrome latches in a single quiet gesture of settling; the fingers linger with the weight of reverence, neither beginning nor completing any distinct motion, only holding the case in a prolonged breath of anticipation. The only motion is the gentle barely-perceptible rise and fall of his breath visible in the stillness of the fingers, and the slow drift of dust. The scene is a warm mid-century walnut wooden desk with visible grain; on the far right of the desk sits a small green jade succulent in a matte ceramic pot; on the far left sits a cream ceramic mug with thin white steam continuously curling upward; in soft-focus background a folded sheet-music page and a low mid-century wooden window frame, outside which a California bay-laurel tree silhouettes against a pale morning sky. It is 7:30 AM on a clear California morning. Lighting is warm 3500K directional sunlight pouring through the window from camera-right, casting long gentle shadows across the desk; a soft amber rim highlights the tops of the fingers and the curve of the latches; overall low-contrast with a gentle bloom on the brightest highlights; golden dust motes drift slowly and continuously through the light beam throughout. The camera performs a single uninterrupted barely perceptible 3% dolly push-in toward the case sustained across the entire eight seconds; a subtle handheld micro-jitter gives the shot a human present-tense feel. Palette: honey amber, warm walnut brown, cream white, muted jade green, brushed steel. Mood: quiet, reverent, intimate, a held breath of anticipation. semi-realistic cinematic style, warm golden hour lighting, shallow depth of field at f/1.8, soft window light, naturalistic color grade, gentle camera motion, film grain, Chloé Zhao aesthetic.

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
> Medium close-up from inside an airplane cabin, eye-level, shot with a 35mm equivalent lens, framed so the oval plane window fills the right two-thirds of the frame and the grey seatback foreground occupies a sliver of the left third. Through the window, far below, the snow-capped Rocky Mountains stretch to the horizon; individual peaks cast long blue-violet shadows across tilted white snowfields; a thin layer of haze diffuses the distance. A slice of the aircraft's silver wing, with one muted blue airline stripe, extends into the lower portion of the window. Above the mountains, the dawn sky gradates from deep indigo at the top to pink-peach near the horizon, with a sliver of bright gold where the sun breaks. One sustained held moment across the full eight seconds: the plane glides in a single prolonged steady cruise, the scene suspended in a hushed poetic stillness. The only motion is continuous and ambient: a tiny wisp of cloud drifts slowly past the wing throughout, distant snowfields gleaming with a faint drifting glitter, and the warm dawn light lies unbroken across the window's edge. Interior of the cabin is in soft shadow with warm 2800K cabin lighting barely catching the edge of the window frame. Outside, the sun is at 5:40 AM Mountain Time altitude, natural 4000K morning sunlight outside the aircraft; inside the cabin is low-light, contrasty against the bright window. Lighting emphasis: the window itself is the brightest element in the shot by a wide margin; rim light spills onto the gray leatherette seatback in warm pink-gold, held steady. Camera is static throughout, with only a subtle low-frequency engine vibration; imperceptible micro-handheld jitter sustained across the whole shot. Palette: deep indigo, pink peach, gold, cold white, dark gray, muted silver. Mood: poetic, quiet, reflective, a held-breath travel moment suspended in the air. semi-realistic cinematic style, warm golden hour lighting on the exterior contrasting cool cabin interior, shallow depth of field, soft window light, naturalistic color grade, gentle camera motion, film grain, Chloé Zhao aesthetic.

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
> Wide establishing shot, slightly low angle at knee-height looking up, shot on a 28mm-equivalent lens giving a mild sense of scale. The subject is the front entrance of a warm, cozy single-story senior-living community building: stone-and-cedar facade with horizontal wood siding the color of amber honey, a peaked roof with dark slate shingles, and a covered entry porch supported by square cedar columns. A tasteful rectangular sign beside the entrance door reads "Sunrise at FlatIrons" in serif gold lettering on a dark-brown background. The porch rail and steps are natural wood; a pair of wicker rocking chairs sit on the porch with a folded woven blanket over one; landscaping includes low purple-blue salvia, clumps of golden ornamental grass, and a curving flagstone path leading to the entry. In the mid-ground, two tall pine trees frame the building on the left, and the soft silhouette of the Flatirons mountain formation rises in the background against a peach-gold sky. One sustained held moment across the full eight seconds: the building sits in calm continuous welcome, every element holding its place in warm late-afternoon light. Ongoing ambient motion only: a warm interior lamp visible through a large window by the entrance glows steadily, a gentle breeze continuously stirs the grass clumps and sets the salvia swaying slowly, clouds drift in a slow uninterrupted procession across the sky, and the porch shadows barely lengthen with the hour. Time is 6:30 PM in late spring, right before magic-hour sunset. Lighting: the key light is a very warm 2800K sun low on camera-right, raking golden light across the building's facade and the path; deep long shadows stretch from the columns; the windows of the building spill warm 2400K interior light in soft pools onto the porch floor; subtle lens flare in the upper right where the sun hits the lens, held through the whole take. Camera performs one single uninterrupted very slow 4% dolly push toward the entrance sustained across the entire eight seconds, steady. Palette: honey amber, peach, deep pine green, flagstone grey, soft purple. Mood: welcoming, peaceful, expectant, home-like. semi-realistic cinematic style, warm golden hour lighting, shallow depth of field, soft window light, naturalistic color grade, gentle camera motion, film grain, Chloé Zhao aesthetic.

**Negative prompt:** AVOID sterile institutional look, hospital vibes, crowded parking lot, cluttered signage, visible modern cars, harsh midday light, pixelated text on sign, distorted lettering.

**Acceptance:**
- Warm, welcoming senior-living exterior
- Legible "Sunrise at FlatIrons" signage (font need not be exact)
- Golden hour clearly reads
- 16:9, ~5s

---

### Shot 04 — Interior, raise bow, first note (30s, semi-realistic, split into 04a/04b/04c)

**Production note:** Veo 3.1 caps clip length at 8 seconds, so shots longer than 8s are pre-split into sub-clips. Each sub-clip has its own fully detailed prompt below.

#### Shot 04a — enters and sits (10s)

**Veo3 prompt:**
> Wide shot, eye-level, 35mm-equivalent lens, framing a warm wood-paneled community room at a senior living facility: a semicircle of six elderly residents seated in comfortable cream-upholstered armchairs facing camera in the mid-ground, their backs largely to us so we see silver and grey heads and shoulders in soft focus; on the right, a grand piano; on the left, a large mullioned window letting golden late-afternoon sun pour across the wooden floor; a simple wooden chair is placed centered in front of the semicircle. One sustained held moment across the full eight seconds: a calm Asian-American teenage boy (age 14, warm olive skin, neatly cut short black hair, soft serious expression, wearing a crisp white button-down shirt with sleeves rolled once, black slim slacks, black polished dress shoes) is suspended in an ongoing slow walk toward the central chair, carrying a honey-brown wooden violin by the neck in his left hand and a bow in his right, his deliberate footsteps continuous and unhurried; he never fully arrives, only drifts with a reverent gait that holds the entire room in anticipation. The only motion is simultaneous and ambient: the slow sustained step, the barely-visible settling of the residents' shoulders, the slow drift of golden dust motes through the window light, and the soft continuous glow of warm sconces. Time: 4:30 PM late spring afternoon. Lighting: a key 2900K sunlight streaming through the left window at a 30-degree angle, painting a warm golden rectangle across the floor and the boy's white shirt, casting long shadows toward camera-right; soft fill bouncing off the cream-painted rear wall; the residents' silver hair catches gentle rim light; warm 2700K interior sconces glow low in the background, held steady. Camera: static wide the full eight seconds, with minimal handheld micro-jitter sustained throughout. Palette: cream, honey-wood, soft silver, warm white, amber, muted pine green. Mood: reverent, hushed, attentive, a room holding its breath. semi-realistic cinematic style, warm golden hour lighting, shallow depth of field, soft window light, naturalistic color grade, gentle camera motion, film grain, Chloé Zhao aesthetic.

**Negative prompt:** AVOID crisp recognizable faces of residents, distorted hands or fingers, six-fingered hands, cartoonish proportions, modern phones/devices visible, any visible text or signage, floating violin, unnatural walking gait.

#### Shot 04b — places violin, raises bow (10s)

**Veo3 prompt:**
> Medium close-up, eye-level, 50mm-equivalent lens, framing the same Asian-American teenage boy (age 14, warm olive skin, neatly cut short black hair, calm serious expression, crisp white button-down shirt sleeves rolled once) from just below his chest up to the top of his head, shot in three-quarter profile from camera-right. One sustained held moment across the full eight seconds: the honey-brown wooden violin is already tucked under his jaw against the dark chinrest with his left hand settled on the fingerboard, and his right hand holds the bow lifted in a smooth arc suspended just above the strings — the bow hovers a millimeter from the outermost string in prolonged, reverent readiness, never descending, only held. His eyes are softly closed and his lips are gently pressed, an inward prayerful stillness sustained through the entire take. Ambient simultaneous motion only: the barely visible rise and fall of a slow drawn breath in his chest, a single drifting dust mote in the light, and the soft continuous warmth of amber window glow on his cheekbone. Background: the out-of-focus cream-upholstered armchairs and silvery-haired audience, bathed in warm light; a single out-of-focus silver figure in the center-right leans slightly forward, held still. Time: 4:30 PM. Lighting: warm 2900K key from camera-right, catching his cheekbone and the curve of the violin's wood grain in a soft golden highlight held steady; gentle fill on the left side of his face; subtle rim on his hair, sustained. Camera: one single uninterrupted slow steady 5% dolly push-in creeping toward his face and the violin across all eight seconds. Palette: cream, warm wood, white cotton, soft amber, deep black. Mood: reverent, inward, almost prayerful, the suspended breath before the first note. semi-realistic cinematic style, warm golden hour lighting, shallow depth of field, soft window light, naturalistic color grade, gentle camera motion, film grain, Chloé Zhao aesthetic.

**Negative prompt:** AVOID distorted hands, extra fingers, violin held incorrectly, bow held like a pencil, plastic skin, overexposed highlights on violin, modern wristwatch.

#### Shot 04c — bow touches string, first note (10s)

**Veo3 prompt:**
> Extreme close-up, eye-level to the violin's bridge, shot on a 100mm macro-equivalent lens. Subject: a honey-amber wooden violin with four taut strings, a dark ebony chinrest just barely in frame at the top, and the fine grain of the maple and spruce visible. One sustained held moment across the full eight seconds: a horsehair bow is already settled in gentle contact with the outermost string, drawing slowly and continuously to the right in a single unbroken stroke; the string vibrates visibly in a soft sustained blur in the bow's wake, a faint ongoing glow of golden resin dust rising steadily from the contact point, the first note held in a prolonged singing breath. The draw never begins and never ends — it is the middle of the note, rendered for eight seconds. Ambient simultaneous motion only: the continuous vibration of the string, the continuous slow drift of resin dust motes through the light beam, and the gentle sway of warm bokeh. Background behind the violin is warm out-of-focus golden light from the window with indistinct silver-haired silhouettes beyond, all soft bokeh circles of amber, held steady. Time: 4:30 PM. Lighting: warm 2900K directional sunlight from upper-camera-right raking across the violin's curved wood, catching the edges of the strings in thin brilliant sustained lines, creating a honey-amber highlight along the length of the bridge; soft fill below from reflected floor light; dust motes drift continuously through the light beam throughout. Camera: one single uninterrupted barely perceptible 2% dolly push-in sustained over the entire eight seconds. Palette: honey amber, deep ebony black, ivory white (bow hair), soft warm gold bokeh. Mood: held-breath reverent, the sustained middle of a song's first note. semi-realistic cinematic style, warm golden hour lighting, shallow depth of field, soft window light, naturalistic color grade, gentle camera motion, film grain, macro photography texture, Chloé Zhao aesthetic.

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
> Medium wide shot, eye-level slightly low (at a toddler's height), shot with a 35mm-equivalent lens, framing a sunlit wooden boardwalk on the Australian coast: weathered silver-grey timber planks in the foreground running diagonally toward camera-left, white-painted timber railing on the left side, turquoise ocean meeting a pale horizon on the right, a soft-focus sandy beach below. In the mid-ground, a blonde-wood stroller with a cream canopy rolls very slowly and continuously forward along the boardwalk; inside sits an Asian toddler approximately two years old, round-cheeked with a small wisp of dark hair, wearing a cream linen wide-brim sun hat, a white and pale-yellow striped t-shirt, and soft blue cotton shorts; his tiny hand is outstretched, grasping the air in sustained curiosity. On the right side of the boardwalk, a friendly Australian stranger (middle-aged woman, tan freckled skin, sun-lightened brown hair loose to the shoulders, wearing a loose white linen button-down shirt and khaki shorts, leather sandals) is held mid-approach, walking slowly and continuously toward the stroller with a wicker basket over one arm, her gaze already warmly settled on the toddler; she is forever approaching, never arriving, suspended in the open warmth of the moment. One sustained held moment across the full eight seconds: the two moving elements — stroller drifting forward, stranger drifting inward — exist in a single prolonged parallel glide. Ongoing ambient motion only: the slow continuous drift of both figures, a gentle sea breeze lifting the stranger's loose hair, sunlight glittering continuously on the turquoise water beyond. Time: 11:00 AM on a bright Sydney-coast morning. Lighting: bright 5500K midday sun from above, high-key, soft bounce off the pale timbers and white railing, turquoise glow continuously reflected up onto faces from below; specular highlights flash and shimmer off the ocean; dappled light through sparse palm fronds offscreen creates gentle ongoing moving spots on the boardwalk. Camera: a single uninterrupted very slow handheld-style drift to the right, two percent, sustained across all eight seconds; organic micro-motion. Palette: sun-bleached timber silver, turquoise, white, pale yellow, soft blue, sand beige, warm flesh tones. Mood: sun-warmed, safe, open-hearted, a memory half-imagined, suspended in approach. hand-painted 2D watercolor animation, flat painterly rendering with no 3D depth, in the style of The Red Turtle and Studio Ghibli watercolor backgrounds, soft pastel palette, visible paper texture and wet-edge brushstrokes across the ENTIRE frame including skin and objects, impressionistic loose edges, dreamlike memory quality, sun-drenched seaside tones, 2D animated film aesthetic, NOT photorealistic, NO photographic skin, NO 3D lighting, NO depth-of-field blur, NO torn-paper border effect — the watercolor is the medium governing every pixel, not a frame around a photo.

**Negative prompt:** AVOID photorealism, crisp edges, 3D CGI look, photographic skin detail, dark shadows, heavy contrast, modern branded clothing, visible phone screens.

#### Shot 05b — stranger kneels beside stroller (10s)

**Veo3 prompt:**
> Medium close-up, eye-level at toddler height, 50mm-equivalent lens, framed on the Australian stranger and the stroller side-by-side. The middle-aged woman (tan freckled skin, sun-lightened brown shoulder-length hair, loose white linen shirt, khaki shorts) is already kneeling in three-quarter profile with her wicker basket set down beside her; the blonde-wood stroller with its cream canopy holds the Asian toddler (age ~2, cream sun hat, white-and-yellow striped t-shirt, soft blue shorts). One sustained held moment across the full eight seconds: the two hold continuous warm eye contact, their gazes locked in a prolonged exchange — the woman's expression a tender delighted smile, eyes crinkling softly at the corners and held there; the toddler's face lifted up with wide-eyed curiosity, lips slightly parted in soft wonder, tiny hand extended and suspended in the air between them in unfinished reaching. The look is the whole shot, held as a single frozen-yet-breathing moment of a stranger's kindness recognized. Ongoing ambient motion only: the gentle continuous lift of the woman's loose hair in the sea breeze, the slow drift of cream canopy fabric, the continuous shimmer of turquoise reflection on both their faces, and the soft sustained rise-and-fall of breath. Background: soft watercolor bleed of turquoise ocean and pale sky, with gentle washes of palm frond silhouettes on the right, all held in place. Time: 11:00 AM late spring morning. Lighting: high-key 5500K Sydney sunlight, bouncing off white railing behind them, casting gentle rim light on the woman's hair and the toddler's hat brim; soft continuous color spill of turquoise reflected onto their faces from the sea behind, sustained through the take. Camera: static for the full eight seconds with only subtle organic micro-float. Palette: cream, pale yellow, turquoise, warm sandy tan, soft pink cheek tones. Mood: warm, tender, safe, a stranger's kindness suspended in sunlight. hand-painted 2D watercolor animation, flat painterly rendering with no 3D depth, in the style of The Red Turtle and Studio Ghibli watercolor backgrounds, soft pastel palette, visible paper texture and wet-edge brushstrokes across the ENTIRE frame including skin and objects, impressionistic loose edges, dreamlike memory quality, sun-drenched seaside tones, 2D animated film aesthetic, NOT photorealistic, NO photographic skin, NO 3D lighting, NO depth-of-field blur, NO torn-paper border effect — the watercolor is the medium governing every pixel, not a frame around a photo.

**Negative prompt:** AVOID photoreal faces, sharp detail, CGI rendering, dark moody tones, heavy outlines, ink-wash style crossover.

**Acceptance for Shot 05 overall:**
- Clearly watercolor style — NOT photorealistic
- Pastel sunlit palette
- Tender exchange of looks legible
- Total ~20s stitched

---

### Shot 06 — Australia: stranger shares fruit (15s, watercolor)

**Veo3 prompt:**
> Extreme close-up, eye-level to the toddler's hand, shot on a 85mm macro-equivalent lens, framed on the exchange between two hands. In the foreground-right, the tan, freckled, weathered hand of the Australian stranger (adult woman, warm sun-kissed skin, faint blonde arm hair) gently offers a thick glowing slice of ripe yellow-orange mango between her thumb and forefinger, a tiny highlight of sweet juice catching the light on the mango's edge. In the foreground-left, the small plump hand of the Asian toddler (age ~2, soft pink palm, tiny dimpled fingers) reaches upward with wide-open fingers, tentative, curious. One sustained held moment across the full eight seconds: the two hands are suspended in a prolonged reach toward each other with the glowing mango slice held between them like a small sun, never completing the exchange — the toddler's fingers forever almost-touching, the stranger's offering hand forever almost-giving; the slender gap between fingers and fruit shimmers with heat and backlight in unbroken stillness. Ongoing ambient motion only: the continuous slow drift of both hands in micro-float as if held by the breath of the air, the continuous radiant glow of backlight through the translucent mango flesh, the slow ongoing dance of specular highlights on the single suspended drop of mango juice at the fruit's lower edge, and the faint continuous heat-shimmer of the air between. Background: soft watercolor wash of sunlit wooden boardwalk planks in pale peach and silver-grey, behind that a shimmering abstract suggestion of turquoise sea with white paper showing through for foam, all held still. Time: 11:00 AM. Lighting: bright high-key 5500K Australian sun directly behind the hands, creating a strong translucent golden glow through the thin mango slice so it looks like a piece of stained glass; soft warm rim light on both hands; specular highlights continuously dance on the juice drop. Camera: one single uninterrupted barely perceptible 2% slow push-in toward the mango sustained across all eight seconds. Palette: luminous yellow-orange, warm honey, pale pink skin tones, silver-grey boardwalk, hints of turquoise. Mood: tender, suspended, generous, sacrament-like — a gift held forever mid-offering. hand-painted 2D watercolor animation, flat painterly rendering with no 3D depth, in the style of The Red Turtle and Studio Ghibli watercolor backgrounds, soft pastel palette, visible paper texture and wet-edge brushstrokes across the ENTIRE frame including skin and objects, impressionistic loose edges, dreamlike memory quality, sun-drenched seaside tones, 2D animated film aesthetic, NOT photorealistic, NO photographic skin, NO 3D lighting, NO depth-of-field blur, NO torn-paper border effect — the watercolor is the medium governing every pixel, not a frame around a photo.

**Negative prompt:** AVOID photorealism, crisp edges, 3D render look, harsh contrast, distorted fingers, six-fingered hands, photographic skin pores, visible branding.

**Acceptance:**
- Watercolor style unmistakably reads
- Tender hand-to-hand exchange
- The mango glows like a jewel
- ~15s

---

### Shot 07 — Jasmine petal transition (10s, watercolor → ink-wash)

**Veo3 prompt:**
> Medium close-up, eye-level, 50mm-equivalent lens, framed on a single white jasmine blossom petal drifting gently and continuously on a soft air current from the upper-left of frame toward the lower-right, occupying roughly ten percent of the frame. One sustained held moment of continuous metamorphosis across the full eight seconds: the petal drifts uninterruptedly throughout the entire shot in a single slow diagonal glide, while the background simultaneously and continuously undergoes an ongoing gradual transformation from hand-painted watercolor into Chinese ink-wash — not as sequential phases but as a single sustained dissolving change happening at every moment. Turquoise, peach, and cream pigments continuously bleed outward and desaturate, wet-edge paper texture slowly giving way to rice-paper grain, color draining continuously into monochrome cool grey, and a single small vermilion red seal mark (square, bright) continuously emerges into clarity in the lower-right corner; the petal's rendering shifts continuously with the medium, its edges softening from watercolor wash into a single ink-stroke suggestion of white against grey. The transformation is one unbroken held metamorphosis, never arriving, never beginning, always in the middle of becoming. Ambient simultaneous motion only: the continuous drift of the petal, the continuous bleed and evolution of pigment, soft ongoing paper breath. Time and lighting do not apply literally — this is a poetic sustained metamorphosis. Palette transitions continuously: turquoise, peach, cream, soft white dissolving into cool ink grey, rice-paper cream, vermilion red, soft white. Mood: meditative, in-between, a memory handing off to a memory, held in suspension. Style: hand-painted 2D watercolor animation continuously dissolving into traditional Chinese ink-wash (shui-mo), flat painterly rendering with no 3D depth, in the style of The Red Turtle and Studio Ghibli watercolor backgrounds blended with calligraphic bleeding ink on rice paper, soft pastel-to-monochrome palette, visible paper texture and wet-edge brushstrokes across the ENTIRE frame, impressionistic loose edges, dreamlike memory quality, 2D animated film aesthetic, NOT photorealistic, NO photographic skin, NO 3D lighting, NO depth-of-field blur, NO torn-paper border effect — the watercolor-to-ink-wash metamorphosis is a continuous artistic effect governing every pixel, not a hard cut or sequential montage.

**Negative prompt:** AVOID hard cuts or dissolves between the two styles, visible splice, 3D rendering, photorealism, multiple petals, distracting background clutter.

**Acceptance:**
- Petal is continuously visible and drifting
- Clear artistic transformation from watercolor to ink-wash mid-shot
- ~10s

---

### Shot 08 — China: grandmother prepares food (25s, ink-wash, split into 08a/08b if needed)

#### Shot 08a — hands and soup (12s)

**Veo3 prompt:**
> Close-up, eye-level to a low wooden table, 50mm-equivalent lens, framed on the hands of an elderly Chinese grandmother: soft wrinkled hands with thin silver wedding band on the left ring finger, warm olive skin, rendered entirely in the style of a traditional Chinese ink-wash (shui-mo) painting — calligraphic brush strokes defining the contours, soft bleeding ink suggesting depth, monochrome cool grey on cream rice paper. She wears a simple traditional mandarin-collar tunic in ink-grey tones, with a single vermilion red cuff visible on her right wrist as the one hot spot of color in the frame. One sustained held moment across the full eight seconds: her right hand is suspended mid-ladle, slowly and continuously pouring a steaming ribbon of soup from an iron ladle into a white porcelain bowl held steady in her left hand; the pour is unbroken and ongoing, never beginning, never ending, a prolonged sacred act of feeding held in the middle. Ambient simultaneous motion only: the continuous elegant calligraphic curl of rising steam in slow unfurling brush strokes, the slow sustained thread of soup falling from ladle into bowl, the barely-perceptible breath of the rice paper itself, and the gentle ongoing bleed of ink along the contours of her hands. Background: a traditional courtyard kitchen suggested with minimal ink strokes — a wooden shelf hinting at jars and utensils in the soft distance, a wisp of jasmine sprig on the table just visible, overall mostly empty rice-paper cream, held still. Time of day is poetically unspecified — a memory's light. Lighting in the ink-wash convention: soft overall illumination, no hard shadows; the single vermilion red cuff is the only saturated color, held steady. Camera: static throughout, with minimal subtle organic paper-shift micro-motion as if the paper itself breathes. Palette: cool ink grey, rice-paper cream, a single vermilion red, soft black. Mood: tender, reverent, timeless, the quiet grace of care held in a sustained pour. traditional Chinese ink-wash painting (shui-mo) style, monochrome with a single red accent, calligraphic brush strokes, soft bleeding ink on rice paper, minimalist composition, jasmine motif, still contemplative mood.

**Negative prompt:** AVOID photorealism, full color, Western oil-painting style, 3D rendering, cluttered background, multiple red accents, anime or cartoon, distorted hands, six-fingered hands, modern appliances.

#### Shot 08b — steam rises (13s)

**Veo3 prompt:**
> Medium close-up, slight low angle, 50mm-equivalent lens, framed on the white porcelain bowl of soup held between the grandmother's two hands (same elderly Chinese grandmother as 08a, ink-wash style, vermilion red cuff). The bowl occupies the center-lower third of frame; above it, steam rises in long elegant calligraphic curls. One sustained held moment across the full eight seconds: steam rises continuously and unbroken in elegant calligraphic curls, each wisp rendered as a single fluid brush stroke that elongates, twists, and dissolves into the rice-paper background in perpetual ongoing flow; the steam never fully forms and never fully dissolves — it is a sustained continuous breath of curling vapor, some wisps drifting wider to form the barest suggestion of jasmine-blossom shapes that never quite resolve. Ambient simultaneous motion only: the endless continuous unfurl of steam, the subtle continuous breath of the rice paper, the soft ongoing hold of the bowl, and the vermilion cuff's sustained vibration of color against the monochrome. Background: rice-paper cream, almost empty, with a soft suggestion of courtyard light to the right in the palest grey brush strokes, held still. Time: poetic, indeterminate. Lighting convention: flat ink-wash illumination, no hard shadows, the vermilion cuff vibrating continuously against the monochrome. Camera: static with minimal paper-shift breath sustained through the full eight seconds. Palette: rice-paper cream, cool grey, vermilion red, soft black. Mood: contemplative, warm despite the monochrome, the silence of a sacred small act held in a prolonged exhalation. traditional Chinese ink-wash painting (shui-mo) style, monochrome with a single red accent, calligraphic brush strokes, soft bleeding ink on rice paper, minimalist composition, jasmine motif, still contemplative mood.

**Negative prompt:** AVOID multiple red elements, photorealistic steam, 3D rendering, dense cluttered background, full-color palette, CGI smoke.

**Acceptance for Shot 08 overall:**
- Unambiguously Chinese ink-wash style
- Single vermilion red accent clearly visible
- Steam renders as calligraphic brushwork
- Total ~25s stitched

---

### Shot 09 — China: neighbor receives bowl (15s, ink-wash)

**Veo3 prompt:**
> Medium shot, eye-level, 50mm-equivalent lens, framed in portrait-width centered composition on two figures at a simple wooden courtyard door. On camera-left, the elderly Chinese grandmother (soft wrinkled face, silver-grey hair pulled into a low bun, mandarin-collar ink-grey tunic with the single vermilion red cuff on her right wrist). On camera-right, an elderly neighbor woman (warm-weathered face, white hair in a short bob, simple collared robe in ink-grey). One sustained held moment across the full eight seconds: the steaming white porcelain bowl is suspended between them, held by both pairs of hands at once — the grandmother's hands gently letting go as the neighbor's hands gently receive, their fingers lightly touching along the rim of the bowl in a prolonged shared cradle that never completes the transfer. Both faces are lifted slightly, eyes softly meeting in a warm sustained mutual gaze, tender gratitude held in a single breath. Ambient simultaneous motion only: the continuous elegant curl of jasmine-tea steam rising in calligraphic brush strokes between them at face level, lingering and dissolving continuously; the slow ongoing sway of a sprig of jasmine vine in the upper-left corner rendered in delicate brush strokes; the subtle continuous breath of the rice paper. Background: a simple wooden courtyard door in the mid-ground, ink-suggested wood grain; behind, a hint of a stone wall and the jasmine vine; an almost empty rice-paper cream background dominates, held still. Time: poetic, a mid-afternoon of memory. Lighting: flat ink-wash illumination, no shadows; the grandmother's single vermilion red cuff remains the only saturated color (the neighbor wears no red), held steady. Camera: static with minimal paper-breath motion sustained through all eight seconds. Palette: rice-paper cream, cool grey, vermilion red, soft black, warm skin undertone in muted sepia. Mood: tender, grateful, timeless, the heart of the vignette held in shared hands. traditional Chinese ink-wash painting (shui-mo) style, monochrome with a single red accent, calligraphic brush strokes, soft bleeding ink on rice paper, minimalist composition, jasmine motif, still contemplative mood.

**Negative prompt:** AVOID multiple red accents, full color spill, photorealism, 3D look, modern clothing, Western aesthetic, distorted hands, plastic skin.

**Acceptance:**
- Unmistakably ink-wash
- Bowl exchange legible
- Single red accent (grandmother's cuff) clearly visible
- ~15s

---

### Shot 10 — Ink-stroke to violin-string transition (5s, hybrid)

**Veo3 prompt:**
> Extreme close-up, eye-level, 100mm macro-equivalent lens, framed on a single long horizontal element that occupies the horizontal middle of the frame. One sustained held moment of continuous metamorphosis across the full eight seconds: the frame holds a single line undergoing an unbroken ongoing transformation from ink brush stroke into vibrating violin string throughout the entire take. The line is always mid-change — wet-edged calligraphic bristle texture continuously sharpening into taut metallic gleam; rice-paper cream continuously bleeding into warm honey wooden grain; monochrome cool ink grey continuously warming into golden amber; the stroke's soft bleed continuously tautening into the resonant hum of a steel-core violin string. A horsehair bow drifts in gently from camera-left in slow continuous motion and glides across the transforming string in a sustained unbroken draw, resin dust rising in tiny golden specks that themselves drift continuously through the beam of slowly warming light. The metamorphosis never fully resolves — it is suspended in the middle, the stroke forever becoming the string, forever being played. Ambient simultaneous motion only: the continuous gentle drift of the bow, the continuous vibration of the line, the continuous rise of resin/ink motes, and the continuous lighting shift. Time: the present-day — the return to the retirement-home scene, held in the threshold. Lighting continuously transforms alongside the imagery: flat ink-wash illumination continuously warming into warm 2900K directional sunlight from upper-camera-right, with dust motes drifting continuously in the beam. Camera: static the full eight seconds with minimal micro-motion. Palette continuously shifts: rice-paper cream, ink grey, a hint of vermilion dissolving continuously into honey amber, warm wood, brushed steel, ivory bow hair, soft amber bokeh. Mood: poetic metamorphosis, inside-to-outside, memory-to-present, held in the suspended moment of becoming. Style: traditional Chinese ink-wash with bleeding edges and calligraphic texture continuously metamorphosing into semi-realistic cinematic with warm golden hour lighting, shallow depth of field, film grain, Chloé Zhao aesthetic; the transformation is one sustained continuous artistic metamorphosis, not a dissolve, not a cut, not a sequence.

**Negative prompt:** AVOID hard cuts, visible splice line, 3D rendering, cartoon, mid-shot style flicker, multiple distinct shots, obvious wipe transition.

**Acceptance:**
- Clear visible transformation mid-shot
- Bow glide visible at end
- ~5s

---

### Shot 11 — Push in on elder's face (20s, semi-realistic, split into 11a/11b if needed)

#### Shot 11a — breath catches, tear forms (10s)

**Veo3 prompt:**
> Medium close-up, eye-level, 85mm-equivalent lens, framed on the face of an elderly Chinese-American woman in her late seventies to early eighties: warm olive skin with soft gentle wrinkles, silver-grey hair pulled back into a simple low bun, kind deep-brown eyes, thin lips in a soft neutral rest; she wears a pale lavender cashmere cardigan over a cream blouse with a small pearl button visible at the collar; a tiny delicate jade pendant on a thin gold chain rests just above the collar. She is seated in a cream-upholstered armchair, the background a warm out-of-focus community room with a golden-window-light glow. One sustained held moment across the full eight seconds: her face is held in a prolonged inward remembering — brows gently lifted, gaze soft and drifting beyond the frame as if looking through years, a subtle micro-expression of recognition suspended across her features; her eyes continuously well with tears that slowly grow heavier and heavier at the lower lids, a single tear beading at the corner of her right eye and continuously swelling under its own increasing weight throughout the take, shimmering in the amber light, never falling. The tear is forever almost-falling, the memory forever almost-arriving. Ambient simultaneous motion only: the continuous slow swelling of the tear, the barely-visible sustained tremor of emotion in her lower lip, the slow continuous rise and fall of a held breath, and the soft drift of warm bokeh behind her. Time: 4:45 PM late-afternoon. Lighting: warm 2800K golden sunlight from camera-left at a 45-degree angle, key-lighting the left side of her face in soft amber, leaving the right side in gentle warm shadow; a subtle bounce of cream fill from the armchair on her right cheek; rim light through the window catches the silver of her hair and creates a glow around her head, held steady; the growing tear catches a continuous specular highlight. Camera: one single uninterrupted very slow 2% dolly push-in over the full eight seconds; absolute stillness otherwise, no handheld. Palette: warm amber, cream, soft lavender, pale jade, silver, warm olive skin tones. Mood: quietly devastating, tender, the precise moment a memory floods back, held in suspended recognition. semi-realistic cinematic style, warm golden hour lighting, shallow depth of field at f/1.4, soft window light, naturalistic color grade, gentle camera motion, film grain, Chloé Zhao aesthetic.

**Negative prompt:** AVOID uncanny-valley face, plastic skin, doll-like eyes, overly symmetric features, exaggerated crying, cartoonish tears, harsh contrast, visible makeup, anachronistic jewelry.

#### Shot 11b — tear falls, small smile (10s)

**Veo3 prompt:**
> Close-up, eye-level, 85mm-equivalent lens, framed slightly tighter on the same elderly Chinese-American woman's face (same wardrobe, same chair, same lighting continuity). One sustained held moment across the full eight seconds: a single tear traces slowly and continuously down her right cheek in an unbroken glistening thread, following the soft contour of a gentle wrinkle and catching the amber light in a steady specular line; simultaneously and continuously, the corners of her mouth are lifting into the earliest beginning of a small soft smile — not joy exactly, but an unfolding recognition of grace. The tear is forever tracing, never arriving at her jaw; the smile is forever beginning, never fully formed. Her eyes remain softly open, wet and bright, gaze inward, breath continuously released in a slow exhale. The whole face is suspended in the middle of a single profound emotion — sorrow and gratitude held as one unbroken breath. Ambient simultaneous motion only: the continuous slow trace of the single tear, the continuous almost-imperceptible lift of the mouth corners, the slow sustained breath, and the soft ongoing drift of warm amber bokeh behind her. Time: 4:45 PM. Lighting: warm 2800K key from camera-left, catching the descending tear in a continuous specular line held throughout. Camera: one single uninterrupted very slow 2% dolly push-in continuing from 11a sustained across all eight seconds, absolute stillness otherwise. Palette: warm amber, cream, soft silver, pale jade, warm olive skin tones. Mood: quiet grace, an unnameable mix of sorrow and gratitude held in suspension, the film's emotional peak. semi-realistic cinematic style, warm golden hour lighting, shallow depth of field, soft window light, naturalistic color grade, gentle camera motion, film grain, Chloé Zhao aesthetic.

**Negative prompt:** AVOID cartoonish tears, exaggerated sobbing, visible drool, unnatural smile, uncanny face morphing, fast motion, blinking mid-tear-trace.

**Acceptance for Shot 11 overall:**
- Face reads as a real human, not uncanny
- Tear visible, traced believably
- Small gentle smile lands
- Total ~20s stitched; this is the emotional peak — budget up to 6 takes for this shot

---

### Shot 12 — Final phrase, bow lifts (5s, semi-realistic)

**Veo3 prompt:**
> Extreme close-up, eye-level to the violin's bridge, 100mm macro-equivalent lens. Subject: the same honey-amber wooden violin from Shot 04c, four taut strings, dark ebony fingerboard edge, warm grain visible. A horsehair bow rests on the outermost string. One sustained held moment across the full eight seconds: the bow is in the last slow drawn breath of a final phrase, continuously gliding rightward along the string in a prolonged unbroken pull, already beginning an imperceptible upward lift at its trailing edge — the bow is forever-ending, forever-lifting, the very beginning of its separation from the string held in suspension; the string vibrates in a continuous soft blur behind the bow's draw, resin dust rising continuously in small golden specks through the light beam, the last note held in the air in its sustained completing form. The shot is the moment just before silence, prolonged. Ambient simultaneous motion only: the continuous slow rightward glide of the bow, the continuous vibration of the string, the continuous rise and drift of resin dust motes through the warm beam, and the slow continuous darkening of the frame edges into a sustained vignette, as if the film itself is exhaling. Background: warm out-of-focus golden window light and indistinct silver-haired silhouettes in soft bokeh, held still, the edges continuously deepening into gentle shadow. Time: 4:50 PM. Lighting: warm 2800K directional sunlight from upper-camera-right, softly dimmer than Shot 04c — a continuous sense that the moment is ending; dust motes drift continuously through the beam; the edges of frame fade steadily into soft shadow. Camera: absolute static, no push, no float, held for all eight seconds. Palette: honey amber, deep ebony black, ivory white, warm gold bokeh, deepening edge shadow. Mood: sacred, spent, complete, the silence after a song held in its very last moment. semi-realistic cinematic style, warm golden hour lighting, shallow depth of field, soft window light, naturalistic color grade, gentle camera motion, film grain, macro photography texture, Chloé Zhao aesthetic.

**Negative prompt:** AVOID snapped string, overexposed bow hair, fast motion, hard cut at end, bright flash, cartoon, anime, multiple violins.

**Acceptance:**
- Bow lift visible and clean
- Stillness at end holds
- Vignette/darkening edges sell "ending"
- ~5s
