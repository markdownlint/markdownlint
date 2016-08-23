FROM alpine:3.4

MAINTAINER Mark Harrison <mark@mivok.net>

RUN apk update && \
    apk add --no-cache ruby && \
    gem install --no-rdoc --no-ri mdl && \
    mkdir /data

WORKDIR /data

ENTRYPOINT ["mdl"]
CMD ["--help"]
