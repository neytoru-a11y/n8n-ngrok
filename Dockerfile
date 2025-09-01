# -------- Lean n8n + ffmpeg + yt-dlp (Alpine-safe) --------
# Pin base so upgrades are deliberate
ARG N8N_VERSION=1.108.2
FROM docker.n8n.io/n8nio/n8n:${N8N_VERSION}

# Use ash with pipefail for safer RUN lines
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

# Root only for installs
USER root

# Minimal deps from Alpine repos (no build toolchains)
# - ca-certificates, curl: basics
# - ffmpeg: for audio
# - python3: runtime (preferred when using py3-yt-dlp)
RUN apk add --no-cache \
      ca-certificates \
      curl \
      ffmpeg \
      python3

# Prefer Alpine’s packaged yt-dlp; fall back to official static binary if unavailable
RUN set -eux; \
    if apk add --no-cache py3-yt-dlp; then \
      ln -sf /usr/bin/python3 /usr/bin/python; \
      yt-dlp --version; \
    else \
      echo "py3-yt-dlp not available on this mirror; falling back to static binary"; \
      curl -fsSL https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp \
        -o /usr/local/bin/yt-dlp; \
      chmod +x /usr/local/bin/yt-dlp; \
      /usr/local/bin/yt-dlp --version; \
    fi

# Writable paths for workflows (Execute Command node writes here)
RUN mkdir -p /data /home/node/.n8n && chown -R node:node /data /home/node

# Quiet + low-IO defaults for small hosts (does not change workflow behavior)
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
# Optional memory guard (uncomment if you want to cap Node heap)
# ENV NODE_OPTIONS=--max-old-space-size=256

# Simple healthcheck; n8n exposes /healthz when ready
HEALTHCHECK --interval=30s --timeout=5s --start-period=40s --retries=3 \
  CMD curl -fsS http://localhost:5678/healthz || exit 1

# Drop privileges for runtime
USER node

# Useful volumes
VOLUME ["/home/node/.n8n", "/data"]
