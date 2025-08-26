FROM n8nio/n8n:1.108.1

USER root

# Install dependencies (Debian-based now uses apt-get, not apk)
RUN apt-get update && apt-get install -y curl unzip jq \
    && curl -sSLo /tmp/ngrok.zip https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-stable-linux-amd64.zip \
    && unzip /tmp/ngrok.zip -d /usr/local/bin \
    && rm /tmp/ngrok.zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 5678

CMD ["/start.sh"]
