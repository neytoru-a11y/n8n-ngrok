FROM docker.n8n.io/n8nio/n8n:1.78.1

EXPOSE 5678

ENTRYPOINT ["tini", "--"]
CMD ["n8n", "start"]
