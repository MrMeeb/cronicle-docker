FROM alpine:latest as base
ARG TARGETARCH

FROM base AS base-amd64
ENV S6_OVERLAY_ARCH=x86_64

FROM base AS base-arm64
ENV S6_OVERLAY_ARCH=aarch64

FROM base-${TARGETARCH}${TARGETVARIANT}

ARG S6_OVERLAY_VERSION=3.1.5.0
ARG CRONICLE_EDGE_VERSION=.1.6.3

ENV CRONICLE_foreground=1
ENV CRONICLE_echo=1
ENV CRONICLE_color=1
ENV EDITOR=nano
ENV MODE=manager
ENV PUID=1000
ENV PGID=1000
ENV TZ=UTC
ENV LOG_LEVEL=9

#Get required packages
RUN apk update && apk add --no-cache tzdata curl shadow bash xz git procps nodejs npm nano openssl ca-certificates

#Make folders
RUN mkdir /config && \
    mkdir /app && \
#Create default user
    useradd -u 1000 -U -d /config -s /bin/false cronicle && \
    usermod -G users cronicle

#Install s6-overlay
RUN curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz" | tar Jpxf - -C / && \
    curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${S6_OVERLAY_ARCH}.tar.xz" | tar Jpxf - -C / && \
    curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-noarch.tar.xz" | tar Jpxf - -C / && \
    curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-arch.tar.xz" | tar Jpxf - -C /
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2 S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0 S6_VERBOSITY=1

#Install Cronicle & tidy up things I don't want
RUN apk add --no-cache --virtual .jq jq && \
    mkdir /app/cronicle && \
    cd /app/cronicle && \
    wget https://github.com/cronicle-edge/cronicle-edge/archive/refs/tags/v${CRONICLE_EDGE_VERSION}.tar.gz && \
    tar -xf v${CRONICLE_EDGE_VERSION}.tar.gz --strip-components 1 && \
    rm -rf Docker* .gitignore Readme.md .vscode sample_conf/examples/backup sample_conf/examples/docker.sh && \
    jq 'del(.storage[] | select(contains(["global/conf_keys"])))' sample_conf/setup.json >> sample_conf/setup-new.json && \
    rm sample_conf/setup.json && \
    mv sample_conf/setup-new.json sample_conf/setup.json && \
    rm -rf v${CRONICLE_EDGE_VERSION}.tar.gz && \
    apk del .jq

WORKDIR /app/cronicle
RUN npm install && \
    node bin/build dist

COPY root/ /
RUN chmod +x /cronicle-prepare.sh && \
    chmod +x /container-init.sh && \
    chown -R ${PUID}:${PGID} /app /config

EXPOSE 3012
EXPOSE 3013

ENTRYPOINT [ "/init" ]