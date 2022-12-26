FROM debian:bullseye-slim

ENV CRONICLE_foreground=1
ENV CRONICLE_echo=1
ENV CRONICLE_color=1
ENV EDITOR=vi
ENV MODE=master

RUN apt update && apt install -y tini curl git

RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -

RUN apt install nodejs

RUN git clone https://github.com/cronicle-edge/cronicle-edge.git /opt/cronicle

WORKDIR /opt/cronicle

RUN npm install

RUN node bin/build dist

COPY run.sh /

RUN chmod +x /run.sh

#RUN ln -sf /dev/stdout /opt/cronicle/logs/Cronicle.log

EXPOSE 3012

ENTRYPOINT ["/usr/bin/tini", "--"]

CMD [ "/run.sh" ]