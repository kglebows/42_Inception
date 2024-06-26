#!/bin/sh

sleep 10

echo "wordpress.sh -> Inspect the core, if WordPress is already installed."
if ! wp core is-installed --path="/var/www/html" --allow-root; then

    echo "wordpress.sh -> Generate WordPress configuration with DB environment variables"
    wp config create --dbname="$MYSQL_DATABASE" --dbuser="$MYSQL_USER" --dbpass="$MYSQL_PASSWORD" --dbhost="mariadb:3306" --path="/var/www/html" --allow-root --skip-check

    echo "wordpress.sh -> Install WordPress using the database credentials for the admin account."
    wp core install --url="$DOMAIN_NAME" --title="Inception" --admin_user="$MYSQL_USER" --admin_password="$MYSQL_PASSWORD" --admin_email="kglebows@42.fr" --path="/var/www/html" --allow-root

    echo "wordpress.sh -> Ensure the site URL is correct."
    wp option update home "https://$DOMAIN_NAME" 
    wp option update siteurl "https://$DOMAIN_NAME" 
	
    # echo "wordpress.sh -> DEBUG MODE ON"
    # wp config set WP_DEBUG true --raw --path="/var/www/html" --allow-root
    # wp config set WP_DEBUG_LOG true --raw --path="/var/www/html" --allow-root

    echo "wordpress.sh -> Create a new WordPress user with given credentials."
    wp user create "$WP_USER" user@42.fr --role=author --user_pass="$WP_PASSWORD" --path="/var/www/html" --allow-root

    echo "wordpress.sh -> WordPress is installed and configured!"
else
    echo "wordpress.sh -> WordPress is already installed!"
fi

echo "Hand over control to PHP-FPM to keep the container running."
php-fpm8.2 -F -y /etc/php/8.2/fpm/pool.d/www.conf
