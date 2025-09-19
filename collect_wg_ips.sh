#!/usr/bin/env bash
set -euo pipefail

DOMAINS=(
  chatgpt.com
  www.chatgpt.com
  openai.com
  api.openai.com
  auth.openai.com
  cdn.oaistatic.com
  files.oaiusercontent.com
  explorer.api.openai.com
  youtube.com
  www.youtube.com
  m.youtube.com
  youtubei.googleapis.com
  i.ytimg.com
  yt3.ggpht.com
  googlevideo.com
  instagram.com
  www.instagram.com
  scontent.cdninstagram.com
  static.cdninstagram.com
)

ATTEMPTS=5
OUTFILE="/tmp/wg_allowed_ips.txt"
> "$OUTFILE"

for d in "${DOMAINS[@]}"; do
  for ((i=1;i<=ATTEMPTS;i++)); do
    curl -sS -o /dev/null -w "%{remote_ip}\n" --connect-timeout 5 --max-time 8 "https://$d" \
      | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' || true
  done
done | sort -u | awk '{printf "%s/32,",$1}' | sed 's/,$/\n/' > "$OUTFILE"

# Показать результат в stdout и путь к файлу
cat "$OUTFILE"
echo "Saved to: $OUTFILE"
