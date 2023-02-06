DROP TABLE IF EXISTS product_category_name_translation;
CREATE TABLE product_category_name_translation (
    product_category_name varchar(64),
    product_category_name_english varchar(64),
    PRIMARY KEY (product_category_name)
);

DROP TABLE IF EXISTS olist_products_dataset;
CREATE TABLE olist_products_dataset (
    product_id varchar(32),
    product_category_name varchar(64),
    product_name_lenght int4,
    product_description_lenght int4,
    product_photos_qty int4,
    product_weight_g int4,
    product_length_cm int4,
    product_height_cm int4,
    product_width_cm int4,
    PRIMARY KEY (product_id)
);

DROP TABLE IF EXISTS olist_orders_dataset;
CREATE TABLE olist_orders_dataset (
    order_id varchar(32),
    customer_id varchar(32),
    order_status varchar(16),
    order_purchase_timestamp varchar(32),
    order_approved_at varchar(32),
    order_delivered_carrier_date varchar(32),
    order_delivered_customer_date varchar(32),
    order_estimated_delivery_date varchar(32),
    PRIMARY KEY(order_id)
);


DROP TABLE IF EXISTS olist_order_items_dataset;
CREATE TABLE olist_order_items_dataset (
    order_id varchar(32),
    order_item_id int4,
    product_id varchar(32),
    seller_id varchar(32),
    shipping_limit_date varchar(32),
    price float4,
    freight_value float4,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (order_id, order_item_id, product_id, seller_id),
    FOREIGN KEY (order_id) REFERENCES olist_orders_dataset(order_id),
    FOREIGN KEY (product_id) REFERENCES olist_products_dataset(product_id)
);

DROP TABLE IF EXISTS olist_order_payments_dataset;
CREATE TABLE olist_order_payments_dataset (
    order_id varchar(32),
    payment_sequential int4,
    payment_type varchar(16),
    payment_installments int4,
    payment_value float4,
    PRIMARY KEY (order_id, payment_sequential)
);