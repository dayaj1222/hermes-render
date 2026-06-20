FROM python:3.13-slim

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# ---- DeepSeek Proxy (copied from local dev) ----
COPY deepseek-proxy/ /app/deepseek-proxy/
WORKDIR /app/deepseek-proxy
RUN pip install --no-cache-dir -r requirements.txt

# ---- Hermes Agent ----
# Non-interactive install: skip setup wizard, we write config at runtime
RUN curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash -s -- --non-interactive --skip-setup
ENV PATH="/root/.local/bin:$PATH"
ENV HERMES_HOME=/data/.hermes
RUN mkdir -p /data/.hermes

# ---- Startup ----
WORKDIR /app
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

EXPOSE 10000
CMD ["/app/start.sh"]
