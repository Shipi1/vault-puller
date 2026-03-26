#!/bin/sh
set -e

TOKEN="${WEBHOOK_TOKEN:?WEBHOOK_TOKEN must be set}"

while true; do
  # Listen for a single HTTP request on port 9000
  REQUEST=$(echo -e "HTTP/1.1 200 OK\r\nContent-Length: 2\r\n\r\nOK" | nc -l -p 9000 -w 30 2>/dev/null | head -5)

  # Check for valid authorization header
  if echo "$REQUEST" | grep -qi "Authorization: Bearer $TOKEN"; then
    echo "$(date) - Authorized request received. Pulling..."
    cd "${VAULT_PATH}" && git pull
    echo "$(date) - Pull complete."
  else
    echo "$(date) - Unauthorized or empty request, ignoring."
  fi
done
