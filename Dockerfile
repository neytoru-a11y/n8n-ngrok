# Use the official n8n image as base
FROM n8nio/n8n:1.81.1

# Switch to root user to allow installing dependencies if needed
USER root

# (Removed apt-get install step because the base image is Alpine, not Debian)

# Switch back to the default user
USER node

# Expose n8n default port
EXPOSE 5678

# Start n8n
CMD ["n8n"]
