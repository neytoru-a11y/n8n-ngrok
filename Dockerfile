FROM n8nio/n8n:latest

# Install ngrok
RUN apt-get update && apt-get install -y wget unzip \
    && wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-stable-linux-amd64.zip \
    && unzip ngrok-stable-linux-amd64.zip -d /usr/local/bin \
    && rm ngrok-stable-linux-amd64.zip

# Copy start.sh into container
WORKDIR /app
COPY start.sh ./start.sh
RUN chmod +x ./start.sh

# Start script
CMD ["./start.sh"]
