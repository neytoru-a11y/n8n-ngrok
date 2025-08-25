#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# 1. Configure ngrok with your authtoken from Render's environment variables.
ngrok config add-authtoken $NGROK_AUTHTOKEN

# 2. Start the ngrok tunnel in the background.
# This creates a tunnel from the internet to your n8n instance running on port 5678.
echo "Starting ngrok tunnel for n8n on port 5678..."
ngrok http 5678 --log=stdout > /dev/null &

# 3. Wait a few seconds for ngrok to initialize.
sleep 5

# 4. Use the local ngrok API to get the public URL it generated.
# The URL is extracted from the JSON response using jq.
export WEBHOOK_URL=$(curl --silent http://127.0.0.1:4040/api/tunnels | jq -r .tunnels[0].public_url)

if [ -z "$WEBHOOK_URL" ]; then
  echo "Error: Could not retrieve ngrok URL. ngrok might not have started correctly."
  exit 1
fi

echo "✅ ngrok tunnel is active at: $WEBHOOK_URL"
echo "n8n will use this as the base for all webhook URLs."

# 5. Start n8n.
# It will automatically pick up the WEBHOOK_URL environment variable.
# 'exec' replaces the script process with the n8n process, which is a container best practice.
exec n8n
