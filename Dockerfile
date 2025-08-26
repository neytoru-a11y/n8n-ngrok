FROM n8nio/n8n:1.108.1

USER root

RUN apk add --no-cache curl unzip jq \
    && curl -sSLo /tmp/ngrok.zip https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-stable-linux-amd64.zip \
    && unzip /tmp/ngrok.zip -d /usr/local/bin \
    && rm /tmp/ngrok.zip

# Place script in /usr/local/bin (always available in PATH)
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

EXPOSE 5678

CMD ["start.sh"]
