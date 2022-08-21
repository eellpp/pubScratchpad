
There are many ways of activating a profile in Spring. The popular ways are by environment variable or by jvm parameters

```java
-Dspring.profiles.active=dev
export spring_profiles_active=dev
```

We can also set the default profile when no other profile is set by setting `spring.profiles.default`

On local machine these can be manually setup as above. In the production, it could be part of the OS environment variables or the startup script which decides the spring profile based on some variable like 'box_type' which can be PROD|UAT|DEV

### Profile specific properties file
 profile specific properties file should be named as `applications-{profile}.properties`.
 
Spring Boot will automatically load the properties in an application.properties file for all profiles, and the ones in profile-specific .properties files only for the specified profile.
 
 
