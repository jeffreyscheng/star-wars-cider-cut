"""SRT parsing, watermark stripping, and text normalization."""
import re
from dataclasses import dataclass


@dataclass
class SrtEntry:
    index: int
    start_secs: float
    end_secs: float
    start_tc: str
    end_tc: str
    raw_text: str
    clean_text: str


def parse_timecode(tc: str) -> float:
    tc = tc.strip().replace(",", ".")
    parts = tc.split(":")
    return float(parts[0]) * 3600 + float(parts[1]) * 60 + float(parts[2])


def secs_to_timecode(s: float) -> str:
    s = max(0.0, s)
    h = int(s // 3600)
    m = int((s % 3600) // 60)
    sec = s % 60
    whole = int(sec)
    ms = int(round((sec - whole) * 1000))
    return f"{h:02d}:{m:02d}:{whole:02d},{ms:03d}"


_TAG_RE = re.compile(r"<[^>]+>")
_BRACKET_RE = re.compile(r"\[[^\]]*\]")
_MULTI_SPACE = re.compile(r"\s+")
# l→I fix: standalone 'l' used as pronoun/contraction
# Matches: l at start of line followed by space or apostrophe,
#          or l after punctuation+space followed by space or apostrophe
_L_TO_I = re.compile(r"(?:^|\b)l(?=['\s][a-z])", re.MULTILINE)


def normalize_text(raw: str) -> str:
    t = _TAG_RE.sub("", raw)
    t = _BRACKET_RE.sub("", t)
    t = _L_TO_I.sub("I", t)
    t = t.replace('"', "").replace("“", "").replace("”", "")
    t = t.replace("’", "'").replace("‘", "'")
    t = _MULTI_SPACE.sub(" ", t)
    return t.strip()


def _is_watermark_entry(text: str) -> bool:
    t = text.strip().lower()
    if t in {"h", "ht", "htt", "http", "http:", "http:/", "http://"}:
        return True
    return bool(re.match(r"^https?:/?/?h?i?q?v?e?\.?c?o?m?/?$", t))


def parse_srt(path: str) -> list[SrtEntry]:
    with open(path, encoding="utf-8-sig") as f:
        content = f.read()

    blocks = re.split(r"\n\s*\n", content.strip())
    entries = []
    for block in blocks:
        lines = block.strip().split("\n")
        if len(lines) < 2:
            continue
        # Find the timecode line (contains -->)
        tc_idx = None
        for i, line in enumerate(lines):
            if "-->" in line:
                tc_idx = i
                break
        if tc_idx is None:
            continue
        tc_line = lines[tc_idx]
        parts = tc_line.split("-->")
        if len(parts) != 2:
            continue
        try:
            start_tc = parts[0].strip()
            end_tc = parts[1].strip()
            start_secs = parse_timecode(start_tc)
            end_secs = parse_timecode(end_tc)
        except (ValueError, IndexError):
            continue
        # Try to get index from line before timecode
        idx = len(entries) + 1
        if tc_idx > 0:
            try:
                idx = int(lines[tc_idx - 1].strip())
            except ValueError:
                pass
        raw_text = " ".join(lines[tc_idx + 1:]).strip()
        if not raw_text:
            continue
        entries.append(SrtEntry(
            index=idx,
            start_secs=start_secs,
            end_secs=end_secs,
            start_tc=start_tc,
            end_tc=end_tc,
            raw_text=raw_text,
            clean_text=normalize_text(raw_text),
        ))

    # Strip watermark entries
    stripped = []
    for e in entries:
        if _is_watermark_entry(e.raw_text):
            continue
        if e.clean_text == "" or len(e.clean_text) <= 1:
            continue
        stripped.append(e)

    # Re-index
    for i, e in enumerate(stripped):
        e.index = i + 1

    return stripped


def build_windows(entries: list[SrtEntry], max_window: int = 3) -> list[tuple[str, float, float, int, int]]:
    """Build sliding windows of 1..max_window consecutive entries.
    Returns list of (combined_clean_text, start_secs, end_secs, start_idx, end_idx)."""
    windows = []
    for w in range(1, max_window + 1):
        for i in range(len(entries) - w + 1):
            group = entries[i:i + w]
            text = " ".join(e.clean_text for e in group if e.clean_text)
            windows.append((
                text,
                group[0].start_secs,
                group[-1].end_secs,
                group[0].index,
                group[-1].index,
            ))
    return windows
