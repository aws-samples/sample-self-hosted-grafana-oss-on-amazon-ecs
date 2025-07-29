FROM docker.io/grafana/grafana-oss:latest-ubuntu

# Expose the Grafana port
EXPOSE 3000

# Switch to non-root user
USER grafana

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
  CMD wget -f http://localhost:3000/api/health || exit 1