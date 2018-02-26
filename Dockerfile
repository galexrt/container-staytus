FROM ubuntu:16.04
LABEL maintainer="Alexander Trost <galexrt@googlemail.com>"

ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get -q update && \
    apt-get -q install -y tzdata ruby ruby-dev nodejs git build-essential libmysqlclient-dev mysql-client && \
    ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    gem install bundler procodile && \
    mkdir -p /opt/staytus && \
    useradd -r -d /opt/staytus -m -s /bin/bash staytus && \
    chown staytus:staytus /opt/staytus && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER staytus

RUN git clone https://github.com/adamcooke/staytus.git /opt/staytus/staytus && \
    cd /opt/staytus/staytus && \
    git checkout stable && \
    bundle install --deployment --without development:test

COPY entrypoint.sh /entrypoint.sh

EXPOSE 8787

ENTRYPOINT "/entrypoint.sh"
