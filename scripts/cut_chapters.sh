#!/usr/bin/env bash
# cut_chapters.sh — The Optimal Cut v7
# Generated from edit_spec_timestamps.json (156 clips)
# AUTO: 119, REVIEW: 5, SEMI-AUTO: 10, MANUAL: 5

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(dirname "$SCRIPT_DIR")"
MP4_DIR="$ROOT/raw_content/mp4"
CLIPS_DIR="$ROOT/clips"
OUTPUT_DIR="$ROOT/output"

# ── Dependency check ──
if ! command -v ffmpeg &>/dev/null; then
  echo "ERROR: ffmpeg not found. Install it first." >&2
  exit 1
fi

# ── Check source MP4s ──
MISSING=0
if [[ ! -f "$MP4_DIR/episode_1_the_phantom_menace.mp4" ]]; then
  echo "MISSING: episode_1_the_phantom_menace.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/episode_2_attack_of_the_clones.mp4" ]]; then
  echo "MISSING: episode_2_attack_of_the_clones.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/episode_3_revenge_of_the_sith.mp4" ]]; then
  echo "MISSING: episode_3_revenge_of_the_sith.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/tales_of_the_jedi_s01e02.mp4" ]]; then
  echo "MISSING: tales_of_the_jedi_s01e02.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/tales_of_the_jedi_s01e03.mp4" ]]; then
  echo "MISSING: tales_of_the_jedi_s01e03.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/tales_of_the_jedi_s01e04.mp4" ]]; then
  echo "MISSING: tales_of_the_jedi_s01e04.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/tales_of_the_jedi_s01e05.mp4" ]]; then
  echo "MISSING: tales_of_the_jedi_s01e05.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/the_clone_wars_s01e02.mp4" ]]; then
  echo "MISSING: the_clone_wars_s01e02.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/the_clone_wars_s01e05.mp4" ]]; then
  echo "MISSING: the_clone_wars_s01e05.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/the_clone_wars_s01e19.mp4" ]]; then
  echo "MISSING: the_clone_wars_s01e19.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/the_clone_wars_s01e22.mp4" ]]; then
  echo "MISSING: the_clone_wars_s01e22.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/the_clone_wars_s02e04.mp4" ]]; then
  echo "MISSING: the_clone_wars_s02e04.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/the_clone_wars_s02e05.mp4" ]]; then
  echo "MISSING: the_clone_wars_s02e05.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/the_clone_wars_s02e06.mp4" ]]; then
  echo "MISSING: the_clone_wars_s02e06.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/the_clone_wars_s02e13.mp4" ]]; then
  echo "MISSING: the_clone_wars_s02e13.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/the_clone_wars_s03e11.mp4" ]]; then
  echo "MISSING: the_clone_wars_s03e11.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/the_clone_wars_s03e18.mp4" ]]; then
  echo "MISSING: the_clone_wars_s03e18.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/the_clone_wars_s03e19.mp4" ]]; then
  echo "MISSING: the_clone_wars_s03e19.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/the_clone_wars_s03e21.mp4" ]]; then
  echo "MISSING: the_clone_wars_s03e21.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/the_clone_wars_s03e22.mp4" ]]; then
  echo "MISSING: the_clone_wars_s03e22.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/the_clone_wars_s04e04.mp4" ]]; then
  echo "MISSING: the_clone_wars_s04e04.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/the_clone_wars_s04e07.mp4" ]]; then
  echo "MISSING: the_clone_wars_s04e07.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/the_clone_wars_s04e08.mp4" ]]; then
  echo "MISSING: the_clone_wars_s04e08.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/the_clone_wars_s04e09.mp4" ]]; then
  echo "MISSING: the_clone_wars_s04e09.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/the_clone_wars_s04e10.mp4" ]]; then
  echo "MISSING: the_clone_wars_s04e10.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/the_clone_wars_s04e16.mp4" ]]; then
  echo "MISSING: the_clone_wars_s04e16.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/the_clone_wars_s04e21.mp4" ]]; then
  echo "MISSING: the_clone_wars_s04e21.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/the_clone_wars_s04e22.mp4" ]]; then
  echo "MISSING: the_clone_wars_s04e22.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/the_clone_wars_s05e14.mp4" ]]; then
  echo "MISSING: the_clone_wars_s05e14.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/the_clone_wars_s05e15.mp4" ]]; then
  echo "MISSING: the_clone_wars_s05e15.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/the_clone_wars_s05e16.mp4" ]]; then
  echo "MISSING: the_clone_wars_s05e16.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/the_clone_wars_s05e17.mp4" ]]; then
  echo "MISSING: the_clone_wars_s05e17.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/the_clone_wars_s05e18.mp4" ]]; then
  echo "MISSING: the_clone_wars_s05e18.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/the_clone_wars_s05e19.mp4" ]]; then
  echo "MISSING: the_clone_wars_s05e19.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/the_clone_wars_s05e20.mp4" ]]; then
  echo "MISSING: the_clone_wars_s05e20.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/the_clone_wars_s06e01.mp4" ]]; then
  echo "MISSING: the_clone_wars_s06e01.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/the_clone_wars_s06e02.mp4" ]]; then
  echo "MISSING: the_clone_wars_s06e02.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/the_clone_wars_s06e03.mp4" ]]; then
  echo "MISSING: the_clone_wars_s06e03.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/the_clone_wars_s06e04.mp4" ]]; then
  echo "MISSING: the_clone_wars_s06e04.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/the_clone_wars_s06e06.mp4" ]]; then
  echo "MISSING: the_clone_wars_s06e06.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/the_clone_wars_s06e07.mp4" ]]; then
  echo "MISSING: the_clone_wars_s06e07.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/the_clone_wars_s06e10.mp4" ]]; then
  echo "MISSING: the_clone_wars_s06e10.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/the_clone_wars_s07e02.mp4" ]]; then
  echo "MISSING: the_clone_wars_s07e02.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/the_clone_wars_s07e09.mp4" ]]; then
  echo "MISSING: the_clone_wars_s07e09.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/the_clone_wars_s07e10.mp4" ]]; then
  echo "MISSING: the_clone_wars_s07e10.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/the_clone_wars_s07e11.mp4" ]]; then
  echo "MISSING: the_clone_wars_s07e11.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ ! -f "$MP4_DIR/the_clone_wars_s07e12.mp4" ]]; then
  echo "MISSING: the_clone_wars_s07e12.mp4" >&2
  MISSING=$((MISSING + 1))
fi
if [[ "$MISSING" -gt 0 ]]; then
  echo "ERROR: $MISSING source MP4(s) missing from $MP4_DIR" >&2
  exit 1
fi
echo "All source MP4s found."

# ── Create directories ──
mkdir -p "$CLIPS_DIR/ch1_djem_so"
mkdir -p "$CLIPS_DIR/ch2_expendable"
mkdir -p "$CLIPS_DIR/ch3_attachment"
mkdir -p "$CLIPS_DIR/ch4_conscience"
mkdir -p "$CLIPS_DIR/ch5_soresu"
mkdir -p "$CLIPS_DIR/ch6_fives"
mkdir -p "$CLIPS_DIR/interlude_good_luck"
mkdir -p "$CLIPS_DIR/ch7_victory_and_death"
mkdir -p "$OUTPUT_DIR"

# ════════════════════════════════════════════════════════════
# CH1_DJEM_SO
# ════════════════════════════════════════════════════════════

# CLIP 1.0: Title Card + VO
# TODO: Create title card / closing card manually
# Output: $CLIPS_DIR/ch1_djem_so/1_0.mp4

# CLIP 1.1: Briefing + Kill Count Banter [AUTO]
ffmpeg -ss 00:00:54.805 -to 00:02:34.569 -i "$MP4_DIR/the_clone_wars_s02e05.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch1_djem_so/1_1.mp4"
echo "[1/134] 1.1: Briefing + Kill Count Banter"

# CLIP 1.2: The Assault Begins [AUTO]
ffmpeg -ss 00:05:23.782 -to 00:07:16.851 -i "$MP4_DIR/the_clone_wars_s02e05.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch1_djem_so/1_2.mp4"
echo "[2/134] 1.2: The Assault Begins"

# CLIP 1.3: Scaling the Wall [AUTO]
ffmpeg -ss 00:13:02.532 -to 00:15:41.647 -i "$MP4_DIR/the_clone_wars_s02e05.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch1_djem_so/1_3.mp4"
echo "[3/134] 1.3: Scaling the Wall"

# CLIP 1.4: Briefing Bickering [AUTO]
ffmpeg -ss 00:01:58.577 -to 00:07:05.506 -i "$MP4_DIR/the_clone_wars_s02e06.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch1_djem_so/1_4.mp4"
echo "[4/134] 1.4: Briefing Bickering"

