#!/bin/sh
# Copy cookies into /tmp where node can read/write
cp /data/cookies.txt /tmp/cookies.txt
chmod 644 /tmp/cookies.txt
exec n8n
