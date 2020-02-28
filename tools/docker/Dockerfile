FROM ruby:2.7.0-alpine3.11
RUN echo "mdl:x:1000:mdl" >> /etc/group && \
    echo "mdl:x:1000:1000:mdl,,,:/home/mdl:/sbin/nologin" >> /etc/passwd && \
    gem install mdl && \
    mkdir /data
WORKDIR /data
USER mdl:mdl
ENTRYPOINT ["mdl"]
CMD ["--help"]
