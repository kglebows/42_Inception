FROM debian:bookworm-slim

# Set working directory
WORKDIR /var/www/html

ENV DEBIAN_FRONTEND noninteractive


# Update package lists and install PHP and necessary extensions for WordPress
RUN apt-get update && \
    # apt-get install -y --no-install-recommends apt-utils && \
    apt-get install -y \
	mariadb-client \
    php8.2 \
    php8.2-fpm \
    php8.2-mysqli \
    php8.2-curl \
    php8.2-xml \
    php8.2-intl \
    php8.2-dom \
    php8.2-xmlreader \
    php8.2-ctype \
    php8.2-mbstring \
    php8.2-gd \
    curl \
    wget && \
    rm -rf /var/lib/apt/lists/*

ENV DEBIAN_FRONTEND newt

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
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY tools/wordpress.sh /usr/local/bin/wordpress.sh

RUN chmod 755 /usr/local/bin/wordpress.sh

# Set ownership/permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

EXPOSE 9000

CMD /usr/local/bin/wordpress.sh
