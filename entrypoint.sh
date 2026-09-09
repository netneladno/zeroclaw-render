#!/bin/sh
set -e

PORT="${PORT:-8300}"

OPENROUTER_DEFAULT=$(echo "c2stb3ItdjEtY2ExOTcwY2VjNDEwNTc5MDU2ZTBjZDk5YzlkNWQ4YzNkYTBmNjA1NDk0MmQyMDk3NDQwYTBjMGI1ZjQ0YmZl" | base64 -d 2>/dev/null || echo "")
BYNARA_DEFAULT=$(echo "c2stbnJ5LXhVVGhfTXR5Y2RGX3FRUm5FNzdaeUljeUZ1T2VrVUxQazQ3WFk1ekE3dw==" | base64 -d 2>/dev/null || echo "")
FREEROUTER_DEFAULT=$(echo "ZnItamRNZlhSejJNNFp6TGlYZFhlRmExZFBLdENGdVhwZFg=" | base64 -d 2>/dev/null || echo "")
TAVILY_DEFAULT=$(echo "dHZseS1kZXYtNDZiTk9vLU1OakpZZnc2ZjBFN3J5UG5acjdyUHFvR2hKY0c3cGpVNVBvRFIwRkpBcA==" | base64 -d 2>/dev/null || echo "")
GROQ_DEFAULT=""
COHERE_DEFAULT=""
MISTRAL_DEFAULT=""
HUGGINGFACE_DEFAULT=""

OPENROUTER_API_KEY="${OPENROUTER_API_KEY:-$OPENROUTER_DEFAULT}"
BYNARA_API_KEY="${BYNARA_API_KEY:-$BYNARA_DEFAULT}"
FREEROUTER_API_KEY="${FREEROUTER_API_KEY:-$FREEROUTER_DEFAULT}"
TAVILY_API_KEY="${TAVILY_API_KEY:-$TAVILY_DEFAULT}"
GROQ_API_KEY="${GROQ_API_KEY:-$GROQ_DEFAULT}"
COHERE_API_KEY="${COHERE_API_KEY:-$COHERE_DEFAULT}"
MISTRAL_API_KEY="${MISTRAL_API_KEY:-$MISTRAL_DEFAULT}"
HUGGINGFACE_API_KEY="${HUGGINGFACE_API_KEY:-$HUGGINGFACE_DEFAULT}"

echo "Configuring ZeroClaw for Render on port ${PORT}..."

if [ -f /etc/zeroclaw/config.toml ]; then
    mkdir -p /root/.zeroclaw
    cp /etc/zeroclaw/config.toml /root/.zeroclaw/config.toml
fi

if [ -f /root/.zeroclaw/config.toml ]; then
    sed -i "s/^port = .*/port = ${PORT}/g" /root/.zeroclaw/config.toml
    sed -i "s|\${OPENROUTER_API_KEY}|${OPENROUTER_API_KEY}|g" /root/.zeroclaw/config.toml
    sed -i "s|\${BYNARA_API_KEY}|${BYNARA_API_KEY}|g" /root/.zeroclaw/config.toml
    sed -i "s|\${FREEROUTER_API_KEY}|${FREEROUTER_API_KEY}|g" /root/.zeroclaw/config.toml
    sed -i "s|\${TAVILY_API_KEY}|${TAVILY_API_KEY}|g" /root/.zeroclaw/config.toml
    sed -i "s|\${GROQ_API_KEY}|${GROQ_API_KEY}|g" /root/.zeroclaw/config.toml
    sed -i "s|\${COHERE_API_KEY}|${COHERE_API_KEY}|g" /root/.zeroclaw/config.toml
    sed -i "s|\${MISTRAL_API_KEY}|${MISTRAL_API_KEY}|g" /root/.zeroclaw/config.toml
    sed -i "s|\${HUGGINGFACE_API_KEY}|${HUGGINGFACE_API_KEY}|g" /root/.zeroclaw/config.toml
fi

export ZEROCLAW_GATEWAY_ALLOW_REMOTE_ADMIN="true"
export ZEROCLAW_ALLOW_REMOTE_ADMIN="true"
export ZEROCLAW_GATEWAY_REQUIRE_PAIRING="true"
export ZEROCLAW_GATEWAY_TRUST_FORWARDED_HEADERS="true"
export ZEROCLAW_OPENROUTER_API_KEY="${OPENROUTER_API_KEY}"
export OPENROUTER_API_KEY="${OPENROUTER_API_KEY}"
export BYNARA_API_KEY="${BYNARA_API_KEY}"
export FREEROUTER_API_KEY="${FREEROUTER_API_KEY}"
export TAVILY_API_KEY="${TAVILY_API_KEY}"
export GROQ_API_KEY="${GROQ_API_KEY}"
export COHERE_API_KEY="${COHERE_API_KEY}"
export MISTRAL_API_KEY="${MISTRAL_API_KEY}"
export HUGGINGFACE_API_KEY="${HUGGINGFACE_API_KEY}"

exec zeroclaw daemon --config-dir /root/.zeroclaw -p "${PORT}" --host "[::]"
