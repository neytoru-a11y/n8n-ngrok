# Dockerfile (simple + reliable)
FROM n8nio/n8n:1.81.1

USER root
RUN apt-get update \
 && apt-get install -y --no-install-recommends curl jq ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# install ngrok (v3)
RUN curl -fsSL https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz \
 | tar -xz -C /usr/local/bin

# copy startup script
COPY start.sh /usr/local/bin/start.sh
RUN chmod 755 /usr/local/bin/start.sh

# run as non-root like the official image
USER node

# our script becomes PID 1
ENTRYPOINT ["/usr/local/bin/start.sh"]
