{{
    config(
        unique_key="product_id"
    )
}}

SELECT
	rp.product_id
	, pcnt.product_category_name_english 
FROM bronze.olist_products rp 
JOIN bronze.product_category_name_translation pcnt 
ON rp.product_category_name = pcnt.product_category_name 