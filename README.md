# container-staytus

[adamcooke/staytus](https://github.com/adamcooke/staytus) as a Container Image without the MySQL server.

Image available from:

* [Quay.io](https://quay.io/repository/galexrt/staytus)
* [GHCR.io](https://github.com/galexrt/container-staytus/pkgs/container/staytus)
* [**DEPRECATED** Docker Hub](https://hub.docker.com/r/galexrt/staytus)
  * Docker Hub has been deprecated as of **18.09.2021**!

Container Image Tags:

* `main` - Latest build of the `main` branch.
* `vx.y.z` - Latest build of the application (updated in-sync with the date container image tags).
* `vx.y.z-YYYYmmdd-HHMMSS-NNN` - Latest build of the application with date of the build.

## Usage

### Pulling the image

From Quay.io:

```console
docker pull quay.io/galexrt/staytus:main
```
Or from GHCR.io:

```console
docker pull ghcr.io/galexrt/staytus:main
```

### Running Staytus

For the Docker Staytus image to work, you'll need to start a MySQL server (or container).
The commands below creates a network, start a MariaDB and then starts the Staytus container.

Create the separate network for Staytus and database:

```console
docker network create staytus
```

Start the MariaDB database container:

```console
docker run \
    -d \
    --name=database \
    --net=staytus \
    -e MYSQL_ROOT_PASSWORD=my-secret-pw \
    -e MYSQL_DATABASE=staytus \
    -e MYSQL_USER=staytus \
    -e MYSQL_PASSWORD=staytus \
    mariadb:10.4.4-bionic
```

Start the Staytus container with the environment variables pointing to the created `database` container.

```console
docker run \
    -d \
    --name=staytus \
    --net=staytus \
    -p 8787:8787 \
    -e 'DB_HOST=database' \
    -e 'DB_USER=staytus' \
    -e 'DB_PASSWORD=staytus' \
    quay.io/galexrt/staytus:main
```

After running the commands, open `127.0.0.1:8787`, `YOUR_IP:8787` (or the server IP when Docker is running on a server) in your browser to run the setup for your containerized Staytus instance.

#### Manual configuration

If you want to manually configure Staytus, you can point a volume to `/opt/staytus/staytus/config/`  and put the `database.yaml` config in that volume yourself.

```console
docker run \
[...]
    -e 'AUTO_CONF=false' \
    -v /opt/docker/staytus/config:/opt/staytus/staytus/config:ro \
    [...]
    quay.io/galexrt/staytus:lastest
```

### Available Env Vars

#### Database Configuration

> **NOTE**
>
> TL;DR Create a database with `CHARSET utf8mb4` and `COLLATE utf8mb4_unicode_ci`.
>
> Database setup instructions here https://github.com/adamcooke/staytus#instructions

You can add the following variables as env vars to your Docker run command:

* `AUTO_CONF` (Default: `true`) - Enable or disable the `database.yaml` configuration, based on the upcoming `DB_*` variables.
* `DB_ADAPTER` (Default: `mysql2`)
* `DB_POOL` (Default: `5`)
* `DB_HOST` (Default: `database`)
* `DB_DATABASE` (Default: `staytus`)
* `DB_USER` (Default: `staytus`)
* `DB_PASSWORD` (Default: empty)

#### SMTP Configuration (from Staytus)

You can add the following variables as env vars to your Docker run command:

* `STAYTUS_SMTP_HOSTNAME`
* `STAYTUS_SMTP_USERNAME`
* `STAYTUS_SMTP_PASSWORD`
