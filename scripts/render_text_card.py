#!/usr/bin/env python3
"""Render a multi-line text card as a 1920x1080 MP4 video with fade in/out.

Usage example:
    python scripts/render_text_card.py \
        --text "One Song,\\nThree Homes" \
        --fontsize 96 \
        --duration 5 \
        --out edit/intermediates/title.mp4 \
        --align center
"""
from __future__ import annotations

import argparse
import subprocess
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

# Candidate serif font locations across common operating systems. The first
# existing path is used. On Linux this will typically resolve to DejaVu Serif
# or Liberation Serif (both open-source). Override with --font-path to use a
# specific font of your choice.
FONT_CANDIDATES = [
    # Open-source serif fonts shipped with most Linux distributions
    "/usr/share/fonts/truetype/dejavu/DejaVuSerif.ttf",
    "/usr/share/fonts/truetype/liberation/LiberationSerif-Regular.ttf",
    "/usr/share/fonts/dejavu/DejaVuSerif.ttf",
    "/usr/share/fonts/liberation/LiberationSerif-Regular.ttf",
    # Fallback: system-provided serif fonts (Georgia, Times)
    "/Library/Fonts/Georgia.ttf",
    "/System/Library/Fonts/Supplemental/Georgia.ttf",
    "C:/Windows/Fonts/georgia.ttf",
    "C:/Windows/Fonts/times.ttf",
]


def resolve_font_path(override: str | None) -> str:
    if override:
        return override
    for candidate in FONT_CANDIDATES:
        if Path(candidate).is_file():
            return candidate
    raise RuntimeError(
        "No serif font found. Pass --font-path with the path to a .ttf file "
        "(e.g., DejaVu Serif, Liberation Serif, Georgia, or Times)."
    )


CREAM = (245, 241, 232)
BLACK = (0, 0, 0)
WIDTH, HEIGHT = 1920, 1080


def main() -> None:
    p = argparse.ArgumentParser()
    p.add_argument("--text", required=True, help="multi-line text, use \\n for newlines")
    p.add_argument("--fontsize", type=int, default=40)
    p.add_argument("--duration", type=float, required=True)
    p.add_argument("--out", required=True, type=Path)
    p.add_argument("--align", default="center", choices=["left", "center"])
    p.add_argument("--fadein", type=float, default=0.8)
    p.add_argument("--fadeout", type=float, default=0.8)
    p.add_argument("--left-margin", type=int, default=288, help="pixels from left edge when align=left")
    p.add_argument("--font-path", default=None, help="override path to a .ttf serif font")
    args = p.parse_args()

    font_path = resolve_font_path(args.font_path)
    font = ImageFont.truetype(font_path, args.fontsize)
    img = Image.new("RGB", (WIDTH, HEIGHT), color=BLACK)
    draw = ImageDraw.Draw(img)

    text = args.text.replace("\\n", "\n")
    lines = text.split("\n")

    # Use a consistent line height based on the font's ascent+descent so
    # blank lines still occupy vertical space.
    ascent, descent = font.getmetrics()
    line_h = ascent + descent
    gap = int(args.fontsize * 0.4)

    total_height = len(lines) * line_h + (len(lines) - 1) * gap
    start_y = (HEIGHT - total_height) // 2

    y = start_y
    for line in lines:
        if line.strip() == "":
            y += line_h + gap
            continue
        bbox = font.getbbox(line)
        text_w = bbox[2] - bbox[0]
        if args.align == "center":
            x = (WIDTH - text_w) // 2
        else:
            x = args.left_margin
        draw.text((x, y), line, font=font, fill=CREAM)
        y += line_h + gap

    args.out.parent.mkdir(parents=True, exist_ok=True)
    png_path = args.out.with_suffix(".png")
    img.save(png_path)

    duration = args.duration
    fadein = args.fadein
    fadeout = args.fadeout
    vf = (
        f"fade=in:st=0:d={fadein},"
        f"fade=out:st={duration - fadeout}:d={fadeout},"
        f"fps=24,format=yuv420p"
    )
    cmd = [
        "ffmpeg",
        "-y",
        "-loop",
        "1",
        "-i",
        str(png_path),
        "-t",
        str(duration),
        "-vf",
        vf,
        "-c:v",
        "libx264",
        "-preset",
        "medium",
        "-crf",
        "18",
        "-pix_fmt",
        "yuv420p",
        str(args.out),
    ]
    subprocess.run(cmd, check=True)
    png_path.unlink(missing_ok=True)


if __name__ == "__main__":
    main()
