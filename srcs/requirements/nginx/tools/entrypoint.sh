#!/bin/bash
set -e

mkdir -p /etc/ssl/certs /etc/ssl/private

if [ ! -f /etc/ssl/certs/inception.crt ] || [ ! -f /etc/ssl/private/inception.key ]; then
    openssl req -x509 -nodes -days 365 \
        -newkey rsa:2048 \
        -keyout /etc/ssl/private/inception.key \
        -out /etc/ssl/certs/inception.crt \
        -subj "/CN=${DOMAIN_NAME}"
fi

exec nginx -g "daemon off;"
