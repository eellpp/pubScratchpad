
```bash
if [ -z "${SPARK_HOME}" ]; then
  source "$(dirname "$0")"/find-spark-home
fi
```

-z checks  if variable is empty\
`"$(dirname "$0")" ` gives the current directory path. $0 is the first part of space delimited shell command. 
