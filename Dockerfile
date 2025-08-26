FROM n8nio/n8n:1.78.1

# Install dependencies (jq, curl, wget, unzip, bash for safety)
USER root
RUN apk add --no-cache curl wget unzip jq bash

# Install ngrok
RUN wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-stable-linux-amd64.zip \
    && unzip ngrok-stable-linux-amd64.zip -d /usr/local/bin \
    && rm ngrok-stable-linux-amd64.zip

# Copy start script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Switch back to node user (n8n runs as node)
USER node

# Run start.sh with sh
CMD ["sh", "/start.sh"]
