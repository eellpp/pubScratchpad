
### Reading from properties file

```java

Properties prop = new Properties();
prop.load(Classname.class.getClassLoader().getResourceAsStream("foo.properties"));
String value = prop.getProperty("key")

```
