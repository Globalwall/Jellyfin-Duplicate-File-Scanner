#!/bin/bash

TARGET=${1:-.}
MIN_SIZE_MB=20
TMPHASHES=$(mktemp)

echo "[*] Scanning: $TARGET"
echo "[*] Skipping files smaller than ${MIN_SIZE_MB}MB and unwanted extensions"
echo "[*] Using first and last 10MB for hash fingerprint"

process_file() {
  local FILE="$1"
  local SIZE BLOCK_SIZE OFFSET FIRST_HASH LAST_HASH

  SIZE=$(stat -c%s "$FILE" 2>/dev/null) || return 1
  [ "$SIZE" -lt $((MIN_SIZE_MB * 1024 * 1024)) ] && return 0

  BLOCK_SIZE=$((10 * 1024 * 1024))
  OFFSET=$(( SIZE > BLOCK_SIZE ? SIZE - BLOCK_SIZE : 0 ))

  FIRST_HASH=$(dd if="$FILE" bs=1M count=10 skip=0 2>/dev/null | sha256sum | cut -d" " -f1)
  LAST_HASH=$(dd if="$FILE" bs=1M count=10 skip=$((OFFSET / 1048576)) 2>/dev/null | sha256sum | cut -d" " -f1)

  echo "$FIRST_HASH:$LAST_HASH:$SIZE:$FILE"
}

export -f process_file

find "$TARGET" -type f -size +"${MIN_SIZE_MB}"M \
  ! -iname "*.srt" ! -iname "*.nfo" ! -iname "*.jpg" ! -iname "*.jpeg" \
  ! -iname "*.png" ! -iname "*.txt" ! -iname "*.url" ! -iname "*.ini" \
| parallel --bar --jobs "$(nproc)" process_file {} > "$TMPHASHES"

echo "[*] Checking for duplicate files..."

awk -F: '
{
    key = $1 ":" $2 ":" $3
    files[key] = files[key] ? files[key] RS $4 : $4
    counts[key]++
}
END {
    dup_found = 0
    for (k in counts) {
        if (counts[k] > 1) {
            dup_found = 1
            print "Duplicates for hash " k ":"
            print files[k]
            print ""
        }
    }
    if (!dup_found) {
        print "[✓] No duplicates found!"
    }
}
' "$TMPHASHES"

rm -f "$TMPHASHES"
