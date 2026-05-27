#!/usr/bin/env python3
"""Match clip dialogue cues to SRT timestamps. Produces edit_spec_timestamps.json."""
import json, os, re, sys
from datetime import datetime
from difflib import SequenceMatcher
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
ROOT = SCRIPT_DIR.parent
SRT_DIR = ROOT / "raw_content" / "srt"
OUT_JSON = ROOT / "edit_spec_timestamps.json"
P3_PATH = Path("/home/jefcheng/fun/star_wars_cut/cut/clips_p3_v2.md")

sys.path.insert(0, str(SCRIPT_DIR))
from srt_utils import parse_srt, build_windows, normalize_text, secs_to_timecode, parse_timecode
from edit_spec import get_all_clips, source_to_files

# Thresholds
HIGH_CONF = 0.55
LOW_CONF = 0.35

# Cache parsed SRTs
_srt_cache: dict[str, list] = {}


def get_srt(stem: str):
    if stem not in _srt_cache:
        path = SRT_DIR / f"{stem}.srt"
        if path.exists():
            _srt_cache[stem] = parse_srt(str(path))
        else:
            _srt_cache[stem] = []
    return _srt_cache[stem]


def clean_cue(cue: str) -> str:
    """Normalize a dialogue cue for matching."""
    c = cue.strip()
    c = re.sub(r"\(.*?\)", "", c)  # strip parentheticals like "(second occurrence)"
    c = re.sub(r"\[.*?\]", "", c)  # strip visual descriptions
    # Handle slash-separated alternatives — take the longest part
    if " / " in c:
        parts = [p.strip().strip('"').strip("'") for p in c.split(" / ")]
        c = max(parts, key=len)
    c = c.strip('"').strip("'").strip()
    c = normalize_text(c)
    return c


def is_visual_cue(cue: str) -> bool:
    """Check if a cue is a visual description (bracketed or empty)."""
    c = cue.strip()
    return not c or c.startswith("[")


def fuzzy_match(cue: str, entries: list, after_secs: float = 0.0) -> dict | None:
    """Find best SRT match for a dialogue cue.
    Returns {start_secs, end_secs, sub_index, matched_text, score} or None."""
    clean = clean_cue(cue)
    if not clean or len(clean) < 3:
        return None

    clean_lower = clean.lower()
    windows = build_windows(entries, max_window=4)

    best = None
    best_score = 0.0

    for text, start_s, end_s, si, ei in windows:
        if start_s < after_secs - 5:
            continue
        text_lower = text.lower()
        # SequenceMatcher ratio
        score = SequenceMatcher(None, clean_lower, text_lower).ratio()

        # Boost if the cue is a substring of the window
        if clean_lower in text_lower:
            score = max(score, 0.85)
        elif text_lower in clean_lower:
            score = max(score, 0.75)

        # Word overlap score
        cue_words = set(clean_lower.split())
        text_words = set(text_lower.split())
        if cue_words:
            overlap = len(cue_words & text_words) / len(cue_words)
            score = max(score, overlap * 0.9)

        if score > best_score:
            best_score = score
            best = {
                "start_secs": start_s,
                "end_secs": end_s,
                "sub_index": si,
                "matched_text": text,
                "score": round(score, 3),
            }

    return best


def find_nth_occurrence(cue: str, entries: list, n: int = 1) -> dict | None:
    """Find the Nth occurrence of a cue."""
    clean = clean_cue(cue)
    if not clean:
        return None
    clean_lower = clean.lower()
    count = 0
    for text, start_s, end_s, si, ei in build_windows(entries, max_window=3):
        text_lower = text.lower()
        score = SequenceMatcher(None, clean_lower, text_lower).ratio()
        if clean_lower in text_lower:
            score = max(score, 0.85)
        if score >= HIGH_CONF:
            count += 1
            if count == n:
                return {
                    "start_secs": start_s,
                    "end_secs": end_s,
                    "sub_index": si,
                    "matched_text": text,
                    "score": round(score, 3),
                }
    return None


