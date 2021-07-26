FROM alpine:3.14.0

RUN adduser -h /home/mdl -s /sbin/nologin -D -g mdl mdl && \
    apk add --update --no-cache ruby ruby-concurrent-ruby && \
    gem install mdl --no-document

WORKDIR /data
USER mdl:mdl

CMD ["mdl"]

