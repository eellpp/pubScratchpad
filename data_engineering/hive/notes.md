
Steps in Hive Query Processing: 

1. Hive query compilation takes the query string and produces a QueryPlan. The QueryPlan contains both the list of cluster tasks required for the query, as well as the FetchTask used to fetch results. The cluster tasks are configured to output the final results to a designated temp directory. The FetchTask contains a FetchOperator which is configured to read from the designated temp directory, as well as the input format, column information, and other information.

2. During query execution (Driver.execute()), Hive will submit any cluster tasks (MR/Tez/Spark) required for the query.

3. When the cluster tasks are finished the queryPlan’s FetchTask is used to read the query results from the temp directory (Driver.getResults())

4. Cleanup of the query results is handled by the Driver’s Context object. Several directory paths are cleaned up in this step, including the query results directory and parent directories of the results directory.
