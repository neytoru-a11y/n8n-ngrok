# Use the official Alpine-based image with n8n already installed
FROM n8nio/n8n:1.92.1-alpine

# Switch to root to install extra packages if you need (optional)
USER root

# Install minimal tools (optional)
RUN apk add --no-cache curl jq bash

# Switch back to node user (very important for n8n to run correctly)
USER node

# The official image already has n8n as entrypoint
CMD ["n8n", "start"]
