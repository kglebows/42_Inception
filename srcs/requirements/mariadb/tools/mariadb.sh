#!/bin/sh

rc-service mariadb start

while ! mysqladmin ping --silent; do
    sleep 1
done

mariadb --user=root << EOF
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

rc-service mariadb stop

exec /usr/bin/mariadbd --user=root --datadir=/var/lib/mysql