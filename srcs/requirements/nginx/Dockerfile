FROM debian:bookworm-slim

# Prep
RUN apt-get update
RUN apt-get install -y \
	nginx \
	openssl

# SSL Setup
RUN mkdir /etc/nginx/ssl
RUN openssl req -x509 -nodes -days 31 -newkey rsa:2048 \
	-keyout /etc/nginx/ssl/nginx.key \
	-out /etc/nginx/ssl/nginx.crt \
	-subj "/CN=kglebows.42.fr"

# Conf Setup
RUN rm /etc/nginx/sites-available/default
COPY conf/nginx.conf /etc/nginx/nginx.conf

# test
COPY tools/index.html /usr/share/nginx/html/index.html

# Open port for SSL
EXPOSE 443

# run ngnix as a foreground process
CMD nginx -t && nginx -g 'daemon off;'