# CLIP 1.5: Into the Catacombs [AUTO]
ffmpeg -ss 00:08:03.191 -to 00:10:11.525 -i "$MP4_DIR/the_clone_wars_s02e06.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch1_djem_so/1_5.mp4"
echo "[5/134] 1.5: Into the Catacombs"

# CLIP 1.6: Trapped + The Contrast [AUTO]
ffmpeg -ss 00:16:23.065 -to 00:20:01.656 -i "$MP4_DIR/the_clone_wars_s02e06.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch1_djem_so/1_6.mp4"
echo "[6/134] 1.6: Trapped + The Contrast"

# CLIP 1.7: The Rescue [AUTO]
ffmpeg -ss 00:20:17.550 -to 00:21:49.723 -i "$MP4_DIR/the_clone_wars_s02e06.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch1_djem_so/1_7.mp4"
echo "[7/134] 1.7: The Rescue"

# CLIP 1.8: The Council Says No [AUTO]
ffmpeg -ss 00:04:08.331 -to 00:05:26.699 -i "$MP4_DIR/the_clone_wars_s01e02.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch1_djem_so/1_8.mp4"
echo "[8/134] 1.8: The Council Says No"

# CLIP 1.9: Lives Are in Danger [AUTO]
ffmpeg -ss 00:05:28.119 -to 00:08:42.770 -i "$MP4_DIR/the_clone_wars_s01e02.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch1_djem_so/1_9.mp4"
echo "[9/134] 1.9: Lives Are in Danger"

# CLIP 1.10: Not to Me [AUTO]
ffmpeg -ss 00:17:09.487 -to 00:18:14.674 -i "$MP4_DIR/the_clone_wars_s01e02.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch1_djem_so/1_10.mp4"
echo "[10/134] 1.10: Not to Me"

# CLIP 1.11: Escape + Coda [AUTO]
ffmpeg -ss 00:18:43.956 -to 00:23:18.728 -i "$MP4_DIR/the_clone_wars_s01e02.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch1_djem_so/1_11.mp4"
echo "[11/134] 1.11: Escape + Coda"

# CLIP 1.12: Ahsoka Taken [AUTO]
ffmpeg -ss 00:04:16.507 -to 00:05:40.003 -i "$MP4_DIR/the_clone_wars_s03e21.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch1_djem_so/1_12.mp4"
echo "[12/134] 1.12: Ahsoka Taken"

# CLIP 1.13: My Master Will Never Forgive Me [AUTO]
ffmpeg -ss 00:12:53.356 -to 00:15:20.449 -i "$MP4_DIR/the_clone_wars_s03e21.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch1_djem_so/1_13.mp4"
echo "[13/134] 1.13: My Master Will Never Forgive Me"

# CLIP 1.14: Kalifa's Death [AUTO]
ffmpeg -ss 00:16:53.888 -to 00:20:31.852 -i "$MP4_DIR/the_clone_wars_s03e21.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch1_djem_so/1_14.mp4"
echo "[14/134] 1.14: Kalifa's Death"

# CLIP 1.15: Anakin's Desperation [AUTO]
ffmpeg -ss 00:08:54.952 -to 00:20:29.424 -i "$MP4_DIR/the_clone_wars_s03e21.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch1_djem_so/1_15.mp4"
echo "[15/134] 1.15: Anakin's Desperation"

# CLIP 1.16: We Go Down With a Fight [AUTO]
ffmpeg -ss 00:03:03.058 -to 00:03:44.462 -i "$MP4_DIR/the_clone_wars_s03e22.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch1_djem_so/1_16.mp4"
echo "[16/134] 1.16: We Go Down With a Fight"

# CLIP 1.17: The Final Battle [SEMI-AUTO]
# START is visual — needs manual timestamp (estimated from END minus 2:00)
ffmpeg -ss 00:18:08.704 -to 00:20:09.704 -i "$MP4_DIR/the_clone_wars_s03e22.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch1_djem_so/1_17.mp4"
echo "[17/134] 1.17: The Final Battle"

# CLIP 1.18: The Reunion [AUTO]
ffmpeg -ss 00:20:45.453 -to 00:21:39.916 -i "$MP4_DIR/the_clone_wars_s03e22.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch1_djem_so/1_18.mp4"
echo "[18/134] 1.18: The Reunion"

# CLIP 1.19: You Either Do or Die [AUTO]
ffmpeg -ss 00:02:20.933 -to 00:04:37.689 -i "$MP4_DIR/the_clone_wars_s03e18.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch1_djem_so/1_19.mp4"
echo "[19/134] 1.19: You Either Do or Die"

# CLIP 1.20: Following Direct Orders [AUTO]
ffmpeg -ss 00:08:45.734 -to 00:09:32.189 -i "$MP4_DIR/the_clone_wars_s03e18.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch1_djem_so/1_20.mp4"
echo "[20/134] 1.20: Following Direct Orders"

# CLIP 1.21: Ahsoka Proves Her Point [AUTO]
ffmpeg -ss 00:11:59.344 -to 00:12:37.962 -i "$MP4_DIR/the_clone_wars_s03e18.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch1_djem_so/1_21.mp4"
echo "[21/134] 1.21: Ahsoka Proves Her Point"

# CLIP 1.22: Tarkin's Poison [AUTO]
ffmpeg -ss 00:04:35.192 -to 00:14:22.103 -i "$MP4_DIR/the_clone_wars_s03e19.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch1_djem_so/1_22.mp4"
echo "[22/134] 1.22: Tarkin's Poison"

# CLIP 1.23: Trust and Gratitude [AUTO]
ffmpeg -ss 00:21:05.723 -to 00:21:30.244 -i "$MP4_DIR/the_clone_wars_s03e18.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch1_djem_so/1_23.mp4"
echo "[23/134] 1.23: Trust and Gratitude"

# CLIP 1.24: Jedi Who Disappoint Us [AUTO]
ffmpeg -ss 00:21:18.782 -to 00:21:37.966 -i "$MP4_DIR/the_clone_wars_s05e17.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch1_djem_so/1_24.mp4"
echo "[24/134] 1.24: Jedi Who Disappoint Us"

# CLIP 1.25: Warmth: Dinner and Home [AUTO]
ffmpeg -ss 00:02:23.644 -to 00:04:58.255 -i "$MP4_DIR/the_clone_wars_s07e02.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch1_djem_so/1_25.mp4"
echo "[25/134] 1.25: Warmth: Dinner and Home"

# CLIP 1.26: Friction: The Argument [AUTO]
ffmpeg -ss 00:04:47.871 -to 00:06:50.783 -i "$MP4_DIR/the_clone_wars_s02e04.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch1_djem_so/1_26.mp4"
echo "[26/134] 1.26: Friction: The Argument"

# CLIP 1.27: Devotion: Lightsaber Gift [AUTO]
ffmpeg -ss 00:02:26.730 -to 00:03:49.810 -i "$MP4_DIR/the_clone_wars_s01e22.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch1_djem_so/1_27.mp4"
echo "[27/134] 1.27: Devotion: Lightsaber Gift"

# CLIP 1.28: Possession: I Demand [AUTO]
ffmpeg -ss 00:05:16.488 -to 00:06:13.961 -i "$MP4_DIR/the_clone_wars_s06e06.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch1_djem_so/1_28.mp4"
echo "[28/134] 1.28: Possession: I Demand"

# CLIP 1.29: Palpatine's Validation [AUTO]
ffmpeg -ss 00:10:31.260 -to 00:11:26.731 -i "$MP4_DIR/the_clone_wars_s04e16.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch1_djem_so/1_29.mp4"
echo "[29/134] 1.29: Palpatine's Validation"

# CLIP 1.30: Closing Card
# TODO: Create title card / closing card manually
# Output: $CLIPS_DIR/ch1_djem_so/1_30.mp4

