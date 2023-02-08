include .env

build:
	docker-compose build

up:
	docker-compose --env-file .env up -d

down:
	docker-compose --env-file .env down

restart:
	make down && make up

to_mysql:
	docker exec -it de_mysql mysql --local-infile=1 -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" ${MYSQL_DATABASE}

to_mysql_root:
	docker exec -it de_mysql mysql -u"root" -p"${MYSQL_ROOT_PASSWORD}" ${MYSQL_DATABASE}	

