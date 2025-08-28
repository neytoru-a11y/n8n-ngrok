FROM n8nio/n8n:1.108.1
USER root

RUN apk update && \
    apk add --no-cache python3 py3-pip ffmpeg && \
    pip3 install --no-cache-dir --break-system-packages yt-dlp && \
    rm -rf /var/cache/apk/*

# Create /data and set permissions so node can read secrets
RUN mkdir -p /data && chown node:node /data

# Switch back to node user
USER node
