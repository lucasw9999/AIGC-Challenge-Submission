#!/usr/bin/env bash
# Verify a rough-cut MP4: duration within 2:00-3:00 and streams present.
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 <mp4>" >&2
  exit 2
fi

f="$1"
if [ ! -f "$f" ]; then
  echo "FAIL: file not found: $f" >&2
  exit 1
fi

dur=$(ffprobe -v error -show_entries format=duration -of default=nw=1:nk=1 "$f")
echo "duration: ${dur}s"
awk -v d="$dur" 'BEGIN {
  if (d < 120 || d > 180) { print "FAIL: not within 2:00-3:00"; exit 1 }
  else { print "OK: within 2:00-3:00 per rules" }
}'

echo "--- streams ---"
ffprobe -v error \
  -show_entries stream=codec_type,codec_name,width,height,r_frame_rate \
  -of default "$f"
