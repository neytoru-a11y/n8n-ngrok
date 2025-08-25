# Start from the official n8n Docker image (which is now Alpine-based)
FROM n8nio/n8n:latest

# Switch to the root user to install new software
USER root

# Alpine's package manager is 'apk'.
# Install curl and jq (for the start script) and unzip (to extract ngrok).
RUN apk update && apk add --no-cache curl jq unzip

# Since we are on Alpine, we download the ngrok binary directly
# instead of using a package repository.
RUN curl -sL "https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip" -o /tmp/ngrok.zip && \
    unzip /tmp/ngrok.zip -d /usr/local/bin && \
    rm /tmp/ngrok.zip

# Copy your start script into a standard location in the image
COPY ./start.sh /usr/local/bin/start.sh

# Make the start script executable
RUN chmod +x /usr/local/bin/start.sh

# Switch back to the non-privileged 'node' user for security
USER node

# Set the command to run when the container starts
CMD ["/usr/local/bin/start.sh"]
