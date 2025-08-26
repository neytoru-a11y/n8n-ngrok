FROM docker.n8n.io/n8nio/n8n:1.78.1

RUN apt-get update && apt-get install -y wget unzip \
    && wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-stable-linux-amd64.zip \
    && unzip ngrok-stable-linux-amd64.zip -d /usr/local/bin \
    && rm ngrok-stable-linux-amd64.zip

# Copy entrypoint
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
