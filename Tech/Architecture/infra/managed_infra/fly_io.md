https://fly.io/docs/getting-started/python/.  

fly.io is really a way to run Docker images on servers in different cities and a global router to connect users to the nearest available instance. We convert your Docker image into a root filesystem, boot tiny VMs using an Amazon project called Firecracker, and then proxy connections to it. As your app gets more traffic, we add VMs in the most popular locations.  

https://blog.hartleybrody.com/thoughts-on-flyio/.   

If you want a $5/mo server in 4 places, that’s $20/month, which makes sense. But also, I don’t know when I’d want to pay 4x the hosting costs just to “reduce latency” for most applications. I’d rather spend that on a bigger database or cache server for likely a much bigger performance boost.   

They also promote the idea of having a local read replica of your database running alongside each instance of your app, but this complicates the picture for writes (which must still be centralized) and eventual consistency.   


It seems like it’s a service that’s really geared for apps that can live in a truly distributed way to be “close to the user” and not worry too much about consistent state. From their HN launch thread the founder mentions these use cases

- image, video, audio processing near consumers
- game or video chat servers running near the centroid of people in a session
- server side rendering of single page js apps
- route users to regional data centers for compliance
- graphql stitching / caching (we do this!)
- pass through cache for s3, or just minio as a global s3 (we do this!)
- buildkite / GitHub Action agents (we do this!)
- tensorflow prediction / DDoS & bot detection
- load balance between spot instances on AWS/GCP
- TLS termination for custom domains
- authentication proxy / api gateway (we do this!)
- IoT stream processing near devices
