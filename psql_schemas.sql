DROP TABLE IF EXISTS olist_order_payments_dataset;
DROP TABLE IF EXISTS olist_order_items_dataset;
DROP TABLE IF EXISTS olist_orders_dataset;
DROP TABLE IF EXISTS olist_products_dataset;
DROP TABLE IF EXISTS product_category_name_translation;

CREATE TABLE product_category_name_translation (
    product_category_name varchar(64),
    product_category_name_english varchar(64),
    PRIMARY KEY (product_category_name)
);

CREATE TABLE olist_products_dataset (
    product_id varchar(32),
    product_category_name varchar(64),
    product_name_lenght integer,
    product_description_lenght integer,
    product_photos_qty integer,
    product_weight_g integer,
    product_length_cm integer,
    product_height_cm integer,
    product_width_cm integer,
    PRIMARY KEY (product_id)
);

CREATE TABLE olist_orders_dataset (
    order_id varchar(32),
    customer_id varchar(32),
    order_status varchar(16),
    order_purchase_timestamp varchar(32),
    order_approved_at varchar(32),
    order_delivered_carrier_date varchar(32),
    order_delivered_customer_date varchar(32),
    order_estimated_delivery_date varchar(32),
    PRIMARY KEY (order_id)
);

CREATE TABLE olist_order_items_dataset (
    order_id varchar(32),
    order_item_id integer,
    product_id varchar(32),
    seller_id varchar(32),
    shipping_limit_date varchar(32),
    price real,
    freight_value real,
    created_at timestamp DEFAULT now(),
    updated_at timestamp DEFAULT now(),
    PRIMARY KEY (order_id, order_item_id, product_id, seller_id),
    FOREIGN KEY (order_id) REFERENCES olist_orders_dataset(order_id),
    FOREIGN KEY (product_id) REFERENCES olist_products_dataset(product_id)
);

CREATE TABLE olist_order_payments_dataset (
    order_id varchar(32),
    payment_sequential integer,
    payment_type varchar(16),
    payment_installments integer,
    payment_value real,
    PRIMARY KEY (order_id, payment_sequential)
);

-- Docker commands
docker exec de_psql psql -U admin -d postgres -c "\dt public.*" 2>&1 | head -20

docker exec de_psql psql -U admin -d postgres -c "SELECT 'products' t, count(*) FROM olist_products_dataset UNION ALL SELECT 'orders', count(*) FROM olist_orders_dataset UNION ALL SELECT 'items', count(*) FROM olist_order_items_dataset UNION ALL SELECT 'payments', count(*) FROM olist_order_payments_dataset UNION ALL SELECT 'cat_translation', count(*) FROM product_category_name_translation;" 2>&1

docker exec -i de_psql psql -U admin -d postgres -c "\copy public.product_category_name_translation FROM STDIN WITH (FORMAT csv, HEADER true)" < product_category_name_translation.csv
docker exec -i de_psql psql -U admin -d postgres -c "\copy public.olist_products_dataset FROM STDIN WITH (FORMAT csv, HEADER true)" < olist_products_dataset.csv
docker exec -i de_psql psql -U admin -d postgres -c "\copy public.olist_orders_dataset FROM STDIN WITH (FORMAT csv, HEADER true)" < olist_orders_dataset.csv
docker exec -i de_psql psql -U admin -d postgres -c "\copy public.olist_order_items_dataset (order_id, order_item_id, product_id, seller_id, shipping_limit_date, price, freight_value) FROM STDIN WITH (FORMAT csv, HEADER true)" < olist_order_items_dataset.csv
docker exec -i de_psql psql -U admin -d postgres -c "\copy public.olist_order_payments_dataset FROM STDIN WITH (FORMAT csv, HEADER true)" < olist_order_payments_dataset.csv
