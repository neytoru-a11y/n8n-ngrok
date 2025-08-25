# Start from the official n8n Docker image (which is now Alpine-based)
FROM n8nio/n8n:latest

# The official n8n image sets the working directory to /data, which we will use.
WORKDIR /data

# Switch to the root user to install system packages and prepare the script
USER root

# Install dependencies using Alpine's package manager
RUN apk update && apk add --no-cache curl jq unzip

# Download and install the ngrok binary to a standard PATH location
RUN curl -sL "https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip" -o /tmp/ngrok.zip && \
    unzip /tmp/ngrok.zip -d /usr/local/bin && \
    rm /tmp/ngrok.zip

# Copy the start script into the current working directory (/data)
COPY ./start.sh .

# Make the start script executable while still the root user
RUN chmod +x ./start.sh

# Now, switch to the non-privileged 'node' user for security
USER node

# DEBUG: Instead of running the script, just list the files in the directory.
CMD ["ls", "-la"]