# ── Concatenate ch1_djem_so ──
CONCAT_FILE="$CLIPS_DIR/ch1_djem_so/concat.txt"
> "$CONCAT_FILE"
# TODO: uncomment when 1_0.mp4 is created
# echo "file '$CLIPS_DIR/ch1_djem_so/1_0.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch1_djem_so/1_1.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch1_djem_so/1_2.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch1_djem_so/1_3.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch1_djem_so/1_4.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch1_djem_so/1_5.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch1_djem_so/1_6.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch1_djem_so/1_7.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch1_djem_so/1_8.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch1_djem_so/1_9.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch1_djem_so/1_10.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch1_djem_so/1_11.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch1_djem_so/1_12.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch1_djem_so/1_13.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch1_djem_so/1_14.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch1_djem_so/1_15.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch1_djem_so/1_16.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch1_djem_so/1_17.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch1_djem_so/1_18.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch1_djem_so/1_19.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch1_djem_so/1_20.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch1_djem_so/1_21.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch1_djem_so/1_22.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch1_djem_so/1_23.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch1_djem_so/1_24.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch1_djem_so/1_25.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch1_djem_so/1_26.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch1_djem_so/1_27.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch1_djem_so/1_28.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch1_djem_so/1_29.mp4'" >> "$CONCAT_FILE"
# TODO: uncomment when 1_30.mp4 is created
# echo "file '$CLIPS_DIR/ch1_djem_so/1_30.mp4'" >> "$CONCAT_FILE"
ffmpeg -f concat -safe 0 -i "$CONCAT_FILE" \
  -c copy -y "$OUTPUT_DIR/ch1_djem_so.mp4"
echo ">>> ch1_djem_so.mp4 complete"

# ════════════════════════════════════════════════════════════
# CH2_EXPENDABLE
# ════════════════════════════════════════════════════════════

# CLIP 2.0: Not to Me Cold Open [AUTO]
ffmpeg -ss 00:17:14.283 -to 00:17:21.121 -i "$MP4_DIR/the_clone_wars_s01e02.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch2_expendable/2_0.mp4"
echo "[30/134] 2.0: Not to Me Cold Open"

# CLIP 2.1: The Shinies [SEMI-AUTO]
# START is visual — needs manual timestamp (estimated from END minus 1:30)
ffmpeg -ss 00:00:21.735 -to 00:01:52.735 -i "$MP4_DIR/the_clone_wars_s01e05.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch2_expendable/2_1.mp4"
echo "[31/134] 2.1: The Shinies"

# CLIP 2.2: The Post Falls [MANUAL]
# TODO: Fill in timestamps manually
#   Notes: Both cues are visual — needs manual timestamps
# ffmpeg -ss TODO -to TODO -i "$MP4_DIR/the_clone_wars_s01e05.mp4" \
#   -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
#   -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
#   -y "$CLIPS_DIR/ch2_expendable/2_2.mp4"

# CLIP 2.3: Rex Arrives [SEMI-AUTO]
# START is visual — needs manual timestamp (estimated from END minus 2:30)
ffmpeg -ss 00:08:54.140 -to 00:11:25.140 -i "$MP4_DIR/the_clone_wars_s01e05.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch2_expendable/2_3.mp4"
echo "[32/134] 2.3: Rex Arrives"

# CLIP 2.4: Hevy's Sacrifice [SEMI-AUTO]
# END is visual — needs manual timestamp (estimated from START plus 3:00)
ffmpeg -ss 00:16:09.677 -to 00:19:10.177 -i "$MP4_DIR/the_clone_wars_s01e05.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch2_expendable/2_4.mp4"
echo "[33/134] 2.4: Hevy's Sacrifice"

# CLIP 2.5: The Handprint [MANUAL]
# TODO: Fill in timestamps manually
#   Notes: Both cues are visual — needs manual timestamps
# ffmpeg -ss TODO -to TODO -i "$MP4_DIR/the_clone_wars_s01e05.mp4" \
#   -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
#   -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
#   -y "$CLIPS_DIR/ch2_expendable/2_5.mp4"

# CLIP 2.6: Krell Arrives [AUTO]
ffmpeg -ss 00:10:01.480 -to 00:11:37.241 -i "$MP4_DIR/the_clone_wars_s04e07.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch2_expendable/2_6.mp4"
echo "[34/134] 2.6: Krell Arrives"

# CLIP 2.7: Refuses Rest [AUTO]
ffmpeg -ss 00:13:07.875 -to 00:15:30.850 -i "$MP4_DIR/the_clone_wars_s04e07.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch2_expendable/2_7.mp4"
echo "[35/134] 2.7: Refuses Rest"

# CLIP 2.8: Not Clones! Men! [AUTO]
ffmpeg -ss 00:19:28.589 -to 00:21:02.264 -i "$MP4_DIR/the_clone_wars_s04e07.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch2_expendable/2_8.mp4"
echo "[36/134] 2.8: Not Clones! Men!"

# CLIP 2.9: Engineered to Think [REVIEW]
# Low confidence match (min score 0.44)
ffmpeg -ss 00:20:30.943 -to 00:21:11.899 -i "$MP4_DIR/the_clone_wars_s04e08.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch2_expendable/2_9.mp4"
echo "[37/134] 2.9: Engineered to Think"

# CLIP 2.10: Hardcase's Sacrifice [AUTO]
ffmpeg -ss 00:18:19.603 -to 00:19:33.509 -i "$MP4_DIR/the_clone_wars_s04e09.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch2_expendable/2_10.mp4"
echo "[38/134] 2.10: Hardcase's Sacrifice"

# CLIP 2.11: The Firing Squad [REVIEW]
# Low confidence match (min score 0.51)
ffmpeg -ss 00:01:30.678 -to 00:14:07.016 -i "$MP4_DIR/the_clone_wars_s04e10.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch2_expendable/2_11.mp4"
echo "[39/134] 2.11: The Firing Squad"

# CLIP 2.12: The Fratricide [REVIEW]
# Low confidence match (min score 0.50)
ffmpeg -ss 00:21:13.860 -to 00:21:24.036 -i "$MP4_DIR/the_clone_wars_s04e10.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch2_expendable/2_12.mp4"
echo "[40/134] 2.12: The Fratricide"

# CLIP 2.13: Dogma Shoots Krell [REVIEW]
# Low confidence match (min score 0.48)
ffmpeg -ss 00:01:30.678 -to 00:07:02.926 -i "$MP4_DIR/the_clone_wars_s04e10.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch2_expendable/2_13.mp4"
echo "[41/134] 2.13: Dogma Shoots Krell"

# CLIP 2.14: What Happens to Us Then? [REVIEW]
# Low confidence match (min score 0.47)
ffmpeg -ss 00:08:11.412 -to 00:14:03.137 -i "$MP4_DIR/the_clone_wars_s04e10.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch2_expendable/2_14.mp4"
echo "[42/134] 2.14: What Happens to Us Then?"

# CLIP 2.15: Closing Card
# TODO: Create title card / closing card manually
# Output: $CLIPS_DIR/ch2_expendable/2_15.mp4

# ── Concatenate ch2_expendable ──
CONCAT_FILE="$CLIPS_DIR/ch2_expendable/concat.txt"
> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch2_expendable/2_0.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch2_expendable/2_1.mp4'" >> "$CONCAT_FILE"
# TODO: uncomment when 2_2.mp4 is created
# echo "file '$CLIPS_DIR/ch2_expendable/2_2.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch2_expendable/2_3.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch2_expendable/2_4.mp4'" >> "$CONCAT_FILE"
# TODO: uncomment when 2_5.mp4 is created
# echo "file '$CLIPS_DIR/ch2_expendable/2_5.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch2_expendable/2_6.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch2_expendable/2_7.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch2_expendable/2_8.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch2_expendable/2_9.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch2_expendable/2_10.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch2_expendable/2_11.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch2_expendable/2_12.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch2_expendable/2_13.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch2_expendable/2_14.mp4'" >> "$CONCAT_FILE"
# TODO: uncomment when 2_15.mp4 is created
# echo "file '$CLIPS_DIR/ch2_expendable/2_15.mp4'" >> "$CONCAT_FILE"
ffmpeg -f concat -safe 0 -i "$CONCAT_FILE" \
  -c copy -y "$OUTPUT_DIR/ch2_expendable.mp4"
echo ">>> ch2_expendable.mp4 complete"

# ════════════════════════════════════════════════════════════
# CH3_ATTACHMENT
# ════════════════════════════════════════════════════════════

# CLIP 3.1: Blue Squadron Launch [AUTO]
ffmpeg -ss 00:01:28.213 -to 00:03:24.118 -i "$MP4_DIR/the_clone_wars_s01e19.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch3_attachment/3_1.mp4"
echo "[43/134] 3.1: Blue Squadron Launch"

# CLIP 3.2: Ahsoka Refuses to Retreat [AUTO]
ffmpeg -ss 00:04:10.500 -to 00:05:15.104 -i "$MP4_DIR/the_clone_wars_s01e19.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch3_attachment/3_2.mp4"
echo "[44/134] 3.2: Ahsoka Refuses to Retreat"

# CLIP 3.3: The Squadron Dies [AUTO]
ffmpeg -ss 00:05:18.735 -to 00:07:38.622 -i "$MP4_DIR/the_clone_wars_s01e19.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch3_attachment/3_3.mp4"
echo "[45/134] 3.3: The Squadron Dies"

