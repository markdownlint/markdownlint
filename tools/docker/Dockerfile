FROM alpine:3.11.3
# We don't directly require 'etc' - but as of recently something we
# do requires 'etc'... and in builds of ruby on nearly any distro that
# seems to be part of core ruby... but in alpine it seems to not be there.
# So we will statically list it here.
# However, etc builds local bindings, which means you *also* need a long
# list of build tools
RUN adduser -h /home/mdl -s /sbin/nologin -D -g mdl mdl && \
    apk add --update --no-cache ruby-dev cmake gcc libtool g++ make && \
    gem install etc mdl --no-document && \
    mkdir /data
WORKDIR /data
USER mdl:mdl
ENTRYPOINT ["mdl"]
CMD ["--help"]
