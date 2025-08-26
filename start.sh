#!/bin/sh
set -e

# Configure ngrok
if [ -n "$NGROK_AUTHTOKEN" ]; then
  echo "Configuring ngrok with provided auth token..."
  ngrok config add-authtoken "$NGROK_AUTHTOKEN"
else
  echo "⚠️ No NGROK_AUTHTOKEN provided — ngrok will stop after a few hours"
fi

# Start ngrok in background
ngrok http 5678 --log=stdout > /tmp/ngrok.log &
NGROK_PID=$!

# Wait for ngrok URL
echo "⏳ Waiting for ngrok..."
for i in $(seq 1 20); do
  NGROK_URL=$(curl -s http://127.0.0.1:4040/api/tunnels | jq -r '.tunnels[0].public_url' || true)
  [ "$NGROK_URL" != "null" ] && [ -n "$NGROK_URL" ] && break
  sleep 2
done

if [ -z "$NGROK_URL" ] || [ "$NGROK_URL" = "null" ]; then
  echo "❌ Failed to get ngrok URL. Check /tmp/ngrok.log."
  kill $NGROK_PID || true
  exit 1
fi

echo "✅ NGROK URL: $NGROK_URL"
export WEBHOOK_URL=$NGROK_URL

# Start n8n
exec n8n start
