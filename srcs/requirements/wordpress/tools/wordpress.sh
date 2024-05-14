#!/bin/sh

echo "wordpress.sh -> Checking if WordPress is all set..."
# Inspect the core, if WordPress is already installed
if ! wp core is-installed --path="/var/www/html" --allow-root; then

    echo "wordpress.sh -> No signs of WordPress, let's set it up..."
    # Generate WordPress configuration with DB environment variables
    wp config create --dbname="$MYSQL_DATABASE" --dbuser="$MYSQL_USER" --dbpass="$MYSQL_PASSWORD" --dbhost="mariadb:3306" --path="/var/www/html" --allow-root --skip-check

    echo "wordpress.sh -> Config in place! Installing the core..."
    # Install WordPress using the database credentials for the admin account
    wp core install --url="$DOMAIN_NAME" --title="Inception" --admin_user="$MYSQL_USER" --admin_password="$MYSQL_PASSWORD" --admin_email="kglebows@42.fr" --path="/var/www/html" --allow-root

    echo "wordpress.sh -> Time to make it official..."
    # Ensure the site URL is correct
    wp option update home "http://$DOMAIN_NAME" --path="/var/www/html" --allow-root
    wp option update siteurl "http://$DOMAIN_NAME" --path="/var/www/html" --allow-root

    # echo "wordpress.sh -> Tuning things up, setting debug mode for dev..."
    # wp config set WP_DEBUG true --raw --path="/var/www/html" --allow-root
    # wp config set WP_DEBUG_LOG true --raw --path="/var/www/html" --allow-root

    echo "wordpress.sh -> Adding a dash of user spice..."
    # Create a new WordPress user with given credentials
    wp user create "$WP_USER" user@42.fr --role=author --user_pass="$WP_PASSWORD" --path="/var/www/html" --allow-root

    echo "wordpress.sh -> All set! WordPress is installed and configured!"
else
    echo "wordpress.sh -> Hold up! WordPress is already installed."
fi

echo "wordpress.sh -> Over and out! Passing the baton to PHP-FPM..."
# Hand over control to PHP-FPM to keep the container running
# exec php8.2-fpm
