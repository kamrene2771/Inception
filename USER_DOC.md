````markdown
# USER_DOC

## Overview

This project provides a Docker-based web infrastructure composed of several services.

### Main services

- **NGINX**  
  The public entrypoint of the stack. It serves the website over HTTPS.

- **WordPress**  
  The main website application.

- **MariaDB**  
  The database used by WordPress.

### Bonus services

- **Redis**  
  Used for WordPress cache.

- **FTP**  
  Gives access to the WordPress files through FTP.

- **Adminer**  
  A web interface to inspect and manage the MariaDB database.

- **Static website**  
  A simple website without PHP.

- **Backup service**  
  Creates a backup copy of the WordPress files using `rsync`.

---

## What services are provided by the stack

The stack provides:

- a secure WordPress website served with HTTPS through NGINX
- a MariaDB database for WordPress
- Redis caching for better WordPress performance
- FTP access to the WordPress files
- Adminer to inspect and manage the database
- a separate static website without PHP
- a backup service that copies the WordPress files into a backup volume

---

## Start and stop the project

All commands below are run from the root of the repository unless stated otherwise.

### Start the project

```bash
make
````

Or manually:

```bash
cd srcs
docker compose up --build
```

### Start in detached mode

```bash
cd srcs
docker compose up --build -d
```

### Stop the project

```bash
cd srcs
docker compose down
```

### Stop the project and remove volumes

```bash
cd srcs
docker compose down -v
```

---

## Access the website and administration panel

### Main website

Open in a browser:

```text
https://kamrene.42.fr
```

Because the SSL certificate is self-signed, the browser may display a warning. This is expected.

You can also test with:

```bash
curl -k https://kamrene.42.fr
```

### WordPress administration panel

Open:

```text
https://kamrene.42.fr/wp-admin
```

Use the administrator credentials stored in:

```text
secrets/credentials.txt
```

### Adminer

Open:

```text
http://kamrene.42.fr:8081
```

Use the following values:

* **System:** MySQL
* **Server:** `mariadb`
* **Username:** your MariaDB user
* **Password:** your database password
* **Database:** `wordpress`

### FTP access

Connect with an FTP client using:

* **Host:** `kamrene.42.fr`
* **Port:** `21`
* **Username:** your FTP username
* **Password:** your FTP password

The FTP service points to the same volume used by WordPress, so FTP file operations affect the website files directly.

---

## Locate and manage credentials

Credentials are stored locally in the `secrets/` directory at the root of the project.

### Credential files

* `secrets/db_password.txt`
  Password for the MariaDB user

* `secrets/db_root_password.txt`
  MariaDB root password

* `secrets/credentials.txt`
  WordPress users and passwords

### Example `credentials.txt`

```text
WP_ADMIN_USER=super42
WP_ADMIN_PASSWORD=ChangeMe_Admin
WP_ADMIN_EMAIL=admin@example.com
WP_USER_USER=editor42
WP_USER_PASSWORD=ChangeMe_User
WP_USER_EMAIL=user@example.com
```

### Important notes

* These files must stay local.
* They must not be pushed to the repository.
* Passwords should be changed to secure values before use.

---

## Check that the services are running correctly

### Show running containers

```bash
docker ps
```

### Show all containers

```bash
docker ps -a
```

### Show logs for all services

```bash
cd srcs
docker compose logs
```

### Show logs for a specific service

```bash
docker compose logs nginx
docker compose logs wordpress
docker compose logs mariadb
docker compose logs redis
docker compose logs ftp
docker compose logs adminer
docker compose logs backup
```

### Check the main website

```bash
curl -k https://kamrene.42.fr
```

If the website returns HTML, NGINX and WordPress are reachable.

### Check Redis

```bash
docker exec -it redis redis-cli ping
```

Expected result:

```text
PONG
```

### Check Adminer

Open in a browser:

```text
http://kamrene.42.fr:8081
```

If the page loads, Adminer is running.

### Check FTP

Try connecting with an FTP client to:

* Host: `kamrene.42.fr`
* Port: `21`

If login works, the FTP service is running.

### Check the backup service

```bash
docker exec -it backup sh
ls /backup
```

If WordPress files appear in `/backup`, the backup service is working.

### Check TLS versions

```bash
openssl s_client -connect kamrene.42.fr:443 -tls1_2
openssl s_client -connect kamrene.42.fr:443 -tls1_3
openssl s_client -connect kamrene.42.fr:443 -tls1_1
openssl s_client -connect kamrene.42.fr:443 -tls1
```

Expected behavior:

* TLS 1.2 works
* TLS 1.3 works
* TLS 1.1 fails
* TLS 1.0 fails

---

## Quick summary

As a user or administrator, the most important things to know are:

* use `make` to start the project
* access the main website at `https://kamrene.42.fr`
* access WordPress admin at `https://kamrene.42.fr/wp-admin`
* access Adminer at `http://kamrene.42.fr:8081`
* credentials are stored in the local `secrets/` directory
* use `docker ps`, logs, Redis checks, FTP access, and backup checks to confirm the services are working correctly

```
```

