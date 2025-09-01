# -------- Lean n8n + yt-dlp on Alpine --------
ARG N8N_VERSION=1.108.2
FROM docker.n8n.io/n8nio/n8n:${N8N_VERSION}

# Root only for installs
USER root

# Minimal deps; python3 + pip (Alpine) to install yt-dlp cleanly
RUN set -eux; \
    apk add --no-cache \
      ca-certificates \
      curl \
      ffmpeg \
      python3 \
      py3-pip; \
    pip3 install --no-cache-dir --upgrade pip; \
    pip3 install --no-cache-dir yt-dlp; \
    # writable paths for your Execute Command node
    mkdir -p /data /home/node/.n8n && chown -R node:node /data /home/node

# Low-noise, low-IO defaults for tiny hosts
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
# Optional memory cap (be careful with large jobs)
# ENV NODE_OPTIONS=--max-old-space-size=256

# Simple healthcheck (n8n exposes /healthz when ready)
HEALTHCHECK --interval=30s --timeout=5s --start-period=40s --retries=3 \
  CMD curl -fsS http://localhost:5678/healthz || exit 1

# Drop privileges
USER node

# Useful volumes
VOLUME ["/home/node/.n8n", "/data"]
