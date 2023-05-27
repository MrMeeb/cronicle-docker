FROM alpine:latest as base
ARG TARGETARCH

FROM base AS base-amd64
ENV S6_OVERLAY_ARCH=x86_64

FROM base AS base-arm64
ENV S6_OVERLAY_ARCH=aarch64

FROM base-${TARGETARCH}${TARGETVARIANT}

ARG S6_OVERLAY_VERSION=3.1.5.0

ENV CRONICLE_foreground=1
ENV CRONICLE_echo=1
ENV CRONICLE_color=1
ENV EDITOR=vi
ENV MODE=manager
ENV PUID=1000
ENV PGID=1000
ENV TZ=UTC

#Get required packages
RUN apk update && apk add tzdata curl shadow bash xz git procps nodejs npm

#Make folders
RUN mkdir /config && \
    mkdir /app && \
#Create default user
    useradd -u 1000 -U -d /config -s /bin/false mrmeeb && \
    usermod -G users mrmeeb

#Install s6-overlay
RUN curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz" | tar Jpxf - -C / && \
    curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${S6_OVERLAY_ARCH}.tar.xz" | tar Jpxf - -C / && \
    curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-noarch.tar.xz" | tar Jpxf - -C / && \
    curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-arch.tar.xz" | tar Jpxf - -C /
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2 S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0 S6_VERBOSITY=1

#Install Cronicle
RUN git clone https://github.com/cronicle-edge/cronicle-edge.git /app/cronicle
WORKDIR /app/cronicle
RUN npm install && \
    node bin/build dist
RUN rm -rf /app/cronicle/Docker* .vscode

#Create Cronicle user, necessary for SSH plugin with default settings
RUN adduser --disabled-password --no-create-home cronicle

COPY root/ /
RUN chmod +x /cronicle-prepare.sh && \
    chmod +x /container-init.sh

EXPOSE 3012

ENTRYPOINT [ "/init" ]