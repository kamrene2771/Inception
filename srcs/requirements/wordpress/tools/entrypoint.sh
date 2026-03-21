#!/bin/bash
set -e

: "${MYSQL_DATABASE:?Missing MYSQL_DATABASE}"
: "${MYSQL_USER:?Missing MYSQL_USER}"
: "${MYSQL_PASSWORD_FILE:?Missing MYSQL_PASSWORD}"
: "${DOMAIN_NAME:?Missing DOMAIN_NAME}"
: "${WP_TITLE:?Missing WP_TITLE}"
: "${WP_CREDENTIALS_FILE:?Missing WP_CREDENTIALS_FILE}"

MYSQL_PASSWORD="$(cat "$MYSQL_PASSWORD_FILE")"

WP_ADMIN_USER="$(grep '^WP_ADMIN_USER=' "$WP_CREDENTIALS_FILE" | cut -d= -f2-)"
WP_ADMIN_PASSWORD="$(grep '^WP_ADMIN_PASSWORD=' "$WP_CREDENTIALS_FILE" | cut -d= -f2-)"
WP_ADMIN_EMAIL="$(grep '^WP_ADMIN_EMAIL=' "$WP_CREDENTIALS_FILE" | cut -d= -f2-)"

WP_USER_USER="$(grep '^WP_USER_USER=' "$WP_CREDENTIALS_FILE" | cut -d= -f2-)"
WP_USER_PASSWORD="$(grep '^WP_USER_PASSWORD=' "$WP_CREDENTIALS_FILE" | cut -d= -f2-)"
WP_USER_EMAIL="$(grep '^WP_USER_EMAIL=' "$WP_CREDENTIALS_FILE" | cut -d= -f2-)"

: "${WP_ADMIN_USER:?Missing WP_ADMIN_USER in credentials file}"
: "${WP_ADMIN_PASSWORD:?Missing WP_ADMIN_PASSWORD in credentials file}"
: "${WP_ADMIN_EMAIL:?Missing WP_ADMIN_EMAIL in credentials file}"
: "${WP_USER_USER:?Missing WP_USER_USER in credentials file}"
: "${WP_USER_PASSWORD:?Missing WP_USER_PASSWORD in credentials file}"
: "${WP_USER_EMAIL:?Missing WP_USER_EMAIL in credentials file}"

mkdir -p /run/php
cd /var/www/html

until mysql -h mariadb -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "SELECT 1;" >/dev/null 2>&1; do
    sleep 2
done

if [ ! -f wp-config.php ]; then
    wp core download --allow-root

    wp config create --allow-root \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --dbhost="mariadb:3306"

    wp core install --allow-root \
        --url="https://$DOMAIN_NAME" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL"

    wp user create --allow-root \
        "$WP_USER_USER" "$WP_USER_EMAIL" \
        --user_pass="$WP_USER_PASSWORD"

    wp plugin install redis-cache --activate --allow-root
    wp config set WP_REDIS_HOST 'redis' --allow-root
    wp config set WP_REDIS_PORT 6379 --raw --allow-root
    wp redis enable --allow-root

    chown -R www-data:www-data /var/www/html
fi

exec php-fpm7.4 -F
