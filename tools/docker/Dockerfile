FROM alpine:3.11.3
# Standard library gems used by markdownlint, such as 'etc' and 'json', are
# not installed by default in Alpine Linux distros, since the current policy
# is to have small packages with extra functionality (standard library
# included) delivered in individual subpackages. The solution is to install
# ruby + standard library via the 'ruby-full' package.
RUN adduser -h /home/mdl -s /sbin/nologin -D -g mdl mdl && \
    apk add --update --no-cache ruby-full && \
    gem install mdl --no-document && \
    mkdir /data
WORKDIR /data
USER mdl:mdl
ENTRYPOINT ["mdl"]
CMD ["--help"]
