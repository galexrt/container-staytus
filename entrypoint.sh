#!/bin/bash

DB_ADAPTER="${DB_ADAPTER:-mysql2}"
DB_POOL="${DB_POOL:-5}"
DB_HOST="${DB_HOST:-127.0.0.1}"
DB_USER="${DB_USER:-staytus}"
DB_PASSWORD="${DB_PASSWORD:-staytus}"
DB_DATABASE="${DB_DATABASE:-staytus}"

cp -f /opt/staytus/config/database.example.yml /opt/staytus/config/database.yml

echo "CREATE DATABASE staytus CHARSET utf8 COLLATE utf8_unicode_ci;" | mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" || true

sed -i "s/adapter:.*/adapter: \"$DB_ADAPTER\"/" /opt/staytus/config/database.yml
sed -i "s|pool:.*|pool: $DB_POOL|" /opt/staytus/config/database.yml
sed -i "s|host:.*|host: \"$DB_HOST\"|" /opt/staytus/config/database.yml
sed -i "s/username:.*/username: \"$DB_USER\"/" /opt/staytus/config/database.yml
sed -i "s|password:.*|password: \"$DB_PASSWORD\"|" /opt/staytus/config/database.yml
sed -i "s|database:.*|database: $DB_DATABASE|" /opt/staytus/config/database.yml

cd /opt/staytus || exit 1

bundle exec rake staytus:build staytus:upgrade

exec bundle exec foreman start
