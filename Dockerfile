FROM n8nio/n8n:1.78.1

# Install required packages on Alpine
USER root
RUN apk add --no-cache \
    curl \
    wget \
    unzip \
    jq

# Install ngrok
RUN wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-stable-linux-amd64.zip \
    && unzip ngrok-stable-linux-amd64.zip -d /usr/local/bin \
    && rm ngrok-stable-linux-amd64.zip

# Copy your start.sh script into the container
WORKDIR /app
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Switch back to n8n user
USER node

# Expose n8n port
EXPOSE 5678

# Use your custom start script
CMD ["sh", "/app/start.sh"]
