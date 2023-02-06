# de03-apache-kyuuby

## Connection
```bash
jdbc:hive2://localhost:10009/default;#spark.sql.shuffle.partitions=2;spark.executor.memory=5g;spark.ui.port=4040;spark.dynamicAllocation.enabled=true;spark.dynamicAllocation.minExecutors=2;spark.dynamicAllocation.initialExecutors=2;spark.executor.instances=2
```