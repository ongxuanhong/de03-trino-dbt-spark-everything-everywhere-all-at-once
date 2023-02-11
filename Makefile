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
	docker exec -it de_mysql mysql --local-infile=1 -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" brazillian_ecommerce

to_mysql_root:
	docker exec -it de_mysql mysql -u"root" -p"${MYSQL_ROOT_PASSWORD}"

to_psql:
	docker exec -ti de_psql psql postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB}

