FROM debian:bookworm-slim

# Prep
RUN apt-get update && \
	apt-get install -y --no-install-recommends apt-utils && \
	apt-get install -y \
	nginx \
	openssl

# SSL Setup
RUN mkdir /etc/nginx/ssl && \
	openssl req -x509 -nodes -days 31 -newkey rsa:2048 \
	-keyout /etc/nginx/ssl/nginx.key \
	-out /etc/nginx/ssml/nginx.crt \
	-subj "/CN=kglebows.42.fr"

# Conf Setup
RUN rm /etc/nginx/sites-available/default
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Open port for SSL
EXPOSE 443

# check config and run ngnix as a foreground process
CMD nginx -t && nginx -g 'daemon off;'
