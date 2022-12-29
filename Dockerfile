FROM alpine:latest

ENV CRONICLE_foreground=1
ENV CRONICLE_echo=1
ENV CRONICLE_color=1
ENV EDITOR=vi
ENV MODE=manager

#RUN apt update && apt install -y tini curl git procps

RUN apk update && apk add bash tini git procps nodejs npm

RUN git clone https://github.com/cronicle-edge/cronicle-edge.git /opt/cronicle

WORKDIR /opt/cronicle

RUN npm install

RUN node bin/build dist

COPY run.sh /

RUN chmod +x /run.sh

RUN mkdir /config

RUN adduser --disabled-password --no-create-home cronicle

#RUN ln -sf /dev/stdout /opt/cronicle/logs/Cronicle.log

EXPOSE 3012

ENTRYPOINT ["/sbin/tini", "--"]

CMD [ "/run.sh" ]