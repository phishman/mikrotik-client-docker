FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive
ENV MIKROTIK_HOST=
ENV MIKROTIK_USER=
ENV MIKROTIK_PASSWORD=
ENV MIKROTIK_SSH_KEY=

ENV SCRIPT_DIR /usr/local/bin
ENV SSH_DIR /root/.ssh
ENV KEY_DIR /keys

RUN apt-get update && \
    apt-get install -y ssh sshpass && \
    rm -rf /var/lib/apt/lists/*

COPY config/ssh-config /root/.ssh/config
COPY scripts/query $SCRIPT_DIR/query
RUN chmod +x $SCRIPT_DIR/query

VOLUME ["/keys"]