# CLIP 3.4: Anakin's Disappointment [AUTO]
ffmpeg -ss 00:07:43.713 -to 00:08:32.718 -i "$MP4_DIR/the_clone_wars_s01e19.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch3_attachment/3_4.mp4"
echo "[46/134] 3.4: Anakin's Disappointment"

# CLIP 3.5: They're All Gone [AUTO]
ffmpeg -ss 00:10:22.831 -to 00:10:49.938 -i "$MP4_DIR/the_clone_wars_s01e19.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch3_attachment/3_5.mp4"
echo "[47/134] 3.5: They're All Gone"

# CLIP 3.6: Ahsoka Pushed to Lead [AUTO]
ffmpeg -ss 00:10:54.863 -to 00:15:07.613 -i "$MP4_DIR/the_clone_wars_s01e19.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch3_attachment/3_6.mp4"
echo "[48/134] 3.6: Ahsoka Pushed to Lead"

# CLIP 3.7: Ahsoka Improvises + Victory [AUTO]
ffmpeg -ss 00:18:17.847 -to 00:23:09.135 -i "$MP4_DIR/the_clone_wars_s01e19.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch3_attachment/3_7.mp4"
echo "[49/134] 3.7: Ahsoka Improvises + Victory"

# CLIP 3.8: Brief Domestic Beat
# TODO: Create title card / closing card manually
# Output: $CLIPS_DIR/ch3_attachment/3_8.mp4

# CLIP 3.9: Temple Bombing [AUTO]
ffmpeg -ss 00:04:11.089 -to 00:05:42.095 -i "$MP4_DIR/the_clone_wars_s05e17.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch3_attachment/3_9.mp4"
echo "[50/134] 3.9: Temple Bombing"

# CLIP 3.10: Letta Strangled / Ahsoka Framed [AUTO]
ffmpeg -ss 00:05:50.271 -to 00:09:48.216 -i "$MP4_DIR/the_clone_wars_s05e18.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch3_attachment/3_10.mp4"
echo "[51/134] 3.10: Letta Strangled / Ahsoka Framed"

# CLIP 3.11: Escape: Wish Me Luck [AUTO]
ffmpeg -ss 00:13:34.693 -to 00:21:15.736 -i "$MP4_DIR/the_clone_wars_s05e18.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch3_attachment/3_11.mp4"
echo "[52/134] 3.11: Escape: Wish Me Luck"

# CLIP 3.12: Ahsoka Contacts Barriss [AUTO]
ffmpeg -ss 00:03:57.033 -to 00:04:23.224 -i "$MP4_DIR/the_clone_wars_s05e19.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch3_attachment/3_12.mp4"
echo "[53/134] 3.12: Ahsoka Contacts Barriss"

# CLIP 3.13: Ventress Alliance [AUTO]
ffmpeg -ss 00:08:45.905 -to 00:15:58.836 -i "$MP4_DIR/the_clone_wars_s05e19.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch3_attachment/3_13.mp4"
echo "[54/134] 3.13: Ventress Alliance"

# CLIP 3.14: Attacked and Recaptured [AUTO]
ffmpeg -ss 00:15:20.174 -to 00:21:14.860 -i "$MP4_DIR/the_clone_wars_s05e19.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch3_attachment/3_14.mp4"
echo "[55/134] 3.14: Attacked and Recaptured"

# CLIP 3.15: Council Expels Ahsoka [AUTO]
ffmpeg -ss 00:00:44.174 -to 00:05:15.360 -i "$MP4_DIR/the_clone_wars_s05e20.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch3_attachment/3_15.mp4"
echo "[56/134] 3.15: Council Expels Ahsoka"

# CLIP 3.16: Ventress Testimony [AUTO]
ffmpeg -ss 00:07:15.106 -to 00:11:13.551 -i "$MP4_DIR/the_clone_wars_s05e20.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch3_attachment/3_16.mp4"
echo "[57/134] 3.16: Ventress Testimony"

# CLIP 3.17: Barriss Confrontation / Duel [AUTO]
ffmpeg -ss 00:12:48.272 -to 00:15:14.792 -i "$MP4_DIR/the_clone_wars_s05e20.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch3_attachment/3_17.mp4"
echo "[58/134] 3.17: Barriss Confrontation / Duel"

# CLIP 3.18: Barriss's Confession [AUTO]
ffmpeg -ss 00:16:22.987 -to 00:18:00.541 -i "$MP4_DIR/the_clone_wars_s05e20.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch3_attachment/3_18.mp4"
echo "[59/134] 3.18: Barriss's Confession"

# CLIP 3.19: The Great Trial Offer [AUTO]
ffmpeg -ss 00:18:22.523 -to 00:19:08.359 -i "$MP4_DIR/the_clone_wars_s05e20.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch3_attachment/3_19.mp4"
echo "[60/134] 3.19: The Great Trial Offer"

# CLIP 3.20: THE DEPARTURE [AUTO]
ffmpeg -ss 00:19:09.236 -to 00:21:29.249 -i "$MP4_DIR/the_clone_wars_s05e20.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch3_attachment/3_20.mp4"
echo "[61/134] 3.20: THE DEPARTURE"

# CLIP 3.21: Closing Card
# TODO: Create title card / closing card manually
# Output: $CLIPS_DIR/ch3_attachment/3_21.mp4

# ── Concatenate ch3_attachment ──
CONCAT_FILE="$CLIPS_DIR/ch3_attachment/concat.txt"
> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch3_attachment/3_1.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch3_attachment/3_2.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch3_attachment/3_3.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch3_attachment/3_4.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch3_attachment/3_5.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch3_attachment/3_6.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch3_attachment/3_7.mp4'" >> "$CONCAT_FILE"
# TODO: uncomment when 3_8.mp4 is created
# echo "file '$CLIPS_DIR/ch3_attachment/3_8.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch3_attachment/3_9.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch3_attachment/3_10.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch3_attachment/3_11.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch3_attachment/3_12.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch3_attachment/3_13.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch3_attachment/3_14.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch3_attachment/3_15.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch3_attachment/3_16.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch3_attachment/3_17.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch3_attachment/3_18.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch3_attachment/3_19.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch3_attachment/3_20.mp4'" >> "$CONCAT_FILE"
# TODO: uncomment when 3_21.mp4 is created
# echo "file '$CLIPS_DIR/ch3_attachment/3_21.mp4'" >> "$CONCAT_FILE"
ffmpeg -f concat -safe 0 -i "$CONCAT_FILE" \
  -c copy -y "$OUTPUT_DIR/ch3_attachment.mp4"
echo ">>> ch3_attachment.mp4 complete"

# ════════════════════════════════════════════════════════════
# CH4_CONSCIENCE
# ════════════════════════════════════════════════════════════

# CLIP 4.0: Duel Footage + Title
# TODO: Create title card / closing card manually
# Output: $CLIPS_DIR/ch4_conscience/4_0.mp4

# CLIP 4.1: Dooku + Qui-Gon: Corruption [AUTO]
ffmpeg -ss 00:00:42.291 -to 00:12:53.710 -i "$MP4_DIR/tales_of_the_jedi_s01e02.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch4_conscience/4_1.mp4"
echo "[62/134] 4.1: Dooku + Qui-Gon: Corruption"

# CLIP 4.2: Dooku + Mace: Murdered Jedi [AUTO]
ffmpeg -ss 00:00:41.083 -to 00:12:29.958 -i "$MP4_DIR/tales_of_the_jedi_s01e03.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch4_conscience/4_2.mp4"
echo "[63/134] 4.2: Dooku + Mace: Murdered Jedi"

# CLIP 4.3: Senate Speech [AUTO]
ffmpeg -ss 00:19:10.191 -to 00:20:41.195 -i "$MP4_DIR/the_clone_wars_s03e11.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch4_conscience/4_3.mp4"
echo "[64/134] 4.3: Senate Speech"

# CLIP 4.4: Palpatine Coda [AUTO]
ffmpeg -ss 00:21:18.069 -to 00:21:45.800 -i "$MP4_DIR/the_clone_wars_s03e11.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch4_conscience/4_4.mp4"
echo "[65/134] 4.4: Palpatine Coda"

# CLIP 4.5: Yoda: Fear Is the Path [AUTO]
ffmpeg -ss 01:30:12.160 -to 01:31:00.950 -i "$MP4_DIR/episode_1_the_phantom_menace.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch4_conscience/4_5.mp4"
echo "[66/134] 4.5: Yoda: Fear Is the Path"

