# Start from your specified n8n image
FROM n8nio/n8n:1.108.1

# Switch to the root user to be able to install packages
USER root

# Update the package index, install system dependencies, then install yt-dlp, and finally clean up.
RUN apk update && \
    apk add --no-cache python3 py3-pip ffmpeg && \
    pip3 install --no-cache-dir --break-system-packages yt-dlp && \
    rm -rf /var/cache/apk/*

# Switch back to the default, less privileged user for security
USER node
