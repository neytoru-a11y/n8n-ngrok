# Start from your specified n8n image
FROM n8nio/n8n:1.108.1

# Switch to the root user to be able to install packages
USER root

# Update the package index first, then install all system dependencies (python, pip, ffmpeg),
# then install the python package (yt-dlp), and finally clean up.
RUN apk update && \
    apk add --no-cache python3 py3-pip ffmpeg && \
    pip3 install yt-dlp && \
    rm -rf /var/cache/apk/*

# Switch back to the default, less privileged user for security
USER node
