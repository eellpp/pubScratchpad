
### Reading from App properties file

```java

Properties prop = new Properties();
prop.load(Classname.class.getClassLoader().getResourceAsStream("foo.properties"));
String value = prop.getProperty("key")

```

### Setting system properties with -D option
A JVM runs with a number of system properties. You can configure system properties by using the -D option, pronounced with an upper case 'D'

java -Dfile.encoding=utf-8

You can then grab the value programatically as

System.getProperty("file.encoding"); 

