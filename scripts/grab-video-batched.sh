#!/usr/bin/env bash
# grab-video.sh — download videos from arbitrary web pages.
#
# Strategy (tried per URL, in order):
#   1) yt-dlp directly on the page.
#   2) Fetch the page HTML and regex out any .m3u8/.mpd/.mp4/.webm/.mkv URLs.
#   3) Headless Chromium (Playwright) — load the page, sniff network traffic,
#      pick the best video stream, and hand it to yt-dlp.
#
# Usage:
#   ./grab-video.sh <urls.txt>          # newline-separated URLs, # comments ok
#   ./grab-video.sh <single-url>        # convenience: one URL on the command line
#
# Output filenames come from each video's title (yt-dlp's %(title)s template),
# prefixed with a 3-digit index so the input order is preserved on disk.

set -euo pipefail

ARG="${1:-}"
if [[ -z "$ARG" ]]; then
  echo "usage: $0 <urls.txt | single-url>" >&2
  exit 2
fi

have() { command -v "$1" >/dev/null 2>&1; }

# ---- dependency checks (run once) --------------------------------------
missing=()
have yt-dlp || missing+=("yt-dlp")
have ffmpeg || missing+=("ffmpeg")
have python3 || missing+=("python3")
have curl || missing+=("curl")
if (( ${#missing[@]} )); then
  echo "Missing required tools: ${missing[*]}" >&2
  echo "On macOS:  brew install ${missing[*]}" >&2
  exit 1
fi

# ---- gather URLs --------------------------------------------------------
URLS=()
if [[ -f "$ARG" ]]; then
  # Strip comments (# ...), trim whitespace, skip blanks.
  while IFS= read -r line || [[ -n "$line" ]]; do
    line="${line%%#*}"
    line="${line#"${line%%[![:space:]]*}"}"
    line="${line%"${line##*[![:space:]]}"}"
    [[ -z "$line" ]] && continue
    URLS+=("$line")
  done < "$ARG"
else
  URLS+=("$ARG")
fi

if (( ${#URLS[@]} == 0 )); then
  echo "No URLs found in $ARG." >&2
  exit 2
fi

# ---- write helper Python files once ------------------------------------
SCRAPER="$(mktemp -t scrape.XXXXXX.py)"
SNIFFER="$(mktemp -t sniff.XXXXXX.py)"
HTML_TMP="$(mktemp -t page.XXXXXX.html)"
trap 'rm -f "$SCRAPER" "$SNIFFER" "$HTML_TMP"' EXIT

cat >"$SCRAPER" <<'PYEOF'
import re, sys, html as htmlmod
try:
    txt = open(sys.argv[1], 'r', encoding='utf-8', errors='replace').read()
except OSError:
    sys.exit(0)
txt = htmlmod.unescape(txt)
# urls may appear plain, json-escaped (\/), or unicode-escaped (\u002F)
txt2 = txt.replace(r'\/', '/').encode().decode('unicode_escape', errors='ignore')
pat = re.compile(r'https?://[^\s"\'<>()]+?\.(?:m3u8|mpd|mp4|webm|mkv)(?:\?[^\s"\'<>()]*)?', re.I)
seen, out = set(), []
def rank(u):
    u = u.lower()
    return 0 if '.m3u8' in u else 1 if '.mpd' in u else 2
for src in (txt, txt2):
    for m in pat.finditer(src):
        u = m.group(0)
        if u in seen: continue
        seen.add(u); out.append(u)
for u in sorted(out, key=rank):
    print(u)
PYEOF

cat >"$SNIFFER" <<'PYEOF'
"""Load a page in headless Chromium, log every network response, and print
the most likely video-stream URLs (one per line, best guess first)."""
import asyncio, re, sys
from playwright.async_api import async_playwright

PAGE_URL = sys.argv[1]

STREAM_EXT_RE = re.compile(r"\.(m3u8|mpd|mp4|m4s|webm|mkv|mov|ts)(\?|$)", re.I)
STREAM_CT_RE  = re.compile(
    r"(application/(vnd\.apple\.mpegurl|x-mpegurl|dash\+xml)|video/)", re.I
)

def tier(url, ctype):
    u = url.lower()
    if ".m3u8" in u or "mpegurl" in (ctype or "").lower(): return 0
    if ".mpd"  in u or "dash+xml"  in (ctype or "").lower(): return 1
    if u.endswith(".mp4") or u.endswith(".webm") or u.endswith(".mkv"): return 2
    return 3

async def main():
    seen = []
    async with async_playwright() as p:
        browser = await p.chromium.launch(
            headless=True,
            args=["--autoplay-policy=no-user-gesture-required"],
        )
        ctx = await browser.new_context(
            user_agent=("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) "
                        "AppleWebKit/537.36 (KHTML, like Gecko) "
                        "Chrome/124.0 Safari/537.36"),
            viewport={"width": 1280, "height": 720},
        )
        page = await ctx.new_page()

        def on_response(resp):
            try:
                u  = resp.url
                ct = resp.headers.get("content-type", "")
            except Exception:
                return
            if STREAM_EXT_RE.search(u) or STREAM_CT_RE.search(ct or ""):
                seen.append((tier(u, ct), u))

        # Listen at context level so requests from iframes are also captured.
        ctx.on("response", on_response)

        try:
            await page.goto(PAGE_URL, wait_until="domcontentloaded", timeout=45_000)
        except Exception as e:
            print(f"# nav warning: {e}", file=sys.stderr)

        for sel in ["button.play", ".play-button", ".jw-icon-display",
                    ".vjs-big-play-button", "video"]:
            try:
                el = await page.query_selector(sel)
                if el:
                    await el.click(timeout=2_000)
            except Exception:
                pass

        await page.wait_for_timeout(10_000)
        await browser.close()

    out, seen_urls = [], set()
    for t, u in sorted(seen, key=lambda x: x[0]):
        if u in seen_urls: continue
        seen_urls.add(u)
        out.append(u)
    for u in out:
        print(u)

asyncio.run(main())
PYEOF

# Find a python with playwright installed (for tier 3 only).
PYBIN=""
for c in python3 python; do
  if have "$c" && "$c" -c "import playwright" >/dev/null 2>&1; then
    PYBIN="$c"; break
  fi
done

# ---- per-URL pipeline ---------------------------------------------------
# Args: <index> <url>
# Returns 0 on success, 1 on failure. Does not call exit.

# Derive a safe, short filename slug from a page URL.
# Uses the last meaningful path segment, strips query strings, and clamps
# length so we don't blow past the OS filename limit (255 bytes on macOS).
slug_from_url() {
  local u="$1" slug
  slug="${u%%\?*}"          # drop query string
  slug="${slug%/}"          # drop trailing slash
  slug="${slug##*/}"        # keep last path segment
  # Replace anything that isn't safe-for-filenames with '-'
  slug="$(printf '%s' "$slug" | LC_ALL=C tr -c 'A-Za-z0-9._-' '-' | tr -s '-')"
  slug="${slug#-}"; slug="${slug%-}"
  [[ -z "$slug" ]] && slug="video"
  # Clamp to 120 chars to leave room for the index prefix + .ext
  printf '%s' "${slug:0:120}"
}

download_one() {
  local idx="$1" url="$2"
  local prefix slug out_base
  prefix="$(printf '%03d' "$idx")"
  slug="$(slug_from_url "$url")"
  out_base="${prefix}-${slug}"
  local out_tmpl="${out_base}.%(ext)s"

  echo "===================================================================="
  echo ">> [$idx/${#URLS[@]}] $url"
  echo "===================================================================="

  # Tier 1: yt-dlp directly.
  echo ">> [1/3] yt-dlp direct..."
  if yt-dlp \
      -N 8 \
      --no-playlist \
      --merge-output-format mp4 \
      -f 'bv*+ba/b' \
      -o "$out_tmpl" \
      "$url"; then
    return 0
  fi
  echo ">> yt-dlp couldn't handle the page directly."

  # Tier 2: scrape HTML for stream URLs.
  echo ">> [2/3] scanning page HTML..."
  : >"$HTML_TMP"
  if ! curl -fsSL -A "Mozilla/5.0" -o "$HTML_TMP" "$url"; then
    echo "   (could not fetch page HTML)"
  fi
  local scraped best
  scraped="$(python3 "$SCRAPER" "$HTML_TMP")"
  if [[ -n "$scraped" ]]; then
    echo ">> found candidate stream(s) in page HTML:"
    echo "$scraped" | sed 's/^/   /'
    best="$(echo "$scraped" | head -n1)"
    echo ">> downloading: $best"
    if yt-dlp \
        --concurrent-fragments 16 \
        --hls-prefer-native \
        --live-from-start \
        --merge-output-format mp4 \
        --add-header "Referer: ${url}" \
        -o "$out_tmpl" \
        "$best"; then
      return 0
    fi
    echo ">> direct download of scraped URL failed; trying browser sniff..."
  fi

  # Tier 3: headless-browser network sniff.
  if [[ -z "$PYBIN" ]]; then
    echo ">> [3/3] skipped: Playwright not installed." >&2
    echo "   pip install playwright && playwright install chromium" >&2
    return 1
  fi
  echo ">> [3/3] headless-browser network sniff..."
  local candidates
  candidates="$("$PYBIN" "$SNIFFER" "$url" || true)"
  if [[ -z "$candidates" ]]; then
    echo "   No video streams detected on the page." >&2
    return 1
  fi
  echo ">> found candidate stream(s):"
  echo "$candidates" | sed 's/^/   /'
  best="$(echo "$candidates" | head -n1)"
  echo ">> downloading: $best"
  if yt-dlp \
      --concurrent-fragments 16 \
      --hls-prefer-native \
      --live-from-start \
      --merge-output-format mp4 \
      --add-header "Referer: ${url}" \
      -o "$out_tmpl" \
      "$best"; then
    return 0
  fi
  return 1
}

# ---- run --------------------------------------------------------------
failed=()
i=0
for url in "${URLS[@]}"; do
  i=$((i + 1))
  if ! download_one "$i" "$url"; then
    failed+=("$url")
  fi
done

echo "===================================================================="
total=${#URLS[@]}
ok=$(( total - ${#failed[@]} ))
echo ">> finished: $ok/$total succeeded"
if (( ${#failed[@]} )); then
  echo ">> failures:"
  printf '   %s\n' "${failed[@]}"
  exit 1
fi
