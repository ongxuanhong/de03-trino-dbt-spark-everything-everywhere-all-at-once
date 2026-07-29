-- Near real-time demo objects for the Superset dashboard.
-- Run once:  make stream_init
--
-- The loaded Olist data is static (every olist_order_items_dataset.created_at is
-- the single bulk-load timestamp, and order_purchase_timestamp stops at 2018-10-17),
-- so an auto-refreshing dashboard needs a source of movement. replay_source is a
-- denormalized snapshot of the 5 populated tables; simulate_stream.sh walks it with
-- replay_cursor and appends batches into live_order_items with event_ts = now().

DROP TABLE IF EXISTS live_order_items;
DROP TABLE IF EXISTS replay_source;
DROP SEQUENCE IF EXISTS replay_cursor;

-- One row per order item, pre-joined so the dashboard never joins at query time.
-- price/freight_value are float4 in the source; cast to numeric so revenue sums
-- don't accumulate float rounding artifacts.
CREATE TABLE replay_source AS
SELECT
    row_number() OVER (ORDER BY o.order_purchase_timestamp) AS rn,
    i.order_id,
    i.order_item_id,
    i.product_id,
    i.seller_id,
    o.customer_id,
    o.order_status,
    -- 610 products have no category, and the first row of the translation table
    -- carries a UTF-8 BOM in its key so it never matches; fall back rather than NULL.
    COALESCE(t.product_category_name_english, p.product_category_name, 'unknown')
        AS product_category,
    pay.payment_type,
    i.price::numeric(12, 2) AS price,
    i.freight_value::numeric(12, 2) AS freight_value
FROM olist_order_items_dataset i
JOIN olist_orders_dataset o
    ON o.order_id = i.order_id
LEFT JOIN olist_products_dataset p
    ON p.product_id = i.product_id
LEFT JOIN product_category_name_translation t
    ON t.product_category_name = p.product_category_name
-- payment_sequential = 1 keeps this 1:1 with the order; joining all payment rows
-- would fan out the item grain and inflate revenue.
LEFT JOIN (
    SELECT order_id, payment_type
    FROM olist_order_payments_dataset
    WHERE payment_sequential = 1
) pay
    ON pay.order_id = i.order_id;

-- PK so each generator tick is an index seek on rn rather than a scan of 112k rows.
ALTER TABLE replay_source ADD PRIMARY KEY (rn);

CREATE TABLE live_order_items (
    event_id bigserial PRIMARY KEY,
    event_ts timestamp NOT NULL DEFAULT now(),
    order_id varchar(32),
    order_item_id integer,
    product_id varchar(32),
    seller_id varchar(32),
    customer_id varchar(32),
    order_status varchar(16),
    product_category varchar(64),
    payment_type varchar(16),
    price numeric(12, 2),
    freight_value numeric(12, 2),
    revenue numeric(12, 2) GENERATED ALWAYS AS
        (COALESCE(price, 0) + COALESCE(freight_value, 0)) STORED
);

-- Every dashboard chart filters on event_ts, as does the retention delete.
CREATE INDEX idx_live_order_items_event_ts ON live_order_items (event_ts DESC);

-- CYCLE so the demo can run indefinitely instead of exhausting replay_source.
-- MAXVALUE is derived from the actual row count so the cursor can never seek an rn
-- that doesn't exist (which would silently insert nothing for that tick).
DO $$
DECLARE
    n bigint;
BEGIN
    SELECT count(*) INTO n FROM replay_source;
    EXECUTE format(
        'CREATE SEQUENCE replay_cursor MINVALUE 1 MAXVALUE %s START 1 CYCLE', n
    );
    RAISE NOTICE 'replay_source has % rows; replay_cursor cycles 1..%', n, n;
END $$;
