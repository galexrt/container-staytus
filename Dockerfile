FROM ubuntu:16.04
LABEL maintainer="Alexander Trost <galexrt@googlemail.com>"

ENV DEBIAN_FRONTEND="noninteractive" STAYTUS_VERSION="stable" TZ="Etc/UTC" TINI_VERSION="v0.18.0"

ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini

RUN chmod +x /tini && \
    apt-get -q update && \
    apt-get -q install -y tzdata ruby ruby-dev ruby-json nodejs git build-essential libmysqlclient-dev mysql-client && \
    ln -fs "/usr/share/zoneinfo/${TZ}" /etc/localtime && \
    gem update --system && \
    gem install bundler procodile && \
    mkdir -p /opt/staytus && \
    useradd -r -d /opt/staytus -m -s /bin/bash staytus && \
    chown staytus:staytus /opt/staytus && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER staytus

RUN git clone https://github.com/adamcooke/staytus.git /opt/staytus/staytus && \
    cd /opt/staytus/staytus && \
    git checkout "${STAYTUS_VERSION}" && \
    bundle install --deployment --without development:test

USER root

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

USER staytus

EXPOSE 8787

ENTRYPOINT ["/tini", "--", "/usr/local/bin/entrypoint.sh"]
