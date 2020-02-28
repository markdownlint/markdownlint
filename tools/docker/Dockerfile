FROM alpine:3.11.3
RUN echo "mdl:x:1000:mdl" >> /etc/group && \
    echo "mdl:x:1000:1000:mdl,,,:/home/mdl:/sbin/nologin" >> /etc/passwd && \
    apk add --update --no-cache \
    ruby && \
    gem install mdl && \
    mkdir /data
WORKDIR /data
USER mdl:mdl
ENTRYPOINT ["mdl"]
CMD ["--help"]
