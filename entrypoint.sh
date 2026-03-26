#!/bin/sh
set -e

TOKEN="${WEBHOOK_TOKEN:?WEBHOOK_TOKEN must be set}"
VAULT="${VAULT_PATH:?VAULT_PATH must be set}"

RESPONSE="HTTP/1.1 200 OK\r\nContent-Length: 2\r\nConnection: close\r\n\r\nOK"

echo "Webhook listening on port 9000..."

while true; do
  REQUEST=$(echo -e "$RESPONSE" | nc -l -p 9000 2>/dev/null)

  if echo "$REQUEST" | grep -q "Bearer $TOKEN"; then
    echo "$(date) - Authorized. Pulling..."
    cd "$VAULT" && git pull
    echo "$(date) - Done."
  else
    echo "$(date) - Unauthorized or empty."
  fi
done
