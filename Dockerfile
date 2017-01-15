FROM ruby
MAINTAINER Tim Perry <pimterry@gmail.com>

USER root

ENV DEBIAN_FRONTEND="noninteractive"

ADD entrypoint.sh /entrypoint.sh

RUN chmod 755 entrypoint.sh && \
    apt-get update && \
    # Instal node as the JS engine for uglifier
    apt-get install -y nodejs libgmp3-dev

RUN mkdir -p /opt/staytus && \
    git clone https://github.com/adamcooke/staytus.git /opt/staytus && \
    cd /opt/staytus && \
    bundle update json && \
    bundle install --deployment --without development:test

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT "/entrypoint.sh"

EXPOSE 5000
