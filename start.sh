#!/bin/bash
set -e

# 1. Configure ngrok with the auth token from environment variables.
ngrok config add-authtoken $NGROK_AUTHTOKEN

# 2. Start the ngrok tunnel in the background.
echo "Starting ngrok tunnel for n8n on port 5678..."
ngrok http 5678 --log=stdout > /dev/null &

# 3. Wait a few seconds for ngrok to initialize.
sleep 5

# 4. Use the local ngrok API to get the public URL it generated.
export WEBHOOK_URL=$(curl --silent http://127.0.0.1:4040/api/tunnels | jq -r .tunnels[0].public_url)

if [ -z "$WEBHOOK_URL" ]; then
  echo "Error: Could not retrieve ngrok URL. ngrok might not have started correctly."
  exit 1
fi

echo "✅ ngrok tunnel is active at: $WEBHOOK_URL"
echo "n8n will use this as the base for all webhook URLs."

# 5. Start n8n.
exec n8n