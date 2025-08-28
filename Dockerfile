# Start from the official n8n image
FROM n8nio/n8n:1.108.1

USER root

# Install Python, pip, ffmpeg, and yt-dlp
RUN apk update && \
    apk add --no-cache python3 py3-pip ffmpeg && \
    pip3 install --no-cache-dir --break-system-packages yt-dlp && \
    rm -rf /var/cache/apk/*

# Create /data directory (Render will mount cookies.txt here)
RUN mkdir -p /data && chmod 700 /data

# Switch back to node user
USER node
