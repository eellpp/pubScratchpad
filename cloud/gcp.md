
gsutils ls <bucket path>
gsutil ls gs://dataproc-initialization-actions

## useful commands

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
