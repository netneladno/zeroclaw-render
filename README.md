# ZeroClaw on Render

This repository contains the setup for deploying [ZeroClaw](https://github.com/zeroclaw-labs/zeroclaw) AI Agent Gateway on Render Free Tier.

## Included Files
- `Dockerfile`: Multi-stage / debian-based container setup pulling `ghcr.io/zeroclaw-labs/zeroclaw:debian`
- `config.toml`: Preconfigured ZeroClaw runtime settings with OpenRouter, Bynara, freeRouter, Tavily web search, and YOLO risk profile
- `entrypoint.sh`: Entrypoint script that binds to Render's dynamic `$PORT`
- `render.yaml`: Render Blueprint configuration

## Deployment
Connect this repository to Render as a Web Service or Blueprint.
