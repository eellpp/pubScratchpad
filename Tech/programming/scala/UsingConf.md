
 
 ### Referencing variables from application.conf
 First, we need to define our configuration file, let’s call it application.conf.
```java
// application.conf
my {
    secret {
        value = "super-secret" 
    }
}
```
We can now parse the file and use the obtained configuration in our script:
```java
// config-tutorial.scala
import com.typesafe.config.ConfigFactory
 
val value = ConfigFactory.load().getString("my.secret.value")
println(s"My secret value is $value")

>> scala config-tutorial.scala 
My secret value is super-secret
```

 ### Using profile specific application.conf (DEV/PROD)
 
 I usually store my DEV settings in the default application.conf file then I create a new conf file for other environments and include the default one.

Let's say my DEV conf application.conf looks like this:

myapp {
    server-address = "localhost"
    server-port = 9000

    some-other-setting = "cool !"
}
Then for the PROD, I could have another file called prod.conf:

include "application"

# override default (DEV) settings
myapp {
    server-address = ${PROD_SERVER_HOSTNAME}
    server-port = ${PROD_SERVER_PORT}
}
Note that I override only the settings that change in the PROD environment (some-other-setting is thus the same as in DEV).

The config bootstrap code doesn't test anything

...
val conf = ConfigFactory.load()
...
To switch from the DEV to the PROD conf, simply pass a system property with the name of the config file to load:

java -Dconfig.resource=prod.conf ...
In DEV, no need to pass it since application.conf will be loaded by default.
