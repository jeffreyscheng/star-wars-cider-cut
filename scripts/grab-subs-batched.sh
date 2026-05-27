#!/usr/bin/env bash
# grab-subs-batched.sh - download English subtitles from arbitrary web pages.
#
# Usage:
#   ./grab-subs-batched.sh <urls.txt>     # newline-separated URLs, # comments ok
#   ./grab-subs-batched.sh <single-url>   # convenience: one URL on the command line
#
# Output filenames use the source URL slug, prefixed with a 3-digit index so the
# input order is preserved on disk. yt-dlp appends the subtitle language code,
# for example: 001-4194-7-5-star-wars-the-clone-wars.en.srt

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
  # Clamp to 120 chars to leave room for the index prefix + language + .srt.
  printf '%s' "${slug:0:120}"
}

download_subs_one() {
  local idx="$1" url="$2"
  local prefix slug out_base out_tmpl
  prefix="$(printf '%03d' "$idx")"
  slug="$(slug_from_url "$url")"
  out_base="${prefix}-${slug}"
  out_tmpl="${out_base}.%(ext)s"

  echo "===================================================================="
  echo ">> [$idx/${#URLS[@]}] $url"
  echo "===================================================================="
  echo ">> downloading English subtitles..."

  yt-dlp \
    --skip-download \
    --no-playlist \
    --write-subs \
    --write-auto-subs \
    --sub-langs "en.*" \
    --convert-subs srt \
    -o "$out_tmpl" \
    "$url"
}

# ---- run --------------------------------------------------------------
failed=()
i=0
for url in "${URLS[@]}"; do
  i=$((i + 1))
  if ! download_subs_one "$i" "$url"; then
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
