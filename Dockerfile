# Start from the official n8n image
FROM n8nio/n8n:1.108.1

# Switch to root to install dependencies
USER root

# Install Python, pip, ffmpeg, then yt-dlp
RUN apk update && \
    apk add --no-cache python3 py3-pip ffmpeg && \
    pip3 install --no-cache-dir --break-system-packages yt-dlp && \
    rm -rf /var/cache/apk/*

# Copy your exported YouTube cookies into the container
COPY cookies.txt /data/cookies.txt

# Set secure permissions (readable only by node user)
RUN chown node:node /data/cookies.txt && chmod 600 /data/cookies.txt

# Switch back to node user for security
USER node
