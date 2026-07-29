#!/usr/bin/env bash
#
# Append-only ingest simulator for the near real-time Superset dashboard.
#
# Walks replay_source with the replay_cursor sequence and inserts a batch of rows
# into live_order_items every INTERVAL seconds, stamped with event_ts = now().
# Run `make stream_init` first to create those objects.
#
# Usage:  ./simulate_stream.sh [BATCH] [INTERVAL]
#         ./simulate_stream.sh 20 1     # default: 20 rows/sec
#         ./simulate_stream.sh 200 1    # heavier load
#
# Ctrl-C to stop.

set -euo pipefail

BATCH="${1:-20}"
INTERVAL="${2:-1}"
CONTAINER="${CONTAINER:-de_psql}"
RETENTION="${RETENTION:-1 hour}"

cd "$(dirname "$0")"

# Reuse the same credentials the Makefile and docker-compose read (repo root .env).
set -a
# shellcheck disable=SC1091
source ../.env
set +a

ticks=0
trap 'echo; echo "stopped after ${ticks} ticks (~$((ticks * BATCH)) rows inserted)"; exit 0' INT TERM

TICK_SQL=$(cat stream_tick.sql)

echo "streaming ${BATCH} rows every ${INTERVAL}s into ${CONTAINER}:${POSTGRES_DB}.public.live_order_items"
echo "retention: ${RETENTION}   (Ctrl-C to stop)"

while true; do
    docker exec -i "$CONTAINER" psql \
        -U "$POSTGRES_USER" -d "$POSTGRES_DB" \
        --quiet --no-align --tuples-only \
        -v batch="$BATCH" -v retention="$RETENTION" \
        <<<"$TICK_SQL"
    ticks=$((ticks + 1))
    sleep "$INTERVAL"
done
