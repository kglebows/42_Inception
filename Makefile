all: down build up

build:
	docker-compose -f ./srcs/docker-compose.yml build

up:
	docker-compose -f ./srcs/docker-compose.yml up -d

down:
	docker-compose -f ./srcs/docker-compose.yml down

clean:
	docker-compose -f ./srcs/docker-compose.yml down --rmi all --volumes --remove-orphans

fclean: clean
	-docker stop $(sh docker ps -qa)
	-docker rm $(sh docker ps -qa)
	-docker rmi -f $(sh docker images -q)
	-docker volume rm $(sh docker volume ls -q)
	-docker network rm $(sh docker network ls -q)

subject:
	docker stop $(docker ps -qa); docker rm $(docker ps -qa); docker rmi -f $(docker images -qa); docker volume rm $(docker volume ls -q); docker network rm $(docker network ls -q) 2>/dev/null

re: fclean build up

.PHONY: all build up down clean fclean re subject