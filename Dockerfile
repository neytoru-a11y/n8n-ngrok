# Start from official n8n image
FROM n8nio/n8n:1.108.1

USER root

# Install yt-dlp + ffmpeg
RUN apk update && \
    apk add --no-cache python3 py3-pip ffmpeg && \
    pip3 install --no-cache-dir --break-system-packages yt-dlp && \
    rm -rf /var/cache/apk/*

# Create /data (Render mounts cookies.txt here)
RUN mkdir -p /data && chown node:node /data

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Switch to node again (more secure)
USER node

# Use our entrypoint
ENTRYPOINT ["/entrypoint.sh"]
