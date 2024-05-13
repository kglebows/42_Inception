-- Create the WordPress database
CREATE DATABASE IF NOT EXISTS `##WP_DB_NAME##`;

-- Create a new user specifically for WordPress
CREATE USER '##WP_USERNAME##'@'%' IDENTIFIED BY '##WP_DB_PASSWORD##';

-- Grant all privileges on the WordPress database to the new user
GRANT ALL PRIVILEGES ON `##WP_DB_NAME##`.* TO '##WP_USERNAME##'@'%';

-- Flush privileges to ensure that the changes take effect
FLUSH PRIVILEGES;
