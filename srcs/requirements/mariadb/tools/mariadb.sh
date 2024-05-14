#!/bin/sh

echo "mariadb.sh -> Checking if the database is already initialized..."
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "mariadb.sh -> Database not found, initializing new database setup..."
    mysql_install_db --user=root --datadir=/var/lib/mysql

    echo "mariadb.sh -> Starting MariaDB server in the background..."
    mysqld_safe --datadir="/var/lib/mysql" &
    pid=$!

    echo "mariadb.sh -> Waiting for MariaDB to become operational..."
    while ! mysqladmin ping -h"localhost" --silent; do
        sleep 1
        echo -n "."
    done
    echo "mariadb.sh -> MariaDB is up and running!"

    echo "mariadb.sh -> Applying initial configurations..."
    sed -i "s/##DB_NAME##/$MYSQL_DATABASE/g" /usr/local/bin/startup.sql
    sed -i "s/##DB_USER##/$MYSQL_USER/g" /usr/local/bin/startup.sql
    sed -i "s/##DB_PASSWORD##/$MYSQL_PASSWORD/g" /usr/local/bin/startup.sql
    
    if [ -f "/usr/local/bin/mariadb.sql" ]; then
        echo "mariadb.sh -> Executing SQL setup script..."
        mysql --bootstrap -uroot < /usr/local/bin/startup.sql
    fi

    echo "mariadb.sh -> Initial setup complete, stopping MariaDB..."
    if ! kill -s TERM "$pid" || ! wait "$pid"; then
        echo >&2 'mariadb.sh -> MariaDB init process failed.'
        exit 1
    fi
    echo "mariadb.sh -> MariaDB initialized successfully and shut down."

    echo "mariadb.sh -> Cleaning up sensitive data..."
    # rm -f /usr/local/bin/startup.sql
    # unset MYSQL_DATABASE MYSQL_USER MYSQL_PASSWORD
else
    echo "mariadb.sh -> Database already initialized."
fi

echo "mariadb.sh -> Starting MariaDB in the foreground..."
exec mysqld_safe --datadir="/var/lib/mysql"
