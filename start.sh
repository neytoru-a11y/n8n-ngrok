#!/usr/bin/env sh
set -eu

# Render provides $PORT (fallback for local runs)
: "${PORT:=5678}"

# Make n8n pass Render's health/port check
export N8N_HOST="0.0.0.0"
export N8N_PORT="${PORT}"
export N8N_PROTOCOL="http"

# Optional: show the editor at your Render URL (uncomment and set if you want)
# export N8N_EDITOR_BASE_URL="https://your-service.onrender.com"

# Configure ngrok (needs NGROK_AUTHTOKEN)
if [ -n "${NGROK_AUTHTOKEN:-}" ]; then
  ngrok config add-authtoken "$NGROK_AUTHTOKEN"
fi

# Start ngrok pointing to the *internal* n8n port
ngrok http "http://127.0.0.1:${N8N_PORT}" --log=stdout >/tmp/ngrok.log 2>&1 &
NGROK_PID=$!

# Wait for ngrok API and fetch the https public URL
echo "Waiting for ngrok tunnel..."
geturl() {
  curl -fsS http://127.0.0.1:4040/api/tunnels \
  | jq -r '.tunnels[] | select(.proto=="https") | .public_url' | head -n1
}
for i in $(seq 1 60); do
  URL="$(geturl || true)"
  [ -n "$URL" ] && break
  sleep 1
done
[ -n "${URL:-}" ] || { echo "ngrok URL not found"; tail -n +200 /tmp/ngrok.log || true; exit 1; }

# Tell n8n to register webhooks at the ngrok URL
export WEBHOOK_URL="${URL}/"
echo "WEBHOOK_URL=$WEBHOOK_URL"

# Strongly recommended so credentials survive restarts
: "${N8N_ENCRYPTION_KEY:?Set N8N_ENCRYPTION_KEY env var}"

# Clean shutdown if container stops
trap 'kill $NGROK_PID >/dev/null 2>&1 || true' INT TERM EXIT

# Start n8n as PID 1
exec n8n start
