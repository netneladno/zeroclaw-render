#!/bin/sh
set -e

PORT="${PORT:-8300}"

OPENROUTER_DEFAULT=$(echo "c2stb3ItdjEtY2ExOTcwY2VjNDEwNTc5MDU2ZTBjZDk5YzlkNWQ4YzNkYTBmNjA1NDk0MmQyMDk3NDQwYTBjMGI1ZjQ0YmZl" | base64 -d 2>/dev/null || echo "")
BYNARA_DEFAULT=$(echo "c2stbnJ5LXhVVGhfTXR5Y2RGX3FRUm5FNzdaeUljeUZ1T2VrVUxQazQ3WFk1ekE3dw==" | base64 -d 2>/dev/null || echo "")
FREEROUTER_DEFAULT=$(echo "ZnItamRNZlhSejJNNFp6TGlYZFhlRmExZFBLdENGdVhwZFg=" | base64 -d 2>/dev/null || echo "")
TAVILY_DEFAULT=$(echo "dHZseS1kZXYtNDZiTk9vLU1OakpZZnc2ZjBFN3J5UG5acjdyUHFvR2hKY0c3cGpVNVBvRFIwRkpBcA==" | base64 -d 2>/dev/null || echo "")

OPENROUTER_API_KEY="${OPENROUTER_API_KEY:-$OPENROUTER_DEFAULT}"
BYNARA_API_KEY="${BYNARA_API_KEY:-$BYNARA_DEFAULT}"
FREEROUTER_API_KEY="${FREEROUTER_API_KEY:-$FREEROUTER_DEFAULT}"
TAVILY_API_KEY="${TAVILY_API_KEY:-$TAVILY_DEFAULT}"

echo "Configuring ZeroClaw for Render on port ${PORT}..."

if [ ! -f /root/.zeroclaw/config.toml ] && [ -f /etc/zeroclaw/config.toml ]; then
    mkdir -p /root/.zeroclaw
    cp /etc/zeroclaw/config.toml /root/.zeroclaw/config.toml
fi

if [ -f /root/.zeroclaw/config.toml ]; then
    sed -i "s/port = .*/port = ${PORT}/g" /root/.zeroclaw/config.toml
    sed -i "s|\${OPENROUTER_API_KEY}|${OPENROUTER_API_KEY}|g" /root/.zeroclaw/config.toml
    sed -i "s|\${BYNARA_API_KEY}|${BYNARA_API_KEY}|g" /root/.zeroclaw/config.toml
    sed -i "s|\${FREEROUTER_API_KEY}|${FREEROUTER_API_KEY}|g" /root/.zeroclaw/config.toml
    sed -i "s|\${TAVILY_API_KEY}|${TAVILY_API_KEY}|g" /root/.zeroclaw/config.toml
fi

export ZEROCLAW_OPENROUTER_API_KEY="${OPENROUTER_API_KEY}"
export OPENROUTER_API_KEY="${OPENROUTER_API_KEY}"
export BYNARA_API_KEY="${BYNARA_API_KEY}"
export FREEROUTER_API_KEY="${FREEROUTER_API_KEY}"
export TAVILY_API_KEY="${TAVILY_API_KEY}"

exec zeroclaw daemon -p "${PORT}" --host "[::]"
