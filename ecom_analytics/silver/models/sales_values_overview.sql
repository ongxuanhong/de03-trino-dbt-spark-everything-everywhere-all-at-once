SELECT
	CAST("order_purchase_timestamp" AS DATE) AS daily
	, ROUND(SUM("payment_value"), 2) AS sales
	, COUNT(DISTINCT("order_id")) AS bills
FROM {{ref("fact_sales")}}
GROUP BY CAST("order_purchase_timestamp" AS DATE)