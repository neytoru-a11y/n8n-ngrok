# Start from the official n8n Docker image (which is now Alpine-based)
FROM n8nio/n8n:latest

# The official n8n image sets the working directory to /data, which we will use.
WORKDIR /data

# Switch to the root user to install system packages
USER root

# Install dependencies using Alpine's package manager
RUN apk update && apk add --no-cache curl jq unzip

# Download and install the ngrok binary to a standard PATH location
RUN curl -sL "https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip" -o /tmp/ngrok.zip && \
    unzip /tmp/ngrok.zip -d /usr/local/bin && \
    rm /tmp/ngrok.zip

# Switch back to the non-privileged 'node' user who owns the /data directory
USER node

# Copy the start script into the current working directory (/data)
COPY ./start.sh .

# Make the start script executable
RUN chmod +x ./start.sh

# Set the command to run when the container starts, using a relative path
CMD ["./start.sh"]