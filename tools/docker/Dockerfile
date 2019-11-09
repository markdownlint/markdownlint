FROM alpine:3.5

MAINTAINER Mark Harrison <mark@mivok.net>

RUN apk add --no-cache ruby && \
    gem install --no-rdoc --no-ri mdl && \
    mkdir /data

WORKDIR /data

ENTRYPOINT ["mdl"]
CMD ["--help"]
