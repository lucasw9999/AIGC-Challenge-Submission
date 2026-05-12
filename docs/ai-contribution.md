# AI Contribution

(Submission field — estimated percentage and breakdown)

---

## The honest two-axis answer

This film is best described as **100% human creative authorship + 100% AI technical generation** — two different things, not two slices of one pie.

### Creative authorship — 100% human (me, Lucas)

Every choice in the film is mine:

- **The real-life anchor** — playing violin for the seniors at Sunrise at FlatIrons is my actual community service experience
- **The three kindness memories** — based on my real life lived across Australia, China, and Colorado
- **The song** — I chose *Molihua* because it's recognizable to many of the people I play for
- **The story structure** — "one song, three homes," with the violin as the spine of the film
- **The visual tone** — I chose photorealistic cinematic over painted/stylized options
- **Every casting decision** — the preschool teacher, the stranger in the market, the Black ski coach, the elder audience member
- **The emotional direction of every scene** — e.g., the final beat is a warm smile and a nod, not a tear
- **The refinement through 9 numbered cuts** — I watched every version, named specific things that weren't right, and kept iterating until it felt true
- **Every go/no-go decision** — the film exists because I said yes, it looks the way it does because I said what to change

### Technical generation — 100% AI

| Component | Tool |
|---|---|
| Visuals (16 cinematic shots at 1080p) | Google Veo 3.1 |
| Dialogue voices (lip-synced English + Mandarin) | Google Veo 3.1 |
| Ambient sound (market, playground, snow, room) | Google Veo 3.1 |
| Music (solo-violin *Molihua*) | fluidsynth + FluidR3 GM SoundFont, synthesized from public-domain MIDI |
| Prompt writing (~4,000 words across 16 shots) | Claude Opus 4.7 |
| Assembly pipeline (ffmpeg concat, audio mix, text cards) | Claude Opus 4.7 (orchestrating ffmpeg + Python) |

---

## If the form wants a single percentage

- **~95% AI technical share** (pixels, audio waveforms, prompt text, build pipeline)
- **100% human creative share** (story, meaning, every decision, every refinement)

## One-line answer for a form field

> **Creative: 100% human (story, casting, all choices, every refinement). Technical: 100% AI (visuals, voices, ambient audio, music synthesis, prompt writing, editing).**

## Why this matters

The pixels are AI-generated. The *film* — the story, the characters, the emotional arc, the choice of which moments mattered and which didn't — is mine. AI let me work at a scale I couldn't reach alone, so I could spend my time doing the one thing AI can't do: decide what this story is trying to say, and whether each cut is saying it.
