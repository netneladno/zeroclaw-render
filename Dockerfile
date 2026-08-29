FROM ghcr.io/zeroclaw-labs/zeroclaw:debian

USER root
WORKDIR /root

RUN mkdir -p /root/.zeroclaw

COPY config.toml /root/.zeroclaw/config.toml
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 8300

ENTRYPOINT ["/entrypoint.sh"]
