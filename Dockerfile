# ---- Minimal, reproducible n8n image ----
# Pin the base so upgrades are deliberate
ARG N8N_VERSION=1.108.2
FROM docker.n8n.io/n8nio/n8n:${N8N_VERSION}

# Become root only to install packages
USER root

# Install only the essentials (ffmpeg + curl) and keep layers tiny
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      ffmpeg; \
    rm -rf /var/lib/apt/lists/*

# Add static yt-dlp (no Python runtime needed → smaller + faster start)
RUN set -eux; \
    curl -fsSL https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp \
      -o /usr/local/bin/yt-dlp; \
    chmod +x /usr/local/bin/yt-dlp

# Writable paths for transcripts/audio and n8n home
RUN mkdir -p /data /home/node/.n8n && chown -R node:node /data /home/node

# Sensible runtime defaults that cut CPU + disk churn on low-resource hosts
ENV TZ=UTC \
    N8N_LOG_LEVEL=warn \
    N8N_DIAGNOSTICS_ENABLED=false \
    N8N_HIRING_BANNER_DISABLED=true \
    EXECUTIONS_DATA_SAVE_ON_SUCCESS=false \
    EXECUTIONS_DATA_SAVE_ON_PROGRESS=false \
    EXECUTIONS_DATA_PRUNE=true \
    EXECUTIONS_DATA_MAX_AGE=72 \
    N8N_CONCURRENCY=1 \
    N8N_EXECUTIONS_TIMEOUT=900 \
    NODE_ENV=production
# If you ever memory-cap Node, uncomment (be careful on large jobs):
# ENV NODE_OPTIONS=--max-old-space-size=256

# Healthcheck (n8n exposes /healthz once the server is up)
HEALTHCHECK --interval=30s --timeout=5s --start-period=40s --retries=3 \
  CMD curl -fsS http://localhost:5678/healthz || exit 1

# Drop privileges
USER node

# Data mounts (optional but handy)
VOLUME ["/home/node/.n8n", "/data"]

# Base image already sets entrypoint/cmd to start n8n
