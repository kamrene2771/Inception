#!/bin/bash
set -e

: "${WP_CREDENTIALS_FILE:?Missing WP_CREDENTIALS_FILE}"

FTP_USER="$(grep '^FTP_USER=' "$WP_CREDENTIALS_FILE" | cut -d= -f2-)"
FTP_PASSWORD="$(grep '^FTP_PASSWORD=' "$WP_CREDENTIALS_FILE" | cut -d= -f2-)"

useradd -m -d /var/www/html "$FTP_USER" || true
echo "$FTP_USER:$FTP_PASSWORD" | chpasswd

mkdir -p /var/run/vsftpd/empty

exec /usr/sbin/vsftpd /etc/vsftpd.conf
