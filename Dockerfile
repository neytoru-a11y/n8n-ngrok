# Use a stable, Alpine-based n8n image that includes the CLI
FROM n8nio/n8n:1.92.1

# Expose n8n default port
EXPOSE 5678

# Start n8n
CMD ["n8n"]
