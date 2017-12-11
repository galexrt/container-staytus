FROM ruby
MAINTAINER Tim Perry <pimterry@gmail.com>

USER root

ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get -q update && \
    apt-get -q install -y nodejs libgmp3-dev mysql-client && \
    mkdir -p /opt/staytus && \
    git clone https://github.com/adamcooke/staytus.git /opt/staytus && \
    cd /opt/staytus && \
    git checkout stable && \
    bundle update json && \
    bundle install --deployment --without development:test && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY entrypoint.sh /entrypoint.sh

EXPOSE 5000

ENTRYPOINT "/entrypoint.sh"
