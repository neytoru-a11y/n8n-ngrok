#!/bin/sh

# Start ngrok in background
ngrok http 5678 --authtoken $NGROK_AUTHTOKEN --log stdout &

# Start n8n
n8n
