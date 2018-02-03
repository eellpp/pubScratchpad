
### Cluster creation
gcloud dataproc clusters create <CLUSTER_NAME> \
    --num-masters 1 \
    --zone us-central1-a \
    --master-machine-type n1-standard-4 \
    --master-boot-disk-size 50 \
    --num-workers 3 \
    --worker-machine-type n1-standard-4 \
    --worker-boot-disk-size 50 \
    --image-version preview \
    --initialization-actions gs://dataproc-initialization-actions/kafka/kafka.sh

- num-masters 3 is for HA mode . For standard mode we can use 1
- default master/worker machine type n1-standard-4 , which is 4 core 15 GB memory (~ 0.19 per hour)

gcloud dataproc clusters delete NAME


### Access from local machine
eg: cp file to bucket

gsutil cp source gs://my_bucket



gsutils ls <bucket path>
gsutil ls gs://dataproc-initialization-actions

### useful commands

```bash
get the <username>@<master name> by logging into the master node from the virtual instances table in clusters page 
> beeline -u jdbc:hive2://localhost:10000/default -n <username>@<master name> -d org.apache.hive.jdbc.HiveDriver
> gcloud compute instances list
> gcloud compute instances create test-instance
> gcloud compute ssh test-instance --zone=us-central1-a
> gcloud compute instances restart test-instance
```

http://holowczak.com/getting-started-with-hive-on-google-cloud-dataproc/5/

### GsUtils
https://cloud.google.com/storage/docs/gsutil


### Navigating Google Cloud Platform: A Guide for new GCP Users (Google I/O '17)
 https://www.youtube.com/watch?v=RynMOvYdsCg

### Fundamentals of Google Cloud Platform: A Guided Tour (GDD Europe '17)
https://www.youtube.com/watch?v=r0zCs2b_ReY
