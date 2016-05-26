# docker-staytus
staytus docker image without mysql server

`docker run -p 80:5000 --name=staytus -e MYSQL_USER="staytus" -e MYSQL_PASSWORD="staytus" quay.io/galexrt/staytus`

## Available Env Vars (from Staytus)

### DB Configuration:
Database setup instructions here https://github.com/adamcooke/staytus#instructions

* `DB_ADAPTER` (Default: `mysql2`)
* `DB_POOL` (Default: `5`)
* `DB_HOST` (Default: `127.0.0.1`)
* `DB_DATABASE` (Default: `staytus`)
* `DB_USER` (Default: `staytus`)
* `DB_PASSWORD` (Default: empty)

### SMTP Configuration:
* `STAYTUS_SMTP_HOSTNAME`
* `STAYTUS_SMTP_USERNAME`
* `STAYTUS_SMTP_PASSWORD`

