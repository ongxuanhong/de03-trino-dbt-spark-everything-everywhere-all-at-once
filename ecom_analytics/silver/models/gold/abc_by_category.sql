WITH category_volume AS (
    SELECT
        DATE_FORMAT(daily, 'y-MM') AS monthly
        , category
        , SUM(sales) AS sales
        , SUM(bills) AS bills
    FROM {{ref("sales_values_by_category")}} cat
    WHERE 1=1
    AND DATE_FORMAT(daily, 'y-MM') IN ('2018-09', '2018-08', '2018-07')
    GROUP BY 
        DATE_FORMAT(daily, 'y-MM')
        , category
),
category_ma3 AS (
    SELECT 
        category
        , AVG(sales) AS sales_ma3
        , AVG(bills) AS bills_ma3
    FROM category_volume
    GROUP BY category
),
-- classify into A (50%), B (40%), C (10%), D
category_total AS (
    SELECT
        *
        , SUM(sales_ma3) OVER () AS total_sales
        , SUM(bills_ma3) OVER () AS total_bills
    FROM category_ma3
),
category_contribute AS (
    SELECT
        *
        , ("sales_ma3" * 100.0 / "total_sales") AS pct_sales_contribute
        , ("bills_ma3" * 100.0 / "total_bills") AS pct_bills_contribute
    FROM category_total
),
cumm_category_contribute AS (
    SELECT
        *
        , SUM(pct_sales_contribute) OVER (ORDER BY pct_sales_contribute DESC ROWS UNBOUNDED PRECEDING) AS cumm_pct_sales
        , SUM(pct_bills_contribute) OVER (ORDER BY pct_bills_contribute DESC ROWS UNBOUNDED PRECEDING) AS cumm_pct_bills
    FROM category_contribute
)
SELECT 
    * 
    , {{ classify_abc("cumm_pct_sales") }} AS rank_class_by_sales
    , {{ classify_abc("cumm_pct_bills") }} AS rank_class_by_bills
FROM cumm_category_contribute