FROM alpine:3.11.3
RUN echo "mdl:x:1001:mdl" >> /etc/group && \
    echo "mdl:x:1001:1001:mdl,,,:/home/mdl:/sbin/nologin" >> /etc/passwd && \
    apk add --no-cache ruby && \
    gem install mdl && \
    mkdir /data
WORKDIR /data
USER mdl:mdl
ENTRYPOINT ["mdl"]
CMD ["--help"]
