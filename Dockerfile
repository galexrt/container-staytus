FROM ruby
MAINTAINER Tim Perry <pimterry@gmail.com>

USER root

ENV DEBIAN_FRONTEND="noninteractive"

ADD docker-start.sh /docker-start.sh
ADD . /opt/staytus/

RUN chmod 755 docker-start.sh && \
    apt-get update && \
    # Instal node as the JS engine for uglifier
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    cd /opt/staytus && \
    bundle install --deployment --without development:test

ENTRYPOINT "/docker-start.sh"

EXPOSE 5000
