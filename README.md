# docker-staytus
[![](https://images.microbadger.com/badges/image/galexrt/staytus.svg)](https://microbadger.com/images/galexrt/staytus "Get your own image badge on microbadger.com")

[![Docker Repository on Quay.io](https://quay.io/repository/galexrt/staytus/status "Docker Repository on Quay.io")](https://quay.io/repository/galexrt/staytus)

Image available from:
* [**Quay.io**](https://quay.io/repository/galexrt/staytus)
* [**Docker Hub**](https://hub.docker.com/r/galexrt/staytus)

[adamcooke/staytus](https://github.com/adamcooke/staytus) as a Docker image without the MySQL server.

## Usage
### Pulling the image
From quay.io:
```
docker pull quay.io/galexrt/staytus:latest
```
Or from Docker Hub:
```
docker pull galexrt/staytus:latest
```

### Running Staytus
For the Docker Staytus image to work, you'll need to start a MySQL server (or container).
The commands below start a MariaDB and the starts the Staytus container with the link to the database container.
```
docker run \
    -d \
    --name staytus-mariadb \
    -e MYSQL_ROOT_PASSWORD=my-secret-pw \
    -e MYSQL_DATABASE=staytus \
    -e MYSQL_USER=staytus \
    -e MYSQL_PASSWORD=staytus \
    mariadb:latest
```
With link to the MariaDB database container:
```
docker run \
    --link=mariadb:mysql \
    -p 5000:5000 \
    --name=staytus \
    -e 'DB_HOST=mysql' \
    -e 'DB_USER=staytus' \
    -e 'DB_PASSWORD=staytus' \
    quay.io/galexrt/staytus
```
After running the commands, open `YOUR_IP:5000` (or the server IP) in your browser to run the setup for your containerized Staytus instance.

### Available Env Vars
#### Database Configuration
Database setup instructions here https://github.com/adamcooke/staytus#instructions

You can add the following variables as env vars to your Docker run command:
* `DB_ADAPTER` (Default: `mysql2`)
* `DB_POOL` (Default: `5`)
* `DB_HOST` (Default: `127.0.0.1`)
* `DB_DATABASE` (Default: `staytus`)
* `DB_USER` (Default: `staytus`)
* `DB_PASSWORD` (Default: empty)

#### SMTP Configuration (from Staytus)
You can add the following variables as env vars to your Docker run command:
* `STAYTUS_SMTP_HOSTNAME`
* `STAYTUS_SMTP_USERNAME`
* `STAYTUS_SMTP_PASSWORD`