# CLIP 4.6: The Boy Is Dangerous [AUTO]
ffmpeg -ss 01:33:11.190 -to 01:35:04.720 -i "$MP4_DIR/episode_1_the_phantom_menace.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch4_conscience/4_6.mp4"
echo "[67/134] 4.6: The Boy Is Dangerous"

# CLIP 4.7: Good Apprentice [AUTO]
ffmpeg -ss 01:38:42.160 -to 01:39:07.120 -i "$MP4_DIR/episode_1_the_phantom_menace.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch4_conscience/4_7.mp4"
echo "[68/134] 4.7: Good Apprentice"

# CLIP 4.8: Shmi's Goodbye [AUTO]
ffmpeg -ss 01:11:55.550 -to 01:16:01.250 -i "$MP4_DIR/episode_1_the_phantom_menace.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch4_conscience/4_8.mp4"
echo "[69/134] 4.8: Shmi's Goodbye"

# CLIP 4.9: The Duel of the Fates [SEMI-AUTO]
# END is visual — needs manual timestamp (estimated from START plus 4:00)
ffmpeg -ss 01:50:34.850 -to 01:54:35.350 -i "$MP4_DIR/episode_1_the_phantom_menace.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch4_conscience/4_9.mp4"
echo "[70/134] 4.9: The Duel of the Fates"

# CLIP 4.10: Qui-Gon Dies [AUTO]
ffmpeg -ss 00:43:36.200 -to 02:05:05.080 -i "$MP4_DIR/episode_1_the_phantom_menace.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch4_conscience/4_10.mp4"
echo "[71/134] 4.10: Qui-Gon Dies"

# CLIP 4.11: Funeral + Always Two There Are [AUTO]
ffmpeg -ss 02:06:27.940 -to 02:08:22.160 -i "$MP4_DIR/episode_1_the_phantom_menace.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch4_conscience/4_11.mp4"
echo "[72/134] 4.11: Funeral + Always Two There Are"

# CLIP 4.12: Dooku Exploitation [AUTO]
ffmpeg -ss 00:15:50.871 -to 00:21:28.207 -i "$MP4_DIR/the_clone_wars_s04e04.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch4_conscience/4_12.mp4"
echo "[73/134] 4.12: Dooku Exploitation"

# CLIP 4.13: VO: Republic Under Sith Control [SEMI-AUTO]
# END is visual — needs manual timestamp (estimated from START plus 0:15)
ffmpeg -ss 01:32:31.552 -to 01:32:47.052 -i "$MP4_DIR/episode_2_attack_of_the_clones.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch4_conscience/4_13.mp4"
echo "[74/134] 4.13: VO: Republic Under Sith Control"

# CLIP 4.14: Sidious Approaches Dooku [AUTO]
ffmpeg -ss 00:01:12.666 -to 00:14:20.211 -i "$MP4_DIR/tales_of_the_jedi_s01e04.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch4_conscience/4_14.mp4"
echo "[75/134] 4.14: Sidious Approaches Dooku"

# CLIP 4.15: Kamino Erasure [MANUAL]
# TODO: Fill in timestamps manually
#   Notes: Both cues are visual — needs manual timestamps
# ffmpeg -ss TODO -to TODO -i "$MP4_DIR/tales_of_the_jedi_s01e04.mp4" \
#   -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
#   -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
#   -y "$CLIPS_DIR/ch4_conscience/4_15.mp4"

# CLIP 4.16: Closing Card
# TODO: Create title card / closing card manually
# Output: $CLIPS_DIR/ch4_conscience/4_16.mp4

# ── Concatenate ch4_conscience ──
CONCAT_FILE="$CLIPS_DIR/ch4_conscience/concat.txt"
> "$CONCAT_FILE"
# TODO: uncomment when 4_0.mp4 is created
# echo "file '$CLIPS_DIR/ch4_conscience/4_0.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch4_conscience/4_1.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch4_conscience/4_2.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch4_conscience/4_3.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch4_conscience/4_4.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch4_conscience/4_5.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch4_conscience/4_6.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch4_conscience/4_7.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch4_conscience/4_8.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch4_conscience/4_9.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch4_conscience/4_10.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch4_conscience/4_11.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch4_conscience/4_12.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch4_conscience/4_13.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch4_conscience/4_14.mp4'" >> "$CONCAT_FILE"
# TODO: uncomment when 4_15.mp4 is created
# echo "file '$CLIPS_DIR/ch4_conscience/4_15.mp4'" >> "$CONCAT_FILE"
# TODO: uncomment when 4_16.mp4 is created
# echo "file '$CLIPS_DIR/ch4_conscience/4_16.mp4'" >> "$CONCAT_FILE"
ffmpeg -f concat -safe 0 -i "$CONCAT_FILE" \
  -c copy -y "$OUTPUT_DIR/ch4_conscience.mp4"
echo ">>> ch4_conscience.mp4 complete"

# ════════════════════════════════════════════════════════════
# CH5_SORESU
# ════════════════════════════════════════════════════════════

# CLIP 5.1: Confession + Merrik Standoff [AUTO]
ffmpeg -ss 00:18:23.728 -to 00:19:58.820 -i "$MP4_DIR/the_clone_wars_s02e13.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch5_soresu/5_1.mp4"
echo "[76/134] 5.1: Confession + Merrik Standoff"

# CLIP 5.2: Still Not Sure About the Beard [AUTO]
ffmpeg -ss 00:21:08.768 -to 00:21:46.386 -i "$MP4_DIR/the_clone_wars_s02e13.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch5_soresu/5_2.mp4"
echo "[77/134] 5.2: Still Not Sure About the Beard"

# CLIP 5.3: She Is or You? [AUTO]
ffmpeg -ss 00:07:09.017 -to 00:08:37.062 -i "$MP4_DIR/the_clone_wars_s06e06.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch5_soresu/5_3.mp4"
echo "[78/134] 5.3: She Is or You?"

# CLIP 5.4: Spider Legs [AUTO]
ffmpeg -ss 00:06:33.648 -to 00:19:28.754 -i "$MP4_DIR/the_clone_wars_s04e21.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch5_soresu/5_4.mp4"
echo "[79/134] 5.4: Spider Legs"

# CLIP 5.5: Talzin Restores Maul [AUTO]
ffmpeg -ss 00:00:46.051 -to 00:08:53.494 -i "$MP4_DIR/the_clone_wars_s04e22.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch5_soresu/5_5.mp4"
echo "[80/134] 5.5: Talzin Restores Maul"

# CLIP 5.6: Ventress Team-Up [AUTO]
ffmpeg -ss 00:16:06.303 -to 00:20:14.341 -i "$MP4_DIR/the_clone_wars_s04e22.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch5_soresu/5_6.mp4"
echo "[81/134] 5.6: Ventress Team-Up"

# CLIP 5.7: Alliance Proposed [AUTO]
ffmpeg -ss 00:03:15.283 -to 00:07:20.485 -i "$MP4_DIR/the_clone_wars_s05e14.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch5_soresu/5_7.mp4"
echo "[82/134] 5.7: Alliance Proposed"

# CLIP 5.8: Shadow Collective + False Flag [AUTO]
# Multi-source: the_clone_wars_s05e14, the_clone_wars_s05e15
# START in the_clone_wars_s05e14, END in the_clone_wars_s05e15
ffmpeg -ss 00:07:48.890 -i "$MP4_DIR/the_clone_wars_s05e14.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch5_soresu/5_8_a.mp4"
ffmpeg -to 00:10:09.403 -i "$MP4_DIR/the_clone_wars_s05e15.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch5_soresu/5_8_b.mp4"
printf "file '%s'\nfile '%s'\n" \
  "$CLIPS_DIR/ch5_soresu/5_8_a.mp4" \
  "$CLIPS_DIR/ch5_soresu/5_8_b.mp4" \
  > "$CLIPS_DIR/ch5_soresu/5_8_concat.txt"
ffmpeg -f concat -safe 0 -i "$CLIPS_DIR/ch5_soresu/5_8_concat.txt" \
  -c copy -y "$CLIPS_DIR/ch5_soresu/5_8.mp4"
echo "[83/134] 5.8: Shadow Collective + False Flag"

# CLIP 5.9: Maul Kills Vizsla [AUTO]
ffmpeg -ss 00:16:19.316 -to 00:21:50.687 -i "$MP4_DIR/the_clone_wars_s05e15.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch5_soresu/5_9.mp4"
echo "[84/134] 5.9: Maul Kills Vizsla"

# CLIP 5.10: Satine's Message [AUTO]
ffmpeg -ss 00:03:34.177 -to 00:06:00.446 -i "$MP4_DIR/the_clone_wars_s05e16.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch5_soresu/5_10.mp4"
echo "[85/134] 5.10: Satine's Message"

