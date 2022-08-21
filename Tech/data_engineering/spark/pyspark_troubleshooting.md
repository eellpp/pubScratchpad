
### Example of OOM issue while using row_number
https://towardsdatascience.com/adding-sequential-ids-to-a-spark-dataframe-fa0df5566ff6

```bash
spark.sql(‘select row_number() over (order by “monotonically_increasing_id”) as row_num, * from df_final’)
```
In order to use row_number(), we need to move our data into one partition. The Window in both cases (sortable and not sortable data) consists basically of all the rows we currently have so that the row_number() function can go over them and increment the row number. This can cause performance and memory issues — we can easily go OOM, depending on how much data and how much memory we have.
