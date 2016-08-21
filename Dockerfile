FROM phusion/baseimage:0.9.18
MAINTAINER Mikael Kjaer <mikael@teletronics.ae>

# Install dependencies
RUN apt-get clean \
 && apt-get update \
 && apt-get install -y rake ruby git \
 && rm -rf /var/lib/apt/lists/* \
 && gem install bundler

# Install markdownlint - Downloading it from github to make the final image smaller
RUN git clone https://github.com/mivok/markdownlint \
 && cd markdownlint \
 && rake install \
 && cd .. \
 && rm -r markdownlint

RUN mkdir /inputfiles
WORKDIR /inputfiles

ENTRYPOINT [ "mdl" ]
CMD [ "/inputfiles" ]