# CLIP 5.11: It Takes Strength [AUTO]
ffmpeg -ss 00:11:35.199 -to 00:11:41.287 -i "$MP4_DIR/the_clone_wars_s05e16.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch5_soresu/5_11.mp4"
echo "[86/134] 5.11: It Takes Strength"

# CLIP 5.12: Satine's Murder [AUTO]
ffmpeg -ss 00:10:39.018 -to 00:13:23.222 -i "$MP4_DIR/the_clone_wars_s05e16.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch5_soresu/5_12.mp4"
echo "[87/134] 5.12: Satine's Murder"

# CLIP 5.13: Sidious Arrives [AUTO]
ffmpeg -ss 00:16:50.597 -to 00:21:55.108 -i "$MP4_DIR/the_clone_wars_s05e16.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch5_soresu/5_13.mp4"
echo "[88/134] 5.13: Sidious Arrives"

# CLIP 5.14: Bo-Katan Rescue [AUTO]
ffmpeg -ss 00:14:11.772 -to 00:18:58.182 -i "$MP4_DIR/the_clone_wars_s05e16.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch5_soresu/5_14.mp4"
echo "[89/134] 5.14: Bo-Katan Rescue"

# CLIP 5.15: Closing Card
# TODO: Create title card / closing card manually
# Output: $CLIPS_DIR/ch5_soresu/5_15.mp4

# ── Concatenate ch5_soresu ──
CONCAT_FILE="$CLIPS_DIR/ch5_soresu/concat.txt"
> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch5_soresu/5_1.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch5_soresu/5_2.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch5_soresu/5_3.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch5_soresu/5_4.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch5_soresu/5_5.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch5_soresu/5_6.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch5_soresu/5_7.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch5_soresu/5_8.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch5_soresu/5_9.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch5_soresu/5_10.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch5_soresu/5_11.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch5_soresu/5_12.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch5_soresu/5_13.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch5_soresu/5_14.mp4'" >> "$CONCAT_FILE"
# TODO: uncomment when 5_15.mp4 is created
# echo "file '$CLIPS_DIR/ch5_soresu/5_15.mp4'" >> "$CONCAT_FILE"
ffmpeg -f concat -safe 0 -i "$CONCAT_FILE" \
  -c copy -y "$OUTPUT_DIR/ch5_soresu.mp4"
echo ">>> ch5_soresu.mp4 complete"

# ════════════════════════════════════════════════════════════
# CH6_FIVES
# ════════════════════════════════════════════════════════════

# CLIP 6.1: Tup Misfires [AUTO]
ffmpeg -ss 00:02:01.126 -to 00:04:27.855 -i "$MP4_DIR/the_clone_wars_s06e01.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch6_fives/6_1.mp4"
echo "[90/134] 6.1: Tup Misfires"

# CLIP 6.2: Sidious Learns [AUTO]
ffmpeg -ss 00:08:40.275 -to 00:09:23.984 -i "$MP4_DIR/the_clone_wars_s06e01.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch6_fives/6_2.mp4"
echo "[91/134] 6.2: Sidious Learns"

# CLIP 6.3: Fives Discovers the Chip [AUTO]
ffmpeg -ss 00:14:13.942 -to 00:21:07.395 -i "$MP4_DIR/the_clone_wars_s06e02.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch6_fives/6_3.mp4"
echo "[92/134] 6.3: Fives Discovers the Chip"

# CLIP 6.4: Fives Removes His Own Chip [AUTO]
ffmpeg -ss 00:12:19.536 -to 00:20:40.493 -i "$MP4_DIR/the_clone_wars_s06e03.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch6_fives/6_4.mp4"
echo "[93/134] 6.4: Fives Removes His Own Chip"

# CLIP 6.5: Palpatine Frames Fives [AUTO]
ffmpeg -ss 00:02:30.113 -to 00:02:40.080 -i "$MP4_DIR/the_clone_wars_s06e04.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch6_fives/6_5.mp4"
echo "[94/134] 6.5: Palpatine Frames Fives"

# CLIP 6.6: Fox Shoots Fives [AUTO]
ffmpeg -ss 00:15:24.137 -to 00:22:08.039 -i "$MP4_DIR/the_clone_wars_s06e04.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch6_fives/6_6.mp4"
echo "[95/134] 6.6: Fox Shoots Fives"

# CLIP 6.7: Sifo-Dyas / Tyranus Revealed [AUTO]
ffmpeg -ss 00:02:38.664 -to 00:21:50.938 -i "$MP4_DIR/the_clone_wars_s06e10.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch6_fives/6_7.mp4"
echo "[96/134] 6.7: Sifo-Dyas / Tyranus Revealed"

# CLIP 6.8: Title Card + Closing Card
# TODO: Create title card / closing card manually
# Output: $CLIPS_DIR/ch6_fives/6_8.mp4

# ── Concatenate ch6_fives ──
CONCAT_FILE="$CLIPS_DIR/ch6_fives/concat.txt"
> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch6_fives/6_1.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch6_fives/6_2.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch6_fives/6_3.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch6_fives/6_4.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch6_fives/6_5.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch6_fives/6_6.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch6_fives/6_7.mp4'" >> "$CONCAT_FILE"
# TODO: uncomment when 6_8.mp4 is created
# echo "file '$CLIPS_DIR/ch6_fives/6_8.mp4'" >> "$CONCAT_FILE"
ffmpeg -f concat -safe 0 -i "$CONCAT_FILE" \
  -c copy -y "$OUTPUT_DIR/ch6_fives.mp4"
echo ">>> ch6_fives.mp4 complete"

# ════════════════════════════════════════════════════════════
# INTERLUDE_GOOD_LUCK
# ════════════════════════════════════════════════════════════

# CLIP I.1: Yerbana: Anakin Being Playful [AUTO]
ffmpeg -ss 00:02:00.037 -to 00:05:38.253 -i "$MP4_DIR/the_clone_wars_s07e09.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/interlude_good_luck/I_1.mp4"
echo "[97/134] I.1: Yerbana: Anakin Being Playful"

# CLIP I.2: Hello, Master! Reunion [AUTO]
ffmpeg -ss 00:06:13.874 -to 00:08:29.466 -i "$MP4_DIR/the_clone_wars_s07e09.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/interlude_good_luck/I_2.mp4"
echo "[98/134] I.2: Hello, Master! Reunion"

# CLIP I.3: Bo-Katan's Plea [AUTO]
ffmpeg -ss 00:10:21.455 -to 00:10:52.234 -i "$MP4_DIR/the_clone_wars_s07e09.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/interlude_good_luck/I_3.mp4"
echo "[99/134] I.3: Bo-Katan's Plea"

# CLIP I.4: Separation + Reconciliation [AUTO]
# Multi-source: the_clone_wars_s06e06, the_clone_wars_s06e07
# START in the_clone_wars_s06e06, END in the_clone_wars_s06e07
ffmpeg -ss 00:15:27.849 -i "$MP4_DIR/the_clone_wars_s06e06.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/interlude_good_luck/I_4_a.mp4"
ffmpeg -to 00:20:01.954 -i "$MP4_DIR/the_clone_wars_s06e07.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/interlude_good_luck/I_4_b.mp4"
printf "file '%s'\nfile '%s'\n" \
  "$CLIPS_DIR/interlude_good_luck/I_4_a.mp4" \
  "$CLIPS_DIR/interlude_good_luck/I_4_b.mp4" \
  > "$CLIPS_DIR/interlude_good_luck/I_4_concat.txt"
ffmpeg -f concat -safe 0 -i "$CLIPS_DIR/interlude_good_luck/I_4_concat.txt" \
  -c copy -y "$CLIPS_DIR/interlude_good_luck/I_4.mp4"
echo "[100/134] I.4: Separation + Reconciliation"

# CLIP I.5: Hologram Call [AUTO]
ffmpeg -ss 00:02:23.644 -to 00:04:58.255 -i "$MP4_DIR/the_clone_wars_s07e02.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/interlude_good_luck/I_5.mp4"
echo "[101/134] I.5: Hologram Call"

# CLIP I.6: Lightsaber Handoff + Good Luck [AUTO]
ffmpeg -ss 00:10:57.366 -to 00:16:04.254 -i "$MP4_DIR/the_clone_wars_s07e09.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/interlude_good_luck/I_6.mp4"
echo "[102/134] I.6: Lightsaber Handoff + Good Luck"

