FROM ubuntu:16.04

ARG BUILD_DATE="N/A"
ARG REVISION="N/A"

ARG STAYTUS_VERSION="stable"
ARG TZ="UTC"

LABEL org.opencontainers.image.authors="Alexander Trost <galexrt@googlemail.com>" \
    org.opencontainers.image.created="${BUILD_DATE}" \
    org.opencontainers.image.title="galexrt/container-staytus" \
    org.opencontainers.image.description="[adamcooke/staytus](https://github.com/adamcooke/staytus) as a Docker image without the MySQL server." \
    org.opencontainers.image.documentation="https://github.com/galexrt/container-staytus/blob/main/README.md" \
    org.opencontainers.image.url="https://github.com/galexrt/container-staytus" \
    org.opencontainers.image.source="https://github.com/galexrt/container-staytus" \
    org.opencontainers.image.revision="${REVISION}" \
    org.opencontainers.image.vendor="galexrt" \
    org.opencontainers.image.version="${STAYTUS_VERSION}"

ENV TZ="${TZ}" TINI_VERSION="v0.19.0"

ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini

RUN chmod +x /tini && \
    apt-get -q update && \
    DEBIAN_FRONTEND="noninteractive" apt-get -q install -y tzdata ruby ruby-dev ruby-json \
        nodejs git build-essential libmysqlclient-dev mysql-client && \
    ln -fs "/usr/share/zoneinfo/${TZ}" /etc/localtime && \
    gem update --system && \
    gem install bundler:1.13.6 procodile json:1.8.3 && \
    mkdir -p /opt/staytus && \
    useradd -r -d /opt/staytus -m -s /bin/bash staytus && \
    chown staytus:staytus /opt/staytus && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

USER staytus

RUN git clone https://github.com/adamcooke/staytus.git /opt/staytus/staytus && \
    cd /opt/staytus/staytus && \
    git checkout "${STAYTUS_VERSION}" && \
    bundle install --deployment --without development:test

EXPOSE 8787

ENTRYPOINT ["/tini", "--", "/usr/local/bin/entrypoint.sh"]
