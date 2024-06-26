all: down build up

build:
	mkdir -p /home/kglebows/data/wp-data
	mkdir -p /home/kglebows/data/db-data
	docker-compose -f ./srcs/docker-compose.yml build

up:
	docker-compose -f ./srcs/docker-compose.yml up

down:
	docker-compose -f ./srcs/docker-compose.yml down

clean:
	docker-compose -f ./srcs/docker-compose.yml down

fclean: clean
	rm -rf /home/kglebows/data
	-docker stop $$(docker ps -qa)
	-docker rm $$(docker ps -qa)
	-docker rmi -f $$(docker images -q)
	-docker volume rm $$(docker volume ls -q)
	-docker network rm $$(docker network ls -q)

subject:
	docker stop $$(docker ps -qa); docker rm $$(docker ps -qa); docker rmi -f $$(docker images -qa); docker volume rm $$(docker volume ls -q); docker network rm $$(docker network ls -q) 2>/dev/null

copyenv:
	cp ../Secrets/.env srcs/.env

re: fclean build up

.PHONY: all build up down clean fclean re subject copyenv