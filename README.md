# docker-staytus
staytus docker image without mysql server

`docker run -p 80:5000 --name=staytus -e MYSQL_USER="staytus" -e MYSQL_PASSWORD="staytus" quay.io/galexrt/staytus`

## Available Env Vars (from Staytus)

* `STAYTUS_SMTP_HOSTNAME`
* `STAYTUS_SMTP_USERNAME`
* `STAYTUS_SMTP_PASSWORD`

