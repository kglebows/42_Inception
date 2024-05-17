FROM debian:bookworm-slim

RUN apt-get update && \
	apt-get install -y \
	nginx \
	openssl && \
	rm /etc/nginx/sites-available/default && \
	rm /etc/nginx/sites-enabled/default

RUN mkdir /etc/nginx/ssl && \
	openssl req -x509 -nodes -days 31 -newkey rsa:2048 \
	-keyout /etc/nginx/ssl/nginx.key \
	-out /etc/nginx/ssl/nginx.crt \
	-subj "/CN=kglebows.42.fr"

COPY conf/default.conf /etc/nginx/sites-available/default

RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default && \
	chmod 777 /etc/nginx/ssl/* && \
	chmod 777 -R /var/www && \
	chown -R www-data:www-data /var/www/

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
