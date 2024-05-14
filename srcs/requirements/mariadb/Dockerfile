FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND noninteractive

# Install necessary packages and configure environment
RUN apt-get update && \
    apt-get install -y mariadb mariadb-client openrc && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/run/mysqld /var/log/mysql && \
    chown -R mysql:mysql /var/run/mysqld /var/log/mysql && \
    chmod -R 755 /var/lib/mysql && \
    openrc && \
    touch /run/openrc/softlevel

ENV DEBIAN_FRONTEND newt


# Copy configuration files and scripts
COPY conf/my.cnf /etc/mysql/mariadb.conf.d/my.cnf
# COPY tools/startup.sql /usr/local/bin/startup.sql
COPY tools/mariadb.sh /usr/local/bin/mariadb.sh

# Set permissions and ensure the startup script is executable
RUN chmod 755 /usr/local/bin/mariadb.sh

# Expose the default MariaDB port
EXPOSE 3306

# Use mysqld_safe as the default command to run
CMD ["/usr/local/bin/mariadb.sh"]