bronze: 
    dbt run --project-dir ./bronze --profiles-dir ./ --full-refresh

silver:
    dbt run --project-dir ./silver --profiles-dir ./ --full-refresh

seed:
    dbt seed --project-dir ./bronze --profiles-dir ./ --full-refresh

docs:
    dbt docs generate --profiles-dir ./ \
    && dbt docs serve --profiles-dir ./

select:
    dbt run --profiles-dir ./ --select $(script)

test:
    dbt test --profiles-dir ./
