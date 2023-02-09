run:
	dbt run --profiles-dir ./ --full-refresh

seed:
	dbt seed --profiles-dir ./ --full-refresh

docs:
	dbt docs generate --profiles-dir ./ \
	&& dbt docs serve --profiles-dir ./

select:
	dbt run --profiles-dir ./ --select $(script)

test:
	dbt test --profiles-dir ./	