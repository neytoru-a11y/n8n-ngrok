#!/bin/bash
set -euo pipefail

# Render provides PORT=10000 by default for web services; fall back to 5678 locally
N8N_LISTEN_PORT="${PORT:-5678}"

# Link ngrok agent to your account if token is provided
if [[ -n "${NGROK_AUTHTOKEN:-}" ]]; then
  /usr/local/bin/ngrok config add-authtoken "$NGROK_AUTHTOKEN" >/dev/null 2>&1 || true
fi

# Start ngrok FIRST so we can discover the public HTTPS URL for webhooks
/usr/local/bin/ngrok http "http://127.0.0.1:${N8N_LISTEN_PORT}" --log=stdout > /tmp/ngrok.log 2>&1 &

# Wait for ngrok API to come up and return a public URL
echo "Waiting for ngrok to provide a public URL..."
for i in {1..30}; do
  sleep 1
  if curl -sS http://127.0.0.1:4040/api/tunnels >/dev/null 2>&1; then
    NGROK_URL="$(curl -sS http://127.0.0.1:4040/api/tunnels | jq -r '.tunnels[]?.public_url' | grep -m1 '^https://')"
    if [[ -n "${NGROK_URL}" && "${NGROK_URL}" == https://* ]]; then
      break
    fi
  fi
done

if [[ -z "${NGROK_URL:-}" ]]; then
  echo "ERROR: Could not obtain ngrok public URL."
  echo "ngrok logs:"
  tail -n 100 /tmp/ngrok.log || true
  exit 1
fi

echo "ngrok public URL: ${NGROK_URL}"

# Tell n8n to use the ngrok URL for webhook registration & display
export WEBHOOK_URL="${NGROK_URL}"

# Make sure n8n binds to the Render-assigned port (or 5678 locally)
export N8N_PORT="${N8N_LISTEN_PORT}"
export N8N_HOST="0.0.0.0"

# Optional: protect the editor with basic auth by setting
# N8N_BASIC_AUTH_ACTIVE=true, N8N_BASIC_AUTH_USER, N8N_BASIC_AUTH_PASSWORD in Render

# Finally, start n8n (be PID 1 so signals work correctly)
exec n8n start