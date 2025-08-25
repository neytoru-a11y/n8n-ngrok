# Start from the official n8n DEBIAN image, which includes a full OS environment
FROM n8nio/n8n:debian

# Switch to the root user to install new software
USER root

# Install curl and jq using Debian's package manager 'apt-get'
RUN apt-get update && apt-get install -y curl jq gnupg && apt-get clean && rm -rf /var/lib/apt/lists/*

# Add the ngrok repository and install ngrok
RUN curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/ngrok.gpg && \
    echo "deb https://ngrok-agent.s3.amazonaws.com buster main" > /etc/apt/sources.list.d/ngrok.list && \
    apt-get update && \
    apt-get install -y ngrok

# Copy the start script into a standard location
COPY ./start.sh /usr/local/bin/start.sh

# Make the script executable
RUN chmod +x /usr/local/bin/start.sh

# Switch back to the non-privileged 'node' user for security
USER node

# Set the command to run when the container starts
CMD ["/usr/local/bin/start.sh"]