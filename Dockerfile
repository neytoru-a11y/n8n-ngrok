FROM n8nio/n8n:1.74.0

# Install ngrok + jq
USER root
RUN apt-get update && apt-get install -y wget unzip curl jq \
    && wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-stable-linux-amd64.zip \
    && unzip ngrok-stable-linux-amd64.zip -d /usr/local/bin \
    && rm ngrok-stable-linux-amd64.zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy your custom entrypoint
COPY start.sh /start.sh
RUN chmod +x /start.sh

USER node

CMD ["/start.sh"]
