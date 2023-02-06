include .env

build:
	docker-compose build

up:
	docker-compose --env-file .env up -d

down:
	docker-compose --env-file .env down

restart:
	make down && make up
		