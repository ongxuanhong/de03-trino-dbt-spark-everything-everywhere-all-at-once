-- One tick of the ingest simulator. Driven by simulate_stream.sh.
-- Expects psql vars :batch (rows to insert) and :retention (interval literal).
WITH picks AS (
    -- nextval lives in its own CTE: putting it in a join condition leaves
    -- per-row evaluation up to the planner and is not reliable.
    SELECT nextval('replay_cursor') AS rn
    FROM generate_series(1, :batch)
),
ins AS (
    INSERT INTO live_order_items (
        event_ts, order_id, order_item_id, product_id, seller_id,
        customer_id, order_status, product_category, payment_type,
        price, freight_value
    )
    SELECT
        -- now() is transaction time, so without jitter every row in a tick lands
        -- on one timestamp and the 5-second-grain charts render as a step function.
        now() - (random() * interval '1 second'),
        r.order_id, r.order_item_id, r.product_id, r.seller_id,
        r.customer_id, r.order_status, r.product_category, r.payment_type,
        r.price, r.freight_value
    FROM picks
    JOIN replay_source r USING (rn)
    RETURNING 1
),
pruned AS (
    -- Keep the table bounded; at 20 rows/s it grows ~72k rows/hour. Index range scan.
    DELETE FROM live_order_items
    WHERE event_ts < now() - :'retention'::interval
    RETURNING 1
)
SELECT
    (SELECT count(*) FROM ins) AS inserted,
    (SELECT count(*) FROM pruned) AS pruned,
    date_trunc('second', now()) AS at;
