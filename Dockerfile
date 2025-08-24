FROM n8nio/n8n:latest

# Install dependencies and ngrok on Alpine
USER root
RUN apk add --no-cache wget unzip bash \
    && wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-stable-linux-amd64.zip \
    && unzip ngrok-stable-linux-amd64.zip -d /usr/local/bin \
    && rm ngrok-stable-linux-amd64.zip

# Copy start script
WORKDIR /app
COPY start.sh ./start.sh
RUN chmod +x ./start.sh

# Switch back to default n8n user
USER node

# Start script
CMD ["./start.sh"]
