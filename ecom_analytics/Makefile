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
	dbt docs generate --profiles-dir ./silver && dbt docs serve --profiles-dir ./silver

select:
	dbt run --profiles-dir ./silver --select $(script)

test:
	dbt test --profiles-dir ./silver