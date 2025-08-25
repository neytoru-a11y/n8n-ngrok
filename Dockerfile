# Start from the official n8n Docker image
FROM n8nio/n8n:latest

# Switch to the root user to install new software
USER root

# Update package lists and install curl, jq (for parsing ngrok's API response),
# and dependencies needed to add the ngrok repository.
RUN apt-get update && apt-get install -y curl jq gnupg lsb-release && apt-get clean && rm -rf /var/lib/apt/lists/*

# Add ngrok's official GPG key for security
RUN curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | \
    gpg --dearmor -o /usr/share/keyrings/ngrok-archive-keyring.gpg

# Add the ngrok software repository
RUN echo "deb [signed-by=/usr/share/keyrings/ngrok-archive-keyring.gpg] \
    https://ngrok-agent.s3.amazonaws.com `lsb_release -cs` main" | \
    tee /etc/apt/sources.list.d/ngrok.list > /dev/null

# Update package list again and install the ngrok agent
RUN apt-get update && apt-get install -y ngrok

# Copy your start script into a standard location in the image
COPY ./start.sh /usr/local/bin/start.sh

# Make the start script executable
RUN chmod +x /usr/local/bin/start.sh

# Switch back to the non-privileged 'node' user for security
USER node

# Set the command to run when the container starts
CMD ["/usr/local/bin/start.sh"]
