````markdown
# DEV_DOC

## Overview

This document explains how to set up, build, launch, and maintain the project as a developer.

The stack contains:
- NGINX
- WordPress
- MariaDB
- Redis
- FTP
- Adminer
- static website
- backup service

---

## Prerequisites

Before starting, make sure the following are installed:

- Docker
- Docker Compose
- GNU Make
- Linux environment

You also need a domain pointing to your local machine in the format:

```text
kamrene.42.fr
````

---

## Project structure

```text
.
├── README.md
├── USER_DOC.md
├── DEV_DOC.md
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
```

---

## Environment setup from scratch

### 1. Create persistent data directories

```bash
mkdir -p /home/kamrene/data/db
mkdir -p /home/kamrene/data/wordpress
```

### 2. Create the `.env` file

Path:

```text
srcs/.env
```

Example:

```env
LOGIN=kamrene
DOMAIN_NAME=kamrene.42.fr

MYSQL_DATABASE=wordpress
MYSQL_USER=wp_user
MYSQL_PASSWORD_FILE=/run/secrets/db_password
MYSQL_ROOT_PASSWORD_FILE=/run/secrets/db_root_password

WP_TITLE=Inception
WP_CREDENTIALS_FILE=/run/secrets/credentials
```

### 3. Create the secret files

Path:

```text
secrets/
```

Required files:

#### `secrets/db_password.txt`

```text
your_database_password
```

#### `secrets/db_root_password.txt`

```text
your_root_password
```

#### `secrets/credentials.txt`

```text
WP_ADMIN_USER=super42
WP_ADMIN_PASSWORD=ChangeMe_Admin
WP_ADMIN_EMAIL=admin@example.com
WP_USER_USER=editor42
WP_USER_PASSWORD=ChangeMe_User
WP_USER_EMAIL=user@example.com
```

---

## Build and launch

### Using the Makefile

From the project root:

```bash
make
```

### Using Docker Compose directly

```bash
cd srcs
docker compose up --build
```

### Run in detached mode

```bash
cd srcs
docker compose up --build -d
```

---

## Stop and cleanup

### Stop containers

```bash
cd srcs
docker compose down
```

### Stop and remove volumes

```bash
cd srcs
docker compose down -v
```

### Rebuild from zero

```bash
cd srcs
docker compose down -v --remove-orphans
docker compose up --build
```

---

## Useful container management commands

### Show running containers

```bash
docker ps
```

### Show all containers

```bash
docker ps -a
```

### Show images

```bash
docker images
```

### Show volumes

```bash
docker volume ls
```

### Show networks

```bash
docker network ls
```

### Read logs

```bash
cd srcs
docker compose logs
```

Or one service:

```bash
docker compose logs nginx
docker compose logs wordpress
docker compose logs mariadb
docker compose logs redis
docker compose logs ftp
docker compose logs adminer
docker compose logs backup
```

### Execute a shell inside a container

```bash
docker exec -it wordpress sh
docker exec -it mariadb sh
docker exec -it nginx sh
```

---

## Data storage and persistence

### Where project data is stored

The project stores persistent data under:

```text
/home/kamrene/data
```

Typical persistent data:

* MariaDB database files
* WordPress website files

### How persistence works

Docker volumes are used so that data remains available even if containers are stopped, removed, or rebuilt.

This is important for:

* keeping the WordPress files
* keeping the MariaDB database
* avoiding data loss after rebuilding containers

### Backup service

The backup service mounts:

* the WordPress volume as source
* a separate backup volume as destination

It uses `rsync` to copy the WordPress files into the backup volume.

This provides a second copy of the website files.

---

## Notes for developers

### NGINX

* serves HTTPS
* uses TLSv1.2 / TLSv1.3 only
* is the only public entrypoint for the mandatory part

### WordPress

* installs itself on first launch
* reads credentials from secrets
* connects to MariaDB
* can be extended with Redis cache

### MariaDB

* initializes the database on first start
* stores persistent database data

### Redis

* used for WordPress caching

### FTP

* points to the same WordPress volume

### Adminer

* connects to MariaDB over the Docker network

### Static website

* separate service without PHP

### Backup service

* chosen as the useful extra service
* uses `rsync` to synchronize WordPress files

---

## Summary

A developer needs to know:

* how to prepare `.env` and secrets
* how to create persistent host directories
* how to build and launch with `make` or Docker Compose
* how to inspect containers, logs, volumes, and networks
* where the data is stored and how it persists

```
```

