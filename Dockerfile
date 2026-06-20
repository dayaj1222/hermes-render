FROM python:3.13-slim

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Hermes Agent
RUN curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash

# Add hermes to PATH
ENV PATH="/root/.local/bin:$PATH"

# Hermes home directory (persist config/sessions on Render Disk if mounted)
ENV HERMES_HOME=/data/.hermes

# Create data directory
RUN mkdir -p /data/.hermes

# Set working directory
WORKDIR /app

# Copy startup script
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Render injects $PORT env var (default 10000)
EXPOSE 10000

CMD ["/app/start.sh"]
