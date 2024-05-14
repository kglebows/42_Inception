#!/bin/sh

echo "wordpress.sh -> Waiting for MariaDB to be ready..."
# Wait until MariaDB is ready to accept connections
while ! mysqladmin ping -h"mariadb" --silent; do
    sleep 1
    echo "wordpress.sh -> Waiting for database..."
done

echo "wordpress.sh -> Checking if WordPress is all set..."
# Check if WordPress is already installed
if ! wp core is-installed --path="/var/www/html" --allow-root; then

    echo "wordpress.sh -> No signs of WordPress, let's set it up..."
    # Create a wp-config.php with the correct settings
    wp config create --dbname="$MYSQL_DATABASE" --dbuser="$MYSQL_USER" --dbpass="$MYSQL_PASSWORD" --dbhost="mariadb" --path="/var/www/html" --allow-root --skip-check

    echo "wordpress.sh -> Config in place! Installing the core..."
    # Install WordPress
    wp core install --url="$DOMAIN_NAME" --title="Inception" --admin_user="$MYSQL_USER" --admin_password="$MYSQL_PASSWORD" --admin_email="admin@example.com" --path="/var/www/html" --allow-root

    echo "wordpress.sh -> Setting URLs..."
    # Set WordPress URL options
    wp option update home "https://$DOMAIN_NAME" --path="/var/www/html" --allow-root
    wp option update siteurl "https://$DOMAIN_NAME" --path="/var/www/html" --allow-root

    echo "wordpress.sh -> Adding a user..."
    # Create a new WordPress user
    wp user create "$WP_USER" user@42.fr --role=author --user_pass="$WP_PASSWORD" --path="/var/www/html" --allow-root

    echo "wordpress.sh -> All set! WordPress is installed and configured!"
else
    echo "wordpress.sh -> WordPress is already installed."
fi

echo "wordpress.sh -> Handing over control to PHP-FPM..."
# Hand over control to PHP-FPM to keep the container running
php-fpm8.2 -F
