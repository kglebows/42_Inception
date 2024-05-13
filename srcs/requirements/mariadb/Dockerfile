FROM debian:bookworm-slim

# Install necessary packages
RUN apt-get update && \
    apt-get install -y mariadb-server mariadb-client && \
    rm -rf /var/lib/apt/lists/*  # Clean up to reduce image size

# Ensure the MariaDB directories are properly set up
RUN mkdir -p /var/run/mysqld /var/log/mysql && \
    chown -R mysql:mysql /var/run/mysqld /var/log/mysql

# Copy configuration files and scripts (Make sure to have these files in your context)
COPY conf/my.cnf /etc/mysql/mariadb.conf.d/my.cnf
COPY tools/mariadb.sql /usr/local/bin/mariadb.sql
COPY tools/startup.sh /usr/local/bin/startup.sh

# Set permissions and ensure the startup script is executable
RUN chmod +x /usr/local/bin/startup.sh

# Expose the default MariaDB port
EXPOSE 3306

# Set the entrypoint script to initialize the database
ENTRYPOINT ["/usr/local/bin/startup.sh"]

# Use mysqld_safe as the default command to run
CMD ["mysqld_safe"]
