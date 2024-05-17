FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get install -y mariadb-server mariadb-client && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/run/mysqld /var/log/mysql && \
    chown -R root:root /var/run/mysqld /var/log/mysql && \
    chmod -R 755 /var/lib/mysql

ENV DEBIAN_FRONTEND newt

COPY conf/my.cnf /etc/mysql/mariadb.conf.d/my.cnf
COPY tools/startup.sql /usr/local/bin/startup.sql
COPY tools/mariadb.sh /usr/local/bin/mariadb.sh

RUN chmod 755 /usr/local/bin/mariadb.sh

EXPOSE 3306

CMD ["/usr/local/bin/mariadb.sh"]