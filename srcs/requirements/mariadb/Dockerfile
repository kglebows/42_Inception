FROM debian:bookworm-slim

# Install necessary packages and configure environment
RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-utils && \
    apt-get install -y mariadb-server mariadb-client && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/run/mysqld /var/log/mysql && \
    chown -R mysql:mysql /var/run/mysqld /var/log/mysql

# Copy configuration files and scripts
COPY conf/my.cnf /etc/mysql/mariadb.conf.d/my.cnf
COPY tools/startup.sql /usr/local/bin/startup.sql
COPY tools/mariadb.sh /usr/local/bin/mariadb.sh

# Set permissions and ensure the startup script is executable
RUN chmod +x /usr/local/bin/mariadb.sh

# Expose the default MariaDB port
EXPOSE 3306

# Set the entrypoint script to initialize the database
ENTRYPOINT ["/usr/local/bin/mariadb.sh"]

# Use mysqld_safe as the default command to run
CMD ["mysqld_safe"]