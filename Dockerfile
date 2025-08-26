FROM n8nio/n8n:1.108.1

USER root

# Install curl, unzip, jq using apk (since image is alpine-based)
RUN apk add --no-cache curl unzip jq \
    && curl -sSLo /tmp/ngrok.zip https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-stable-linux-amd64.zip \
    && unzip /tmp/ngrok.zip -d /usr/local/bin \
    && rm /tmp/ngrok.zip

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 5678

CMD ["/bin/sh", "/start.sh"]
