#!/bin/bash

DB_ADAPTER="${DB_ADAPTER:-mysql2}"
DB_POOL="${DB_POOL:-5}"
DB_HOST="${DB_HOST:-127.0.0.1}"
DB_USER="${DB_USER:-staytus}"
DB_DATABASE="${DB_DATABASE:-staytus}"

echo "CREATE DATABASE staytus CHARSET utf8 COLLATE utf8_unicode_ci" | mysql -u root -p$DB_PASSWORD || true

if [ ! -z "$DB_ADAPTER" ]; then
    sed -i "s/adapter:.*/adapter: \"$DB_ADAPTER\"/" /opt/staytus/config/database.yml
fi
if [ ! -z "$DB_POOL" ]; then
    sed -i "s|pool:.*|pool: $DB_POOL|" /opt/staytus/config/database.yml
fi
if [ -z "$DB_HOST" ]; then
    sed -i "s|host:.*|host: \"$DB_HOST\"|" /opt/staytus/config/database.yml
fi
if [ ! -z "$DB_USER" ]; then
    sed -i "s/username:.*/username: \"$DB_USER\"/" /opt/staytus/config/database.yml
fi
if [ ! -z "$DB_PASSWORD" ]; then
    sed -i "s|password:.*|password: \"$DB_PASSWORD\"|" /opt/staytus/config/database.yml
fi
if [ ! -z "$DB_DATABASE" ]; then
    sed -i "s|database:.*|database: $DB_DATABASE|" /opt/staytus/config/database.yml
fi

bundle exec rake staytus:build staytus:upgrade

exec bundle exec foreman start
