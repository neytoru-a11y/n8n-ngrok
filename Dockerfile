# Pinning to the latest confirmed stable version for production
FROM docker.n8n.io/n8nio/n8n:1.46.0

# Switch to the root user to install system packages
USER root

# Install curl, ffmpeg, and python3
RUN apk update && apk add --no-cache ffmpeg python3 curl

# Use curl to download the latest stable yt-dlp binary
RUN curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp \
    && chmod a+rx /usr/local/bin/yt-dlp

# Switch back to the non-privileged node user for security
USER node
