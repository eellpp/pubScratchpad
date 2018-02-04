

### Facade over implementation
1) Apache commons login
2) SLF4J

SLF4J can be a facade over the commons logging itself. Facade over facade !

Logback is the native implementation of SLF4J

### Logging implementation 
1. Java Utils logging
2. Log4j2.x
3. Logback

### SLF4J with Log4J

Have to add these dependency in pom

- log4j-api
- log4j-core
- log4j-slf4j-impl

create the logger instance 
```java
private static Logger logger = LoggerFactory.getLogger(SLF4JExample.class);
public static void main(String[] args) {
        logger.debug("Debug log message");
        logger.info("Info log message");
        logger.error("Error log message");
    }
```

### SLF4J with logback
Since logback is the native implementations, the only dependency required to be added to pom is logback library
- logback-classic

### SLF4J features

having parameters in query, than string concat
```java
logger.debug("Printing variable value: {}", variable);
```

SLF4J will concatenate Strings only when the debug level is enabled. To do the same with Log4J you need to add extra if block which will check if debug level is enabled or not:
