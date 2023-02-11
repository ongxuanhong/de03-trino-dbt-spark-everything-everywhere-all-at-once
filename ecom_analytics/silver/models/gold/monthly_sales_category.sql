SELECT
  "category"
  , {{ dbt_utils.pivot(
      'monthly',
      dbt_utils.get_column_values(ref('sales_values_by_category'), 'monthly', order_by="monthly ASC"),
      then_value="values_per_bills",
      agg='avg',
      prefix="values_per_bills_"
  ) }}
FROM {{ ref('sales_values_by_category') }}
GROUP BY
  "category"