def detect_occurrence(cue: str) -> tuple[str, int]:
    """Detect if cue specifies an occurrence number."""
    m = re.search(r"\((second|2nd|third|3rd|final|last)\s+occurrence", cue, re.I)
    if m:
        w = m.group(1).lower()
        if w in ("second", "2nd"):
            return re.sub(r"\(.*?\)", "", cue).strip(), 2
        elif w in ("third", "3rd"):
            return re.sub(r"\(.*?\)", "", cue).strip(), 3
        elif w in ("final", "last"):
            return re.sub(r"\(.*?\)", "", cue).strip(), -1
    return cue, 1


def process_clip(clip_tuple: tuple) -> dict:
    cid, chapter, label, source, start_cue, end_cue, runtime_est, flags = clip_tuple

    result = {
        "clip_id": cid,
        "chapter": chapter,
        "label": label,
        "source": source,
        "runtime_est": runtime_est,
        "flags": flags,
        "source_files": [],
        "start_time": None,
        "end_time": None,
        "start_cue": start_cue,
        "end_cue": end_cue,
        "start_matched": None,
        "end_matched": None,
        "start_score": None,
        "end_score": None,
        "status": "UNKNOWN",
        "notes": "",
    }

    # Skip editorial/film/placeholder clips
    if flags in ("EDITORIAL", "FILM", "CH7_REF"):
        result["status"] = flags
        return result

    # ROTS insertions get special handling
    if flags == "ROTS_INSERT":
        result["status"] = "ROTS_INSERT"
        files = source_to_files(source)
        result["source_files"] = files
        # Try to find the ROTS insertion point
        rots_entries = get_srt("episode_3_revenge_of_the_sith")
        if start_cue and not is_visual_cue(start_cue):
            m = fuzzy_match(start_cue, rots_entries)
            if m:
                result["start_time"] = secs_to_timecode(m["start_secs"])
                result["start_matched"] = m["matched_text"]
                result["start_score"] = m["score"]
        if end_cue and not is_visual_cue(end_cue):
            after = parse_timecode(result["start_time"]) if result["start_time"] else 0
            m = fuzzy_match(end_cue, rots_entries, after_secs=after)
            if m:
                result["end_time"] = secs_to_timecode(m["end_secs"])
                result["end_matched"] = m["matched_text"]
                result["end_score"] = m["score"]
        result["notes"] = "ROTS insertion point. Source material timestamps need separate extraction."
        return result

    # Normal clips
    files = source_to_files(source)
    result["source_files"] = files

    if not files:
        result["status"] = "NO_SOURCE"
        result["notes"] = f"Could not map source '{source}' to SRT file"
        return result

    start_visual = is_visual_cue(start_cue)
    end_visual = is_visual_cue(end_cue)

    # For multi-file clips, search START in first file and END in last file
    start_entries = get_srt(files[0])
    end_entries = get_srt(files[-1])

    start_match = None
    end_match = None

    if not start_visual and start_cue:
        cue_clean, nth = detect_occurrence(start_cue)
        if nth == -1:
            # "final occurrence" — find all matches, take last
            all_matches = []
            for text, ss, es, si, ei in build_windows(start_entries, 3):
                sc = SequenceMatcher(None, clean_cue(cue_clean).lower(), text.lower()).ratio()
                if clean_cue(cue_clean).lower() in text.lower():
                    sc = max(sc, 0.85)
                if sc >= HIGH_CONF:
                    all_matches.append({"start_secs": ss, "end_secs": es, "sub_index": si, "matched_text": text, "score": round(sc, 3)})
            start_match = all_matches[-1] if all_matches else fuzzy_match(cue_clean, start_entries)
        elif nth > 1:
            start_match = find_nth_occurrence(cue_clean, start_entries, nth)
            if not start_match:
                start_match = fuzzy_match(cue_clean, start_entries)
        else:
            start_match = fuzzy_match(start_cue, start_entries)

    if not end_visual and end_cue:
        after = start_match["start_secs"] if start_match else 0
        # For same-file clips, enforce chronological order
        if files[0] == files[-1] and start_match:
            end_match = fuzzy_match(end_cue, end_entries, after_secs=after)
        else:
            end_match = fuzzy_match(end_cue, end_entries)

    # Fill results
    if start_match:
        result["start_time"] = secs_to_timecode(max(0, start_match["start_secs"] - 0.5))
        result["start_matched"] = start_match["matched_text"]
        result["start_score"] = start_match["score"]

    if end_match:
        result["end_time"] = secs_to_timecode(end_match["end_secs"] + 1.0)
        result["end_matched"] = end_match["matched_text"]
        result["end_score"] = end_match["score"]

    # Determine status
    if start_visual and end_visual:
        result["status"] = "MANUAL"
        result["notes"] = "Both cues are visual — needs manual timestamps"
    elif start_visual:
        result["status"] = "SEMI-AUTO"
        result["notes"] = "START is visual — needs manual timestamp"
        if end_match and runtime_est:
            rt_m = re.match(r"(\d+):(\d+)", runtime_est)
            if rt_m:
                est_secs = int(rt_m.group(1)) * 60 + int(rt_m.group(2))
                est_start = end_match["end_secs"] - est_secs
                result["start_time"] = secs_to_timecode(max(0, est_start))
                result["notes"] += f" (estimated from END minus {runtime_est})"
    elif end_visual:
        result["status"] = "SEMI-AUTO"
        result["notes"] = "END is visual — needs manual timestamp"
        if start_match and runtime_est:
            rt_m = re.match(r"(\d+):(\d+)", runtime_est)
            if rt_m:
                est_secs = int(rt_m.group(1)) * 60 + int(rt_m.group(2))
                est_end = start_match["start_secs"] + est_secs
                result["end_time"] = secs_to_timecode(est_end)
                result["notes"] += f" (estimated from START plus {runtime_est})"
    elif start_match and end_match:
        min_score = min(start_match["score"], end_match["score"])
        if min_score >= HIGH_CONF:
            result["status"] = "AUTO"
        elif min_score >= LOW_CONF:
            result["status"] = "REVIEW"
            result["notes"] = f"Low confidence match (min score {min_score:.2f})"
        else:
            result["status"] = "MANUAL"
            result["notes"] = f"Very low match score ({min_score:.2f})"
    elif start_match or end_match:
        result["status"] = "SEMI-AUTO"
        which = "END" if start_match else "START"
        result["notes"] = f"{which} cue not found in SRT"
    else:
        result["status"] = "MANUAL"
        result["notes"] = "Neither cue found in SRT"

    return result


