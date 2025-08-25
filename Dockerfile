# Use Debian-based image (NOT distroless)
FROM n8nio/n8n:1-debian

USER root

# System tools we need
RUN apt-get update && apt-get install -y curl jq unzip ca-certificates && rm -rf /var/lib/apt/lists/*

# Install ngrok (official binaries are hosted at bin.equinox.io)
RUN curl -fsSL https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip -o /tmp/ngrok.zip \
  && unzip /tmp/ngrok.zip -d /usr/local/bin \
  && rm /tmp/ngrok.zip

# Copy startup script and make it executable
COPY start.sh /start.sh
RUN chmod +x /start.sh

# For Render clarity (Render's default expected port is 10000)
EXPOSE 10000

# Drop privileges back to the 'node' user provided by the base image
USER node

# Use bash to avoid PATH/cwd quirks
CMD ["bash", "/start.sh"]