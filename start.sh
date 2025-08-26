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

# Wait a bit for ngrok to start
sleep 5

# Fetch public URL from ngrok
NGROK_URL=$(curl -s http://127.0.0.1:4040/api/tunnels | jq -r '.tunnels[0].public_url')

echo "✅ NGROK URL: $NGROK_URL"

# Export as environment variable so n8n can use it
export WEBHOOK_URL=$NGROK_URL

# Start n8n
exec n8n start
