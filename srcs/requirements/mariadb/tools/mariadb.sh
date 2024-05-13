#!/bin/sh

# Check if the initial database setup needs to be done
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing database."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    # Start the MariaDB server in the background
    mysqld_safe --datadir="/var/lib/mysql" &
    pid=$!

    # Wait for MariaDB to start
    sleep 10

    # Replace placeholders in the SQL script with environment variables
    sed -i "s/##WP_DB_NAME##/$WP_DB_NAME/g" /usr/local/bin/mariadb.sql
    sed -i "s/##WP_USERNAME##/$WP_USERNAME/g" /usr/local/bin/mariadb.sql
    sed -i "s/##WP_DB_PASSWORD##/$WP_DB_PASSWORD/g" /usr/local/bin/mariadb.sql
    
    # Run SQL statements from the init file
    if [ -f "/usr/local/bin/mariadb.sql" ]; then
        mysql  --bootstrap -uroot < /usr/local/bin/mariadb.sql
    fi

    # Properly stop MariaDB after initialization
    if ! kill -s TERM "$pid" || ! wait "$pid"; then
        echo >&2 'MariaDB init process failed.'
        exit 1
    fi

    echo "MariaDB initialized successfully."
else
    echo "Database already initialized"
fi

# Now, start MariaDB in the foreground
exec mysqld_safe --datadir="/var/lib/mysql"
