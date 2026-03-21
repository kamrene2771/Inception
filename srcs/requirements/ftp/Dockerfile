FROM debian:bullseye

RUN apt-get update && apt-get install -y vsftpd && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/vsftpd/empty

COPY conf/vsftpd.conf /etc/vsftpd.conf
COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 21 21000-21010

ENTRYPOINT ["/entrypoint.sh"]
