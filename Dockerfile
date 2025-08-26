FROM n8nio/n8n:1.78.1

USER root

# Install utilities
RUN apk add --no-cache curl wget unzip jq bash

# Install ngrok
RUN wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-stable-linux-amd64.zip \
    && unzip ngrok-stable-linux-amd64.zip -d /usr/local/bin \
    && rm ngrok-stable-linux-amd64.zip

# Copy start.sh into container
COPY start.sh /start.sh
RUN chmod +x /start.sh

USER node

EXPOSE 5678

# Always run start.sh from root
CMD ["/bin/bash", "/start.sh"]
