FROM debian:bookworm-slim

# Set working directory
WORKDIR /var/www/html

# Update package lists and install PHP and necessary extensions for WordPress
RUN apt-get update && apt-get install -y \
    apt-get install -y --no-install-recommends apt-utils && \
    php \
    php-fpm \
    php-mysqli \
    php-json \
    php-curl \
    php-xml \
    php-intl \
    php-dom \
    php-xmlreader \
    php-ctype \
    php-mbstring \
    php-gd \
    curl \
    wget && \
    rm -rf /var/lib/apt/lists/*

# Install WordPress
RUN wget https://wordpress.org/latest.tar.gz \
    && tar -xzf latest.tar.gz \
    && mv wordpress/* . \
    && rm -f latest.tar.gz

# Install WordPress CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Configure PHP-FPM
COPY conf/www.conf /etc/php/fpm/pool.d/www.conf
COPY tools/wordpress.sh /usr/local/bin/wordpress.sh

RUN chmod +x /usr/local/bin/wordpress.sh

# Set ownership/permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

ENTRYPOINT ["/usr/local/bin/wordpress.sh"]

EXPOSE 9000

CMD ["php-fpm", "-F"]
