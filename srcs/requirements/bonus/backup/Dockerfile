FROM debian:bullseye

RUN apt-get update && apt-get install -y rsync && rm -rf /var/lib/apt/lists/*

COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
