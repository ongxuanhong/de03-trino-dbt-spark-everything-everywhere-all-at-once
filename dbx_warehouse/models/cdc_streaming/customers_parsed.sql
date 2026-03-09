WITH cdc_data AS (
SELECT
  CAST(
    COALESCE(
      get_json_object(payload, '$.after.id'),
      get_json_object(payload, '$.before.id'),
      get_json_object(payload, '$.id')
    ) AS BIGINT
  ) AS id,
  COALESCE(
    get_json_object(payload, '$.after.first_name'),
    get_json_object(payload, '$.first_name')
  ) AS first_name,
  COALESCE(
    get_json_object(payload, '$.after.last_name'),
    get_json_object(payload, '$.last_name')
  ) AS last_name,
  COALESCE(
    get_json_object(payload, '$.after.email'),
    get_json_object(payload, '$.email')
  ) AS email,
  LOWER(COALESCE(get_json_object(payload, '$.op'), 'u')) AS op,
  CAST(
    COALESCE(
      get_json_object(payload, '$.ts_ms'),
      get_json_object(payload, '$.source.ts_ms')
    ) AS BIGINT
  ) AS source_ts_ms
FROM {{ source('cdc_streaming', 'customers_raw') }}
WHERE LOWER(COALESCE(get_json_object(payload, '$.op'), 'u')) IN ('c', 'r', 'u', 'd')
)
SELECT *
FROM cdc_data
WHERE id IS NOT NULL