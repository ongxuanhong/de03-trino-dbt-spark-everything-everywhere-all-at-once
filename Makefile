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

# --- Near real-time Superset demo (see SUPERSET.md) ---

stream_init:
	docker exec -i de_psql psql -U ${POSTGRES_USER} -d ${POSTGRES_DB} < ./superset_vis/superset_streaming.sql

stream:
	./superset_vis/simulate_stream.sh

stream_stats:
	docker exec de_psql psql -U ${POSTGRES_USER} -d ${POSTGRES_DB} -c "\
	SELECT count(*) AS rows, \
	       count(DISTINCT event_ts) AS distinct_ts, \
	       min(event_ts) AS oldest, \
	       max(event_ts) AS newest, \
	       count(*) FILTER (WHERE event_ts > now() - interval '1 minute') AS last_minute, \
	       round(sum(revenue), 2) AS revenue \
	FROM live_order_items;"

stream_reset:
	docker exec de_psql psql -U ${POSTGRES_USER} -d ${POSTGRES_DB} -c "TRUNCATE live_order_items; ALTER SEQUENCE replay_cursor RESTART;"

