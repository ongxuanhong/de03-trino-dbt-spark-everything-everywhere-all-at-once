run_bronze:
	dbt run --project-dir ./bronze --profiles-dir ./ --full-refresh

run_silver:
	dbt run --project-dir ./silver --profiles-dir ./ --full-refresh

run_external:
    dbt run-operation --project-dir ./silver stage_external_sources --args "select: default"

install_deps:
    dbt deps --project-dir ./silver    

seed:
    dbt seed --project-dir ./bronze --profiles-dir ./ --full-refresh
	
docs:
    dbt docs generate --profiles-dir ./ \
    && dbt docs serve --profiles-dir ./

select:
    dbt run --profiles-dir ./ --select $(script)

test:
    dbt test --profiles-dir ./