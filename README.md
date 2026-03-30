*This project has been created as part of the 42 curriculum by kamrene.*

# Inception

## Description

Inception is a system administration and Docker project from the 42 curriculum.  
The goal of the project is to build a small infrastructure composed of several isolated
services running in separate Docker containers and orchestrated with Docker Compose.

The mandatory part of the project includes:
- NGINX as the only public entrypoint
- WordPress with php-fpm
- MariaDB

The infrastructure must expose only port 443 through NGINX and use TLSv1.2 or TLSv1.3.
Environment variables must be stored in a `.env` file, and passwords must not appear in
Dockerfiles. Persistent data must be stored under `/home/kamrene/data`. Docker
secrets are recommended for confidential information.

In my project, I also implemented the bonus services:
- Redis cache for WordPress
- FTP server pointing to the WordPress volume
- Adminer
- A static website without PHP
- A backup service using rsync for the WordPress files

---

## Instructions

### Prerequisites

You need:
- Docker
- Docker Compose
- a Linux environment
- a domain pointing to your local IP with the format: `kamrene.42.fr`


You also need the host directories for persistent data:


mkdir -p /home/kamrene/data/db
mkdir -p /home/kamrene/data/wordpress


### Project structure
.
├── README.md
├── Makefile
├── secrets/
│   ├── credentials.txt
│   ├── db_password.txt
│   └── db_root_password.txt
└── srcs/
    ├── .env
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/
        ├── nginx/
        ├── wordpress/
        └── bonus/


### Environment variables

`.env`:

LOGIN=kamrene
DOMAIN_NAME=kamrene.42.fr

MYSQL_DATABASE=wordpress
MYSQL_USER=wp_user
MYSQL_PASSWORD_FILE=/run/secrets/db_password
MYSQL_ROOT_PASSWORD_FILE=/run/secrets/db_root_password

WP_TITLE=Inception
WP_CREDENTIALS_FILE=/run/secrets/credentials

### Secrets

`secrets/db_password.txt`
`secrets/db_root_password.txt`
`secrets/credentials.txt`

### Build and run

From the root of the project:

`make up`

To stop everything:

`make down`

Or manually:

`cd srcs`
`docker compose up --build`

To stop everything:

`docker compose down`


To stop and remove volumes:

`docker compose down -v`


To rebuild from zero:

`docker compose down -v --remove-orphans`
`docker compose up --build`

### Access

Main website:

`https://kamrene.42.fr`

Because the certificate is self-signed, the browser will show a warning. This is normal.

Test with curl:

`curl -k https://kamrene.42.fr`

Adminer example:

`http://<kamrene.42.fr:8081`

FTP:

* Host: `kamrene.42.fr`
* Port: `21`

### Useful commands

Show running containers:

`docker ps`

Show logs:

```bash
docker compose logs
docker compose logs nginx
docker compose logs wordpress
docker compose logs mariadb
```

Verify TLS versions:

```bash
openssl s_client -connect <your_login>.42.fr:443 -tls1_2
openssl s_client -connect <your_login>.42.fr:443 -tls1_3
openssl s_client -connect <your_login>.42.fr:443 -tls1_1
openssl s_client -connect <your_login>.42.fr:443 -tls1
```

Expected:

* TLS 1.2 works
* TLS 1.3 works
* TLS 1.1 fails
* TLS 1.0 fails

Check Redis:

`docker exec -it redis redis-cli ping`

Check backup files:

```bash
docker exec -it backup sh
ls /backup
```

---

## Project description

### Why Docker is used

Docker makes it possible to isolate each service in its own container while keeping a
reproducible and portable environment. Each service has its own image, dependencies,
configuration, and role.

In this project, Docker is used to separate:

* NGINX
* WordPress
* MariaDB
* Redis
* FTP
* Adminer
* static website
* backup service

This makes the infrastructure easier to manage, understand, and maintain.

### Sources included in the project

The project includes:

* Dockerfiles for each service
* entrypoint scripts
* NGINX configuration
* Docker Compose configuration
* `.env` file for environment variables
* `secrets/` files for confidential information
* persistent volumes for the database and WordPress files

### Main design choices

The main design choices are:

* NGINX is the only public entrypoint
* only port 443 is exposed publicly for the mandatory part
* WordPress runs with php-fpm
* MariaDB is isolated in its own container
* persistent data is stored in dedicated volumes
* secrets are separated from normal environment variables
* bonus services are each isolated in their own containers

### Virtual Machines vs Docker

A virtual machine emulates a complete operating system with its own kernel and uses more
resources. Docker containers share the host kernel, start faster, and are lighter.

For this project, Docker is more suitable because the objective is to isolate services
efficiently without the overhead of full virtual machines.

### Secrets vs Environment Variables

Environment variables are useful for non-sensitive configuration, such as:

* domain name
* database name
* usernames
* service names

Secrets are better for confidential data, such as:

* passwords
* credentials
* private values

In this project, `.env` is used for general configuration, while secrets are used for
sensitive data.

### Docker Network vs Host Network

A Docker bridge network isolates the containers and lets them communicate using service
names such as `mariadb`, `wordpress`, or `redis`.

Host network mode removes that isolation and makes the container share the host network
directly.

In this project, a Docker bridge network is used because it is cleaner, safer, and
matches the project requirements.

### Docker Volumes vs Bind Mounts

A Docker volume is managed by Docker and is useful for persistent container data.

A bind mount directly maps a host path into a container.

In this project, persistent data is stored under `/home/<your_login>/data`, which makes
the host storage explicit and keeps data available even after rebuilding containers.

### Bonus services

#### Redis

Redis is used as a cache service for WordPress in order to improve performance.

#### FTP

The FTP server points to the same WordPress volume, so FTP access works directly on the
website files.

#### Adminer

Adminer provides a simple web interface to connect to MariaDB and inspect the WordPress
database.

#### Static website

The static website is a separate service built without PHP, as required by the subject.

#### Backup service

The extra useful service chosen for this project is a backup service using `rsync`.

It mounts the WordPress volume as a source and synchronizes it to a separate backup
volume. This is useful because WordPress files are persistent and important, and having
a second copy helps with protection and recovery.

---

## Resources

### Documentation and references

* Docker official documentation
* Docker Compose official documentation
* NGINX official documentation
* MariaDB official documentation
* WordPress official documentation
* Redis official documentation
* Adminer official documentation
* vsftpd documentation
* OpenSSL documentation

### How AI was used

AI was used as a support tool for:

* understanding the project subject
* clarifying Docker concepts
* explaining TLS, self-signed certificates, and NGINX configuration
* helping debug container startup issues
* helping understand Redis, FTP, Adminer, and Docker volumes
* drafting and improving documentation

All generated explanations and suggestions were reviewed, tested, and adjusted during
the implementation of the project.

---

## Author

* Login: kamrene
* Project: Inception
* School: 1337