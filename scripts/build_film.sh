#!/usr/bin/env bash
# Build rough cut v1 of "One Song, Three Homes".
#
# Inputs:
#   generated/shot-*/take01.mp4           (per-shot renders)
#   generated/smoke-test/veo-3-1-shot-03-sample.mp4  (Shot 03 reuse)
#   audio/molihua-main.wav                (master audio, 160s)
#
# Output:
#   deliverable/one-song-three-homes-v1.mp4

set -euo pipefail
cd "$(dirname "$0")/.."

mkdir -p edit/intermediates deliverable

# -----------------------------------------------------------------------------
# Shot sources (in film order). Shot 03 is the smoke-test sample.
# -----------------------------------------------------------------------------
declare -a IDS=(
  "shot-01" "shot-02" "shot-03"
  "shot-04a" "shot-04b" "shot-04c"
  "shot-05a" "shot-05b" "shot-06" "shot-07"
  "shot-08a" "shot-08b" "shot-09" "shot-10"
  "shot-11a" "shot-11b" "shot-12"
)
declare -a SOURCES=(
  "generated/shot-01-bay-area-opening/take01.mp4"
  "generated/shot-02-transit/take01.mp4"
  "generated/smoke-test/veo-3-1-shot-03-sample.mp4"
  "generated/shot-04a-enters-and-sits/take01.mp4"
  "generated/shot-04b-raises-bow/take01.mp4"
  "generated/shot-04c-first-note/take01.mp4"
  "generated/shot-05a-australia-boardwalk/take01.mp4"
  "generated/shot-05b-australia-kneel/take01.mp4"
  "generated/shot-06-mango-exchange/take01.mp4"
  "generated/shot-07-jasmine-petal-transition/take01.mp4"
  "generated/shot-08a-grandmother-soup/take01.mp4"
  "generated/shot-08b-steam/take01.mp4"
  "generated/shot-09-china-bowl-exchange/take01.mp4"
  "generated/shot-10-ink-to-violin-transition/take01.mp4"
  "generated/shot-11a-elder-tear-forms/take01.mp4"
  "generated/shot-11b-tear-falls-smile/take01.mp4"
  "generated/shot-12-final-phrase/take01.mp4"
)

# -----------------------------------------------------------------------------
# Step 1: Normalize each shot to 1920x1080, 24fps, yuv420p, video-only.
# -----------------------------------------------------------------------------
echo "[1/6] Normalizing shots..."
for i in "${!IDS[@]}"; do
  id="${IDS[$i]}"
  src="${SOURCES[$i]}"
  out="edit/intermediates/${id}.mp4"
  if [ ! -f "$src" ]; then
    echo "  MISSING source: $src" >&2
    exit 1
  fi
  ffmpeg -y -hide_banner -loglevel error -i "$src" \
    -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2,fps=24,format=yuv420p" \
    -c:v libx264 -preset medium -crf 18 \
    -an \
    "$out"
  echo "  $id <- $src"
done

# -----------------------------------------------------------------------------
# Step 2: Title card, interstitial, closing card (via Python helper).
# -----------------------------------------------------------------------------
echo "[2/6] Rendering text cards..."
python3 scripts/render_text_card.py \
  --text "One Song,\nThree Homes" \
  --fontsize 96 \
  --duration 5 \
  --fadein 1.0 --fadeout 1.0 \
  --out edit/intermediates/title.mp4 \
  --align center

python3 scripts/render_text_card.py \
  --text "Kindness learns to travel." \
  --fontsize 60 \
  --duration 4 \
  --fadein 0.5 --fadeout 0.5 \
  --out edit/intermediates/interstitial.mp4 \
  --align center

python3 scripts/render_text_card.py \
  --text "Based on Lucas's real volunteer work playing violin\nat Sunrise at FlatIrons, Broomfield, Colorado.\n\nSmall acts, big impact.\n\nA film by Lucas.\nGenerated with Google Veo3.\nMusic: Molihua" \
  --fontsize 40 \
  --duration 12 \
  --fadein 1.0 --fadeout 1.0 \
  --out edit/intermediates/closing-card.mp4 \
  --align left

# -----------------------------------------------------------------------------
# Step 3: Concat all video-only segments.
# -----------------------------------------------------------------------------
echo "[3/6] Concatenating video..."
(
  cd edit
  ffmpeg -y -hide_banner -loglevel error \
    -f concat -safe 0 -i concat-list.txt \
    -c copy intermediates/video-only.mp4
)

video_dur=$(ffprobe -v error -show_entries format=duration -of default=nw=1:nk=1 edit/intermediates/video-only.mp4)
echo "  video-only duration: ${video_dur}s"

# -----------------------------------------------------------------------------
# Step 4: Build audio timeline.
#   - 5s silence (title card)
#   - Molihua slice covering shots 01..12 (fades in/out)
#   - closing-card seconds of silence
# -----------------------------------------------------------------------------
echo "[4/6] Building audio timeline..."

TITLE_DUR=5
CLOSING_DUR=14
# Molihua spans everything between title and closing-card.
molihua_dur=$(python3 -c "print(round(${video_dur} - ${TITLE_DUR} - ${CLOSING_DUR}, 3))")
echo "  molihua slice: ${molihua_dur}s"

fade_out_start=$(python3 -c "print(round(${molihua_dur} - 2, 3))")

ffmpeg -y -hide_banner -loglevel error -i audio/molihua-main.wav \
  -t "${molihua_dur}" \
  -af "afade=t=in:st=0:d=2,afade=t=out:st=${fade_out_start}:d=2" \
  -c:a pcm_s24le -ar 48000 -ac 2 \
  edit/intermediates/molihua-slice.wav

ffmpeg -y -hide_banner -loglevel error \
  -f lavfi -i "anullsrc=r=48000:cl=stereo:d=${TITLE_DUR}" \
  -i edit/intermediates/molihua-slice.wav \
  -f lavfi -i "anullsrc=r=48000:cl=stereo:d=${CLOSING_DUR}" \
  -filter_complex "[0:a][1:a][2:a]concat=n=3:v=0:a=1[a]" \
  -map "[a]" \
  -c:a pcm_s24le -ar 48000 -ac 2 \
  edit/intermediates/audio-master.wav

audio_dur=$(ffprobe -v error -show_entries format=duration -of default=nw=1:nk=1 edit/intermediates/audio-master.wav)
echo "  audio-master duration: ${audio_dur}s"

# -----------------------------------------------------------------------------
# Step 5: Mux.
# -----------------------------------------------------------------------------
echo "[5/6] Muxing final MP4..."
ffmpeg -y -hide_banner -loglevel error \
  -i edit/intermediates/video-only.mp4 \
  -i edit/intermediates/audio-master.wav \
  -c:v copy \
  -c:a aac -b:a 192k \
  -shortest \
  deliverable/one-song-three-homes-v1.mp4

# -----------------------------------------------------------------------------
# Step 6: Report.
# -----------------------------------------------------------------------------
echo "[6/6] Verifying..."
ffprobe -v error \
  -show_entries stream=codec_type,codec_name,width,height,r_frame_rate,duration \
  -show_entries format=duration,bit_rate \
  deliverable/one-song-three-homes-v1.mp4

echo
echo "Built: deliverable/one-song-three-homes-v1.mp4"
