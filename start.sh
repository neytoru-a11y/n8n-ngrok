#!/bin/sh
set -e

echo ">>> Starting ngrok in background..."
ngrok http 5678 --log=stdout > /tmp/ngrok.log &
sleep 5

echo ">>> Fetching public ngrok URL..."
NGROK_URL=$(curl --silent --show-error http://127.0.0.1:4040/api/tunnels | jq -r '.tunnels[0].public_url')

if [ -z "$NGROK_URL" ] || [ "$NGROK_URL" = "null" ]; then
  echo "!!! Failed to fetch ngrok URL"
  exit 1
fi

echo ">>> Ngrok tunnel is live at: $NGROK_URL"

# Export it so n8n picks it up
export WEBHOOK_URL=$NGROK_URL
export N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true

# Finally start n8n
echo ">>> Starting n8n..."

exec n8n start
