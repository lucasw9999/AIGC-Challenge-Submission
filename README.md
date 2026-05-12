# Submission — One Song, Three Homes

**Film:** `deliverable/one-song-three-homes-v9.mp4` (2:27, 1080p)
**Student:** Lucas · Grade 9 · Division C
**Competition:** 2026 CIE/USA-DFW Student AIGC Competition
**Theme:** *Small Acts, Big Impact*

This folder contains everything a judge or reviewer may want to see alongside the submitted film.

## Where to start

1. **Watch the film** — `deliverable/one-song-three-homes-v9.mp4`
2. **Read the paper** — `docs/project-documentation.md` (the main write-up: story, process, tools, learnings)
3. **See the craft** — `docs/sample-prompts.md` for two example prompts, or `prompts/` for all 16

## What's in here

```
submission/
├── README.md                              ← this file
├── deliverable/
│   └── one-song-three-homes-v9.mp4        ← the finished film
├── docs/
│   ├── project-documentation.md           ← main paper — story, process, tools
│   ├── video-summary.md                   ← 150-word summary (for submission form)
│   ├── sample-prompts.md                  ← 1-2 key prompts (for submission form)
│   ├── shot-list.md                       ← all 16 shots with embedded prompts
│   └── v9-assembly-notes.md               ← notes on the final cut
├── prompts/                               ← 16 shot prompts + 16 negative prompts
│   ├── shot-01.txt … shot-16.txt
│   └── shot-01.neg.txt … shot-16.neg.txt
├── scripts/                               ← reproducible assembly pipeline
│   ├── build_film.sh                      ← rebuilds the film from source
│   ├── render_text_card.py                ← Python + Pillow text-card renderer
│   └── verify_length.sh                   ← confirms 2–3 min compliance
├── edit/
│   └── concat-list.txt                    ← ffmpeg concat manifest
├── audio/
│   └── audio-notes.md                     ← music source, license chain
└── mood-boards/
    └── mood-board-notes.md                ← per-scene style descriptors
```

## Tools referenced

- Claude Opus 4.7 (Anthropic) — orchestrating AI that wrote prompts, called the video model, and assembled the film
- Google Veo 3.1 — video-generation model
- fluidsynth + FluidR3 GM SoundFont (MIT License) — music synthesis
- Wikimedia Commons — public-domain MIDI source
- ffmpeg — video and audio assembly
- Python + Pillow — text-card rendering
- Git — version control

## Rights and licensing

- **Melody:** *Molihua* (茉莉花) — traditional Chinese folk, public domain
- **MIDI transcription:** Wikimedia Commons, public-domain dedication
- **SoundFont:** FluidR3 GM, MIT License
- **AI-generated visuals and synthesized audio:** original to this project
- **Story:** based on Lucas's real volunteer work playing violin at Sunrise at FlatIrons, Broomfield, Colorado
