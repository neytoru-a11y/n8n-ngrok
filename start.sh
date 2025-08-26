#!/bin/sh
set -e

# If NGROK_AUTHTOKEN is set, configure ngrok
if [ -n "$NGROK_AUTHTOKEN" ]; then
  echo "Configuring ngrok with provided auth token..."
  ngrok config add-authtoken "$NGROK_AUTHTOKEN"
else
  echo "⚠️  No NGROK_AUTHTOKEN provided — tunnel may shut down after a few hours."
fi

# Start ngrok in background
ngrok http 5678 --log=stdout > /tmp/ngrok.log &
NGROK_PID=$!

# Wait until ngrok API responds with a tunnel URL
echo "⏳ Waiting for ngrok to start..."
NGROK_URL=""
for i in $(seq 1 20); do
  NGROK_URL=$(curl -s http://127.0.0.1:4040/api/tunnels | jq -r '.tunnels[0].public_url' || true)
  if [ "$NGROK_URL" != "null" ] && [ -n "$NGROK_URL" ]; then
    break
  fi
  sleep 2
done

if [ -z "$NGROK_URL" ] || [ "$NGROK_URL" = "null" ]; then
  echo "❌ Failed to get ngrok URL after waiting. Check /tmp/ngrok.log for details."
  kill $NGROK_PID || true
  exit 1
fi

echo "✅ NGROK URL: $NGROK_URL"

# Export as environment variable so n8n can use it
export WEBHOOK_URL=$NGROK_URL

# Start n8n as PID 1
exec n8n start
