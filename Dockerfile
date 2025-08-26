# Use the Debian-based n8n image (has apt-get available)
FROM n8nio/n8n:1.81.1

# Switch to root to install packages
USER root

# Install any needed dependencies safely
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
     curl \
     jq \
     ca-certificates \
  && rm -rf /var/lib/apt/lists/*

# Switch back to n8n user
USER node

# Expose the default n8n port
EXPOSE 5678

# Start n8n
CMD ["n8n"]
