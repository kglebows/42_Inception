-- Create the WordPress database
CREATE DATABASE IF NOT EXISTS `##DB_NAME##`;

-- Create a new user specifically for WordPress
CREATE USER '##DB_USER##'@'%' IDENTIFIED BY '##DB_PASSWORD##';

-- Grant all privileges on the WordPress database to the new user
GRANT ALL PRIVILEGES ON `##DB_NAME##`.* TO '##DB_USER##'@'%';

-- Flush privileges to ensure that the changes take effect
FLUSH PRIVILEGES;
