FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y \
 php7.4 php7.4-fpm php7.4-mysql php7.4-cli php7.4-curl php7.4-redis \
 mariadb-client curl \
 && rm -rf /var/lib/apt/lists/*

RUN sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' /etc/php/7.4/fpm/pool.d/www.conf

RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
 && chmod +x /usr/local/bin/wp

WORKDIR /var/www/html

COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 9000
ENTRYPOINT ["/entrypoint.sh"]
