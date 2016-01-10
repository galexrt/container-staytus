#!/bin/bash

cd /opt/staytus

if [ ! -f /opt/staytus/persisted/config/database.yml ]; then
  mysql -u "$MYSQL_USER" -p "$MYSQL_PASSWORD"
  echo "CREATE DATABASE staytus CHARSET utf8 COLLATE utf8_unicode_ci" | mysql -u root -p$RANDOM_PASSWORD

  cp -f /opt/staytus/config/database.example.yml /opt/staytus/config/database.yml
  sed -i "s/username:.*/username: $MYSQL_USER/" /opt/staytus/config/database.yml
  sed -i "s|password:.*|password: $MYSQL_PASSWORD|" /opt/staytus/config/database.yml

  # Copy the config to persist it, and later copy back on each start, to persist this config file 
  # without persisting all of /config (which is mostly app code)
  mkdir /opt/staytus/persisted/config
  cp -f /opt/staytus/config/database.yml /opt/staytus/persisted/config/database.yml

  bundle exec rake staytus:build staytus:install
else
  # Use the previously saved config from the persisted volume
  cp -f /opt/staytus/persisted/config/database.yml config/database.yml
  # TODO also copy themes back and forth too
 
  # If already configured, check if there are any migrations to run
  bundle exec rake staytus:build staytus:upgrade
fi

bundle exec foreman start
