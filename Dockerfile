FROM n8nio/n8n:1.108.1

USER root

RUN apk add --no-cache python3 py3-pip && \
    pip3 install yt-dlp && \
    apk add --no-cache ffmpeg

USER node
