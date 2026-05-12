# Audio Notes

## Main track

- **File:** `audio/molihua-main.wav`
- **Song:** Molihua (茉莉花, "Jasmine Flower") — traditional Chinese folk song, melody public domain (Qing dynasty origin)
- **Source (MIDI):** https://commons.wikimedia.org/wiki/File:Msgmrk.mid — a public-domain MIDI transcription by the Wikimedia Commons uploader from the Japanese music book *Gekkin Gakufu* (月琴楽譜, 1877), which preserves an older "Matsurika" (茉莉花 / Jasmine Flower) version of the Mo Li Hua melody. File is explicitly released into the public domain by the copyright holder of the transcription.
- **Local raw MIDI:** `audio/source/molihua-commons.mid` (downloaded 2026-05-10 from upload.wikimedia.org)
- **Solo-violin MIDI (derived):** `audio/source/molihua-violin.mid` — melody-only reduction of the source MIDI, produced by keeping channel 0 (the lead line, 93 notes, range A3–D5) and forcing program change to GM #40 (violin). Accompaniment channels (plucked strings, flute, bass, percussion) dropped so the rendering is solo violin. Generated with a small mido-based Python helper.
- **Synthesis:** FluidSynth 2.5.4 + **FluidR3_GM** SoundFont (MIT License, Frank Wen) sourced from musical-artifacts.com. Command: `fluidsynth -F raw.wav -ni FluidR3_GM.sf2 molihua-violin.mid`
- **Instrument:** solo violin (GM program 40, FluidR3_GM violin voice)
- **Performer:** N/A — synthesized for this project; rights to the synthesized rendering are retained by the filmmaker
- **License of recording:** synthesized output, unencumbered — melody is public domain, MIDI transcription is public domain, SoundFont is MIT-licensed. No third-party performance rights apply.
- **Raw render duration:** 58.89 s (single pass)
- **Output duration:** 160.00 s (2:40) — produced by `ffmpeg -stream_loop 2` (3 passes = 176.7 s) trimmed to 160 s
- **Output format:** 48 kHz, stereo, 24-bit PCM WAV
- **Cleanup chain:** `highpass=f=80, dynaudnorm=f=150:g=15, loudnorm=I=-18:TP=-3:LRA=11`
- **Measured levels:** mean -21.3 dBFS, peak -8.3 dBFS

## Melody verification

The source MIDI's channel-0 lead line opens on F#4 F#4 A4 B4 D5 (then B4 A4 B4 A4 F#4 …). Canonical Molihua in C opens E E G A C, with intervals 0 / +3 semitones / +2 / +3. The MIDI's opening intervals are F# F# / A (+3) / B (+2) / D (+3) — **exact same interval pattern, transposed up a major third to D major**. The repeating antecedent/consequent phrase structure (bars 1–4 repeated as bars 5–8 in the opening) also matches the standard Molihua verse structure. Melody identity confirmed.

## Coverage vs. film

The film needs ~2:20 of continuous solo audio from Shot 04 (0:25) through Shot 12 (~2:45). This track supplies **2:40 of continuous audio**, which covers the whole window with a ~20 s tail for fade-out. No additional looping required at the edit stage.

## Loop plan

Already built-in: the ffmpeg render concatenates three passes of the 58.89 s MIDI render back-to-back. The loop seam is phrase-aligned (the MIDI ends at a musical phrase boundary) so no audible discontinuity is expected, but if a click appears at the edit stage, apply a 0.5 s `acrossfade` between the loop boundaries.

If Lucas's solo-violin phone recording arrives later, swap `audio/molihua-main.wav` with the cleaned Lucas track and update the closing card to credit him instead.

## Closing-card credit line

> Music: *Molihua* (茉莉花), traditional Chinese folk song, melody public domain (Qing dynasty).
> Solo-violin rendering synthesized by the filmmaker from a public-domain MIDI transcription
> (Wikimedia Commons, file: Msgmrk.mid) using FluidSynth and the FluidR3_GM SoundFont (MIT License, Frank Wen).

## Provenance checklist

- [x] Song verified as Molihua (source metadata + melodic interval analysis)
- [x] Instrument is solo violin (GM program 40, forced on every note)
- [x] License is unambiguous (PD melody, PD MIDI, MIT SoundFont, synthesis by filmmaker)
- [x] Output is 48 kHz / 24-bit / stereo PCM WAV
- [x] Output duration ≥ 2:20 (actual 2:40)
- [x] Levels normalized to broadcast-friendly -18 LUFS / -3 dBFS target (measured -21 mean / -8 peak)
