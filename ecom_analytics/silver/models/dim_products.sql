SELECT *
FROM {{ source('silver', 'external_products') }}