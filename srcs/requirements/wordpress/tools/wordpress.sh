#!/bin/sh

# Check if WordPress is already installed
if ! wp core is-installed --path="/var/www/html" --allow-root; then

    # Configuring WordPress before installation
    echo "Configuring WordPress..."
    wp config create --dbname="$DB_NAME" --dbuser="$DB_USER" --dbpass="$DB_PASSWORD" --dbhost="$DB_HOST" --path="/var/www/html" --allow-root --skip-check

    # Install WordPress
    echo "Installing WordPress..."
    wp core install --url="$DOMAIN_NAME" --title="kglebowsInception" --admin_user="$WP_USER" --admin_password="$WP_PASSWORD" --admin_email="kglebows@42.fr" --path="/var/www/html" --allow-root

    # Update site URL consistently
    wp option update home "http://$DOMAIN_NAME" --path="/var/www/html" --allow-root
    wp option update siteurl "http://$DOMAIN_NAME" --path="/var/www/html" --allow-root

    # Additional configuration: Debug mode
    # wp config set WP_DEBUG true --raw --path="/var/www/html" --allow-root
    # wp config set WP_DEBUG_LOG true --raw --path="/var/www/html" --allow-root

    # Create a new WordPress user (optional)
    wp user create firstUser first@user.com --role=author --user_pass="P@ssw0rd" --path="/var/www/html" --allow-root
fi

echo "WordPress has been successfully set up."

# Keep the container running by handing over control to PHP-FPM
exec php-fpm