# ── Concatenate interlude_good_luck ──
CONCAT_FILE="$CLIPS_DIR/interlude_good_luck/concat.txt"
> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/interlude_good_luck/I_1.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/interlude_good_luck/I_2.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/interlude_good_luck/I_3.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/interlude_good_luck/I_4.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/interlude_good_luck/I_5.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/interlude_good_luck/I_6.mp4'" >> "$CONCAT_FILE"
ffmpeg -f concat -safe 0 -i "$CONCAT_FILE" \
  -c copy -y "$OUTPUT_DIR/interlude_good_luck.mp4"
echo ">>> interlude_good_luck.mp4 complete"

# ════════════════════════════════════════════════════════════
# CH7_VICTORY_AND_DEATH
# ════════════════════════════════════════════════════════════

# CLIP 7.1: Anakin designs the real test [SEMI-AUTO]
# START is visual — needs manual timestamp (estimated from END minus 1:30)
ffmpeg -ss 00:01:43.666 -to 00:03:14.666 -i "$MP4_DIR/tales_of_the_jedi_s01e05.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch7_victory_and_death/7_1.mp4"
echo "[103/134] 7.1: Anakin designs the real test"

# CLIP 7.2: Clone troopers as training opponents [AUTO]
ffmpeg -ss 00:03:47.458 -to 00:04:52.328 -i "$MP4_DIR/tales_of_the_jedi_s01e05.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch7_victory_and_death/7_2.mp4"
echo "[104/134] 7.2: Clone troopers as training opponents"

# CLIP 7.3: The montage: failure, persistence, mastery [SEMI-AUTO]
# START is visual — needs manual timestamp (estimated from END minus 5:00)
ffmpeg -ss 00:03:14.291 -to 00:08:15.291 -i "$MP4_DIR/tales_of_the_jedi_s01e05.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch7_victory_and_death/7_3.mp4"
echo "[105/134] 7.3: The montage: failure, persistence, mastery"

# CLIP 7.4: The battle / She beats them all [AUTO]
ffmpeg -ss 00:08:20.125 -to 00:09:33.171 -i "$MP4_DIR/tales_of_the_jedi_s01e05.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch7_victory_and_death/7_4.mp4"
echo "[106/134] 7.4: The battle / She beats them all"

# CLIP 7.5: Anakin and Obi-Wan on Yerbana [AUTO]
ffmpeg -ss 00:01:00.143 -to 00:05:35.751 -i "$MP4_DIR/the_clone_wars_s07e09.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch7_victory_and_death/7_5.mp4"
echo "[107/134] 7.5: Anakin and Obi-Wan on Yerbana"

# CLIP 7.6: The Fulcrum transmission [AUTO]
ffmpeg -ss 00:05:40.549 -to 00:06:01.860 -i "$MP4_DIR/the_clone_wars_s07e09.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch7_victory_and_death/7_6.mp4"
echo "[108/134] 7.6: The Fulcrum transmission"

# CLIP 7.7: "Hello, Master." [EXPANDED] [AUTO]
ffmpeg -ss 00:06:13.874 -to 00:08:37.182 -i "$MP4_DIR/the_clone_wars_s07e09.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch7_victory_and_death/7_7.mp4"
echo "[109/134] 7.7: "Hello, Master." [EXPANDED]"

# CLIP 7.8: Bo-Katan's plea / Obi-Wan's caution [EXPANDED] [AUTO]
ffmpeg -ss 00:08:38.352 -to 00:10:52.234 -i "$MP4_DIR/the_clone_wars_s07e09.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch7_victory_and_death/7_8.mp4"
echo "[110/134] 7.8: Bo-Katan's plea / Obi-Wan's caution [EXPANDED]"

# CLIP 7.9: Coruscant under attack / Ahsoka's fury / Anakin's solution [AUTO]
ffmpeg -ss 00:10:57.366 -to 00:15:55.746 -i "$MP4_DIR/the_clone_wars_s07e09.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch7_victory_and_death/7_9.mp4"
echo "[111/134] 7.9: Coruscant under attack / Ahsoka's fury / Anakin's solution"

# CLIP 7.10: The 332nd Company [AUTO]
ffmpeg -ss 00:04:15.756 -to 00:12:54.356 -i "$MP4_DIR/the_clone_wars_s07e09.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch7_victory_and_death/7_10.mp4"
echo "[112/134] 7.10: The 332nd Company"

# CLIP 7.11: Dropping onto Mandalore [EXPANDED] [AUTO]
ffmpeg -ss 00:12:53.899 -to 00:20:32.981 -i "$MP4_DIR/the_clone_wars_s07e09.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch7_victory_and_death/7_11.mp4"
echo "[113/134] 7.11: Dropping onto Mandalore [EXPANDED]"

# CLIP 7.12: The search for Maul [EXPANDED] [AUTO]
ffmpeg -ss 00:21:27.162 -to 00:26:11.278 -i "$MP4_DIR/the_clone_wars_s07e09.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch7_victory_and_death/7_12.mp4"
echo "[114/134] 7.12: The search for Maul [EXPANDED]"

# CLIP 7.13: "I know you." [EXPANDED] [AUTO]
ffmpeg -ss 00:00:36.912 -to 00:02:26.562 -i "$MP4_DIR/the_clone_wars_s07e10.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch7_victory_and_death/7_13.mp4"
echo "[115/134] 7.13: "I know you." [EXPANDED]"

# CLIP 7.14: Obi-Wan's briefing / "Count Dooku is dead." [EXPANDED] [AUTO]
ffmpeg -ss 00:02:53.799 -to 00:05:43.509 -i "$MP4_DIR/the_clone_wars_s07e10.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch7_victory_and_death/7_14.mp4"
echo "[116/134] 7.14: Obi-Wan's briefing / "Count Dooku is dead." [EXPANDED]"

# CLIP 7.15: Maul interrogates Jesse / Almec assassination [EXPANDED] [AUTO]
ffmpeg -ss 00:06:11.455 -to 00:09:56.470 -i "$MP4_DIR/the_clone_wars_s07e10.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch7_victory_and_death/7_15.mp4"
echo "[117/134] 7.15: Maul interrogates Jesse / Almec assassination [EXPANDED]"

# CLIP 7.16: Maul's speech / Jesse returned [EXPANDED] [AUTO]
ffmpeg -ss 00:11:42.661 -to 00:14:42.089 -i "$MP4_DIR/the_clone_wars_s07e10.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch7_victory_and_death/7_16.mp4"
echo "[118/134] 7.16: Maul's speech / Jesse returned [EXPANDED]"

# CLIP 7.16B: Bo-Katan under siege / Transition to duel [NEW] [AUTO]
ffmpeg -ss 00:14:49.139 -to 00:15:04.737 -i "$MP4_DIR/the_clone_wars_s07e10.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch7_victory_and_death/7_16B.mp4"
echo "[119/134] 7.16B: Bo-Katan under siege / Transition to duel [NEW]"

# CLIP 7.17: THE DUEL: Ahsoka vs Maul [AUTO]
ffmpeg -ss 00:15:22.714 -to 00:23:44.173 -i "$MP4_DIR/the_clone_wars_s07e10.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch7_victory_and_death/7_17.mp4"
echo "[120/134] 7.17: THE DUEL: Ahsoka vs Maul"

# CLIP 7.18: Maul in custody / Bo-Katan farewell [EXPANDED] [AUTO]
ffmpeg -ss 00:01:17.286 -to 00:06:02.444 -i "$MP4_DIR/the_clone_wars_s07e11.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch7_victory_and_death/7_18.mp4"
echo "[121/134] 7.18: Maul in custody / Bo-Katan farewell [EXPANDED]"

# CLIP 7.19: The Council / "I'm sorry, citizen." [EXPANDED] [AUTO]
ffmpeg -ss 00:01:51.862 -to 00:04:30.436 -i "$MP4_DIR/the_clone_wars_s07e11.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch7_victory_and_death/7_19.mp4"
echo "[122/134] 7.19: The Council / "I'm sorry, citizen." [EXPANDED]"

# CLIP 7.20: "You didn't tell them." [AUTO]
ffmpeg -ss 00:04:31.980 -to 00:04:40.612 -i "$MP4_DIR/the_clone_wars_s07e11.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch7_victory_and_death/7_20.mp4"
echo "[123/134] 7.20: "You didn't tell them.""

# CLIP 7.21: Rex and Ahsoka on the cruiser / Calm before the storm [EXPANDED] [AUTO]
ffmpeg -ss 00:05:29.746 -to 00:09:26.148 -i "$MP4_DIR/the_clone_wars_s07e11.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch7_victory_and_death/7_21.mp4"
echo "[124/134] 7.21: Rex and Ahsoka on the cruiser / Calm before the storm [EXPANDED]"

