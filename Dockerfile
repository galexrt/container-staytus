FROM ruby
MAINTAINER Tim Perry <pimterry@gmail.com>

USER root

ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get update && \
    # Instal node as the JS engine for uglifier
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    mkdir -p /opt/staytus && \
    git clone https://github.com/adamcooke/staytus.git /opt/staytus && \
    cd /opt/staytus && \
    bundle install --deployment --without development:test

# Persists copies of other relevant files (DB config, custom themes). Contents of this are copied 
# to the relevant places each time the container is started
VOLUME /opt/staytus/persisted

ENTRYPOINT /opt/staytus/docker-start.sh

EXPOSE 5000
