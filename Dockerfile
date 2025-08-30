# This locks your environment to the specific version you've tested
FROM docker.n8n.io/n8nio/n8n:1.180.1

# ... (the rest of the Dockerfile stays the same)
USER root
RUN apk update && apk add --no-cache ffmpeg python3
RUN curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp \
    && chmod a+rx /usr/local/bin/yt-dlp
USER node
