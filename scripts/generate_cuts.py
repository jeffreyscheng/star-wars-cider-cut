#!/usr/bin/env python3
"""Generate cut_chapters.sh from edit_spec_timestamps.json."""
import json, os, re, sys
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
ROOT = SCRIPT_DIR.parent
JSON_PATH = ROOT / "edit_spec_timestamps.json"
OUT_SCRIPT = ROOT / "scripts" / "cut_chapters.sh"

CHAPTER_MAP = {
    "CH1": "ch1_djem_so",
    "CH2": "ch2_expendable",
    "CH3": "ch3_attachment",
    "CH4": "ch4_conscience",
    "CH5": "ch5_soresu",
    "CH6": "ch6_fives",
    "INT": "interlude_good_luck",
    "CH7": "ch7_victory_and_death",
}

# Video filter for consistent output
VFILTER = "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black"
ENCODE_OPTS = '-c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k -r 24'


def fmt_tc(tc: str) -> str:
    """Convert SRT timecode to ffmpeg timecode (comma → period)."""
    if not tc:
        return ""
    return tc.replace(",", ".")


def generate():
    with open(JSON_PATH) as f:
        data = json.load(f)

    clips = data["clips"]
    lines = []
    a = lines.append

    a("#!/usr/bin/env bash")
    a("# cut_chapters.sh — The Optimal Cut v7")
    a(f"# Generated from edit_spec_timestamps.json ({data['total_clips']} clips)")
    a(f"# AUTO: {data['summary'].get('AUTO',0)}, REVIEW: {data['summary'].get('REVIEW',0)}, "
      f"SEMI-AUTO: {data['summary'].get('SEMI-AUTO',0)}, MANUAL: {data['summary'].get('MANUAL',0)}")
    a("")
    a("set -euo pipefail")
    a("")
    a('SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"')
    a('ROOT="$(dirname "$SCRIPT_DIR")"')
    a('MP4_DIR="$ROOT/raw_content/mp4"')
    a('CLIPS_DIR="$ROOT/clips"')
    a('OUTPUT_DIR="$ROOT/output"')
    a("")
    a("# ── Dependency check ──")
    a('if ! command -v ffmpeg &>/dev/null; then')
    a('  echo "ERROR: ffmpeg not found. Install it first." >&2')
    a('  exit 1')
    a("fi")
    a("")

    # Collect all source files needed
    all_sources = set()
    for clip in clips:
        for sf in clip.get("source_files", []):
            all_sources.add(sf)
    all_sources = sorted(all_sources)

    a("# ── Check source MP4s ──")
    a("MISSING=0")
    for sf in all_sources:
        a(f'if [[ ! -f "$MP4_DIR/{sf}.mp4" ]]; then')
        a(f'  echo "MISSING: {sf}.mp4" >&2')
        a('  MISSING=$((MISSING + 1))')
        a("fi")
    a('if [[ "$MISSING" -gt 0 ]]; then')
    a('  echo "ERROR: $MISSING source MP4(s) missing from $MP4_DIR" >&2')
    a('  exit 1')
    a("fi")
    a('echo "All source MP4s found."')
    a("")

    # Create directories
    a("# ── Create directories ──")
    for ch_key, ch_dir in CHAPTER_MAP.items():
        a(f'mkdir -p "$CLIPS_DIR/{ch_dir}"')
    a('mkdir -p "$OUTPUT_DIR"')
    a("")

    # Group clips by chapter
    ch_clips = {}
    for clip in clips:
        ch = clip["chapter"]
        if ch not in ch_clips:
            ch_clips[ch] = []
        ch_clips[ch].append(clip)

    clip_count = 0
    total_auto = sum(1 for c in clips if c["status"] in ("AUTO", "REVIEW", "SEMI-AUTO"))

    for ch_key, ch_dir in CHAPTER_MAP.items():
        if ch_key not in ch_clips:
            continue
        chapter_clips = ch_clips[ch_key]

        a(f"# {'═'*60}")
        a(f"# {ch_dir.upper()}")
        a(f"# {'═'*60}")
        a("")

        concat_entries = []

        for clip in chapter_clips:
            cid = clip["clip_id"]
            status = clip["status"]
            label = clip["label"]
            safe_id = cid.replace(".", "_")

            if status in ("EDITORIAL", "FILM", "CH7_REF"):
                if status == "EDITORIAL":
                    a(f"# CLIP {cid}: {label}")
                    a(f"# TODO: Create title card / closing card manually")
                    a(f"# Output: $CLIPS_DIR/{ch_dir}/{safe_id}.mp4")
                    a("")
                    concat_entries.append((safe_id, True))
                continue

            source_files = clip.get("source_files", [])
            start_tc = fmt_tc(clip.get("start_time", ""))
            end_tc = fmt_tc(clip.get("end_time", ""))

            a(f"# CLIP {cid}: {label} [{status}]")

            if not start_tc or not end_tc:
                a(f"# TODO: Fill in timestamps manually")
                if start_tc:
                    a(f"#   START: {start_tc} (score: {clip.get('start_score', '?')})")
                if end_tc:
                    a(f"#   END:   {end_tc} (score: {clip.get('end_score', '?')})")
                if clip.get("notes"):
                    a(f"#   Notes: {clip['notes']}")
                a(f"# ffmpeg -ss TODO -to TODO -i \"$MP4_DIR/{source_files[0] if source_files else 'UNKNOWN'}.mp4\" \\")
                a(f"#   {ENCODE_OPTS} \\")
                a(f'#   -vf "{VFILTER}" \\')
                a(f'#   -y "$CLIPS_DIR/{ch_dir}/{safe_id}.mp4"')
                a("")
                concat_entries.append((safe_id, True))
                continue

            clip_count += 1

            if len(source_files) > 1 and clip["status"] != "ROTS_INSERT":
                # Multi-source clip — extract from first file, concat with second
                a(f"# Multi-source: {', '.join(source_files)}")
                a(f"# START in {source_files[0]}, END in {source_files[-1]}")
                # For simplicity, extract the START→EOF from first, BOF→END from second
                a(f'ffmpeg -ss {start_tc} -i "$MP4_DIR/{source_files[0]}.mp4" \\')
                a(f"  {ENCODE_OPTS} \\")
                a(f'  -vf "{VFILTER}" \\')
                a(f'  -y "$CLIPS_DIR/{ch_dir}/{safe_id}_a.mp4"')
                a(f'ffmpeg -to {end_tc} -i "$MP4_DIR/{source_files[-1]}.mp4" \\')
                a(f"  {ENCODE_OPTS} \\")
                a(f'  -vf "{VFILTER}" \\')
                a(f'  -y "$CLIPS_DIR/{ch_dir}/{safe_id}_b.mp4"')
                a(f"printf \"file '%s'\\nfile '%s'\\n\" \\")
                a(f'  "$CLIPS_DIR/{ch_dir}/{safe_id}_a.mp4" \\')
                a(f'  "$CLIPS_DIR/{ch_dir}/{safe_id}_b.mp4" \\')
                a(f'  > "$CLIPS_DIR/{ch_dir}/{safe_id}_concat.txt"')
                a(f'ffmpeg -f concat -safe 0 -i "$CLIPS_DIR/{ch_dir}/{safe_id}_concat.txt" \\')
                a(f"  -c copy -y \"$CLIPS_DIR/{ch_dir}/{safe_id}.mp4\"")
            else:
                src = source_files[0] if source_files else "UNKNOWN"
                if clip.get("notes"):
                    a(f"# {clip['notes']}")
                a(f'ffmpeg -ss {start_tc} -to {end_tc} -i "$MP4_DIR/{src}.mp4" \\')
                a(f"  {ENCODE_OPTS} \\")
                a(f'  -vf "{VFILTER}" \\')
                a(f'  -y "$CLIPS_DIR/{ch_dir}/{safe_id}.mp4"')

            a(f'echo "[{clip_count}/{total_auto}] {cid}: {label}"')
            a("")
            concat_entries.append((safe_id, False))

        # Generate concat list and final chapter assembly
        if concat_entries:
            a(f"# ── Concatenate {ch_dir} ──")
            a(f'CONCAT_FILE="$CLIPS_DIR/{ch_dir}/concat.txt"')
            a(f'> "$CONCAT_FILE"')
            for safe_id, is_todo in concat_entries:
                if is_todo:
                    a(f"# TODO: uncomment when {safe_id}.mp4 is created")
                    a(f"# echo \"file '$CLIPS_DIR/{ch_dir}/{safe_id}.mp4'\" >> \"$CONCAT_FILE\"")
                else:
                    a(f"echo \"file '$CLIPS_DIR/{ch_dir}/{safe_id}.mp4'\" >> \"$CONCAT_FILE\"")
            a(f'ffmpeg -f concat -safe 0 -i "$CONCAT_FILE" \\')
            a(f'  -c copy -y "$OUTPUT_DIR/{ch_dir}.mp4"')
            a(f'echo ">>> {ch_dir}.mp4 complete"')
            a("")

    # ROTS Enhanced section
    rots_clips = ch_clips.get("ROTS", [])
    if rots_clips:
        a(f"# {'═'*60}")
        a("# ROTS ENHANCED")
        a(f"# {'═'*60}")
        a("# ROTS Enhanced requires splitting the film at insertion points")
        a("# and interleaving source material. This is complex and")
        a("# best done in a video editor (DaVinci Resolve, Premiere, etc.).")
        a("# Below are the insertion points for reference.")
        a("")
        for clip in rots_clips:
            a(f"# {clip['clip_id']}: {clip['label']}")
            a(f"#   ROTS insertion after: {fmt_tc(clip.get('start_time', '')) or 'TODO'}")
            a(f"#   ROTS insertion before: {fmt_tc(clip.get('end_time', '')) or 'TODO'}")
            a(f"#   Duration: {clip['runtime_est']}")
            a(f"#   Source files: {', '.join(clip.get('source_files', []))}")
            a("")

    a('echo ""')
    a('echo "═══════════════════════════════════════════"')
    a('echo "All chapters generated in $OUTPUT_DIR/"')
    a('ls -lh "$OUTPUT_DIR/"*.mp4 2>/dev/null')
    a('echo "═══════════════════════════════════════════"')

    with open(OUT_SCRIPT, "w") as f:
        f.write("\n".join(lines) + "\n")
    os.chmod(OUT_SCRIPT, 0o755)
    print(f"Wrote {OUT_SCRIPT} ({clip_count} ffmpeg extraction commands)")


if __name__ == "__main__":
    generate()