def main():
    p3 = str(P3_PATH) if P3_PATH.exists() else None
    all_clips = get_all_clips(p3)

    print(f"Processing {len(all_clips)} clips...")
    results = []
    for i, clip in enumerate(all_clips):
        r = process_clip(clip)
        results.append(r)
        sym = {"AUTO": "✓", "REVIEW": "?", "SEMI-AUTO": "~", "MANUAL": "✗",
               "EDITORIAL": "·", "FILM": "▸", "CH7_REF": "▸", "ROTS_INSERT": "⚡",
               "NO_SOURCE": "✗"}.get(r["status"], "?")
        if r["status"] not in ("EDITORIAL", "FILM", "CH7_REF"):
            print(f"  {sym} {r['clip_id']:8s} {r['status']:10s} {r['label'][:40]}")

    # Summary
    from collections import Counter
    counts = Counter(r["status"] for r in results)
    print(f"\n{'─'*50}")
    print(f"Total: {len(results)}")
    for status in ["AUTO", "REVIEW", "SEMI-AUTO", "MANUAL", "EDITORIAL", "FILM", "ROTS_INSERT", "CH7_REF", "NO_SOURCE"]:
        if counts[status]:
            print(f"  {status:15s} {counts[status]:4d}")

    output = {
        "version": "v7",
        "generated": datetime.now().isoformat(),
        "summary": dict(counts),
        "total_clips": len(results),
        "clips": results,
    }

    with open(OUT_JSON, "w") as f:
        json.dump(output, f, indent=2, ensure_ascii=False)
    print(f"\nWrote {OUT_JSON}")


if __name__ == "__main__":
    main()