# CLIP 7.22: ORDER 66 [EXPANDED] [SEMI-AUTO]
# START is visual — needs manual timestamp (estimated from END minus 3:30 [was 3:00])
ffmpeg -ss 00:07:26.322 -to 00:10:57.322 -i "$MP4_DIR/the_clone_wars_s07e11.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch7_victory_and_death/7_22.mp4"
echo "[125/134] 7.22: ORDER 66 [EXPANDED]"

# CLIP 7.23: Jesse's hunt order / Ahsoka escapes [EXPANDED] [AUTO]
ffmpeg -ss 00:11:21.181 -to 00:12:07.643 -i "$MP4_DIR/the_clone_wars_s07e11.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch7_victory_and_death/7_23.mp4"
echo "[126/134] 7.23: Jesse's hunt order / Ahsoka escapes [EXPANDED]"

# CLIP 7.23B: Ahsoka processes "Find Fives" [NEW] [SEMI-AUTO]
# START is visual — needs manual timestamp (estimated from END minus 0:30)
ffmpeg -ss 00:12:03.420 -to 00:12:34.420 -i "$MP4_DIR/the_clone_wars_s07e11.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch7_victory_and_death/7_23B.mp4"
echo "[127/134] 7.23B: Ahsoka processes "Find Fives" [NEW]"

# CLIP 7.24: Ahsoka frees Maul [EXPANDED] [AUTO]
ffmpeg -ss 00:13:20.384 -to 00:14:37.710 -i "$MP4_DIR/the_clone_wars_s07e11.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch7_victory_and_death/7_24.mp4"
echo "[128/134] 7.24: Ahsoka frees Maul [EXPANDED]"

# CLIP 7.25: Finding Fives / Removing Rex's chip [EXPANDED] [AUTO]
ffmpeg -ss 00:15:54.121 -to 00:23:01.380 -i "$MP4_DIR/the_clone_wars_s07e11.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch7_victory_and_death/7_25.mp4"
echo "[129/134] 7.25: Finding Fives / Removing Rex's chip [EXPANDED]"

# CLIP 7.26: Escape from the medbay [EXPANDED] [AUTO]
ffmpeg -ss 00:00:50.592 -to 00:01:30.714 -i "$MP4_DIR/the_clone_wars_s07e12.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch7_victory_and_death/7_26.mp4"
echo "[130/134] 7.26: Escape from the medbay [EXPANDED]"

# CLIP 7.27: Maul destroys the hyperdrive [EXPANDED] [AUTO]
ffmpeg -ss 00:02:11.089 -to 00:04:03.534 -i "$MP4_DIR/the_clone_wars_s07e12.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch7_victory_and_death/7_27.mp4"
echo "[131/134] 7.27: Maul destroys the hyperdrive [EXPANDED]"

# CLIP 7.28: The hangar standoff: "I am not going to kill them." [EXPANDED] [AUTO]
ffmpeg -ss 00:04:08.332 -to 00:08:24.420 -i "$MP4_DIR/the_clone_wars_s07e12.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch7_victory_and_death/7_28.mp4"
echo "[132/134] 7.28: The hangar standoff: "I am not going to kill them." [EXPANDED]"

# CLIP 7.29: Rex vs Jesse: "I didn't much like being a commander anyway." [EXPANDED] [AUTO]
ffmpeg -ss 00:08:31.011 -to 00:13:45.032 -i "$MP4_DIR/the_clone_wars_s07e12.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch7_victory_and_death/7_29.mp4"
echo "[133/134] 7.29: Rex vs Jesse: "I didn't much like being a commander anyway." [EXPANDED]"

# CLIP 7.30: The crash [EXPANDED] [AUTO]
ffmpeg -ss 00:13:58.630 -to 00:15:15.080 -i "$MP4_DIR/the_clone_wars_s07e12.mp4" \
  -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
  -y "$CLIPS_DIR/ch7_victory_and_death/7_30.mp4"
echo "[134/134] 7.30: The crash [EXPANDED]"

# CLIP 7.31: The graves [EXPANDED] [MANUAL]
# TODO: Fill in timestamps manually
#   Notes: Both cues are visual — needs manual timestamps
# ffmpeg -ss TODO -to TODO -i "$MP4_DIR/the_clone_wars_s07e12.mp4" \
#   -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
#   -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
#   -y "$CLIPS_DIR/ch7_victory_and_death/7_31.mp4"

# CLIP 7.32: THE SNOW: Vader's arrival [EXPANDED] [MANUAL]
# TODO: Fill in timestamps manually
#   Notes: Both cues are visual — needs manual timestamps
# ffmpeg -ss TODO -to TODO -i "$MP4_DIR/the_clone_wars_s07e12.mp4" \
#   -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24 \
#   -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black" \
#   -y "$CLIPS_DIR/ch7_victory_and_death/7_32.mp4"

# ── Concatenate ch7_victory_and_death ──
CONCAT_FILE="$CLIPS_DIR/ch7_victory_and_death/concat.txt"
> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch7_victory_and_death/7_1.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch7_victory_and_death/7_2.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch7_victory_and_death/7_3.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch7_victory_and_death/7_4.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch7_victory_and_death/7_5.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch7_victory_and_death/7_6.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch7_victory_and_death/7_7.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch7_victory_and_death/7_8.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch7_victory_and_death/7_9.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch7_victory_and_death/7_10.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch7_victory_and_death/7_11.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch7_victory_and_death/7_12.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch7_victory_and_death/7_13.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch7_victory_and_death/7_14.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch7_victory_and_death/7_15.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch7_victory_and_death/7_16.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch7_victory_and_death/7_16B.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch7_victory_and_death/7_17.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch7_victory_and_death/7_18.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch7_victory_and_death/7_19.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch7_victory_and_death/7_20.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch7_victory_and_death/7_21.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch7_victory_and_death/7_22.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch7_victory_and_death/7_23.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch7_victory_and_death/7_23B.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch7_victory_and_death/7_24.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch7_victory_and_death/7_25.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch7_victory_and_death/7_26.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch7_victory_and_death/7_27.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch7_victory_and_death/7_28.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch7_victory_and_death/7_29.mp4'" >> "$CONCAT_FILE"
echo "file '$CLIPS_DIR/ch7_victory_and_death/7_30.mp4'" >> "$CONCAT_FILE"
# TODO: uncomment when 7_31.mp4 is created
# echo "file '$CLIPS_DIR/ch7_victory_and_death/7_31.mp4'" >> "$CONCAT_FILE"
# TODO: uncomment when 7_32.mp4 is created
# echo "file '$CLIPS_DIR/ch7_victory_and_death/7_32.mp4'" >> "$CONCAT_FILE"
ffmpeg -f concat -safe 0 -i "$CONCAT_FILE" \
  -c copy -y "$OUTPUT_DIR/ch7_victory_and_death.mp4"
echo ">>> ch7_victory_and_death.mp4 complete"

# ════════════════════════════════════════════════════════════
# ROTS ENHANCED
# ════════════════════════════════════════════════════════════
# ROTS Enhanced requires splitting the film at insertion points
# and interleaving source material. This is complex and
# best done in a video editor (DaVinci Resolve, Premiere, etc.).
# Below are the insertion points for reference.

# R.1: DEW IT Flashcut
#   ROTS insertion after: 00:14:16.899
#   ROTS insertion before: 00:14:22.779
#   Duration: 0.5s
#   Source files: tales_of_the_jedi_s01e04, episode_3_revenge_of_the_sith

# R.2: Nightmare Sequence
#   ROTS insertion after: 00:30:32.875
#   ROTS insertion before: TODO
#   Duration: 25-30s
#   Source files: episode_2_attack_of_the_clones

# R.3: Tusken Confession to Palpatine
#   ROTS insertion after: 00:45:53.003
#   ROTS insertion before: 00:46:12.773
#   Duration: 45s
#   Source files: episode_2_attack_of_the_clones

# R.4: You Were My Brother Flashcuts
#   ROTS insertion after: 02:00:21.889
#   ROTS insertion before: 02:00:33.984
#   Duration: 2s
#   Source files: episode_3_revenge_of_the_sith

# R.5: Vader Mask VO
#   ROTS insertion after: 02:07:55.634
#   ROTS insertion before: 02:08:00.556
#   Duration: 3s
#   Source files: episode_2_attack_of_the_clones

# R.6: Order 66 Rex Whisper
#   ROTS insertion after: 01:20:46.263
#   ROTS insertion before: 01:22:23.151
#   Duration: 2s
#   Source files: the_clone_wars_s07e11

echo ""
echo "═══════════════════════════════════════════"
echo "All chapters generated in $OUTPUT_DIR/"
ls -lh "$OUTPUT_DIR/"*.mp4 2>/dev/null
echo "═══════════════════════════════════════════"
