

### Use Input Stream
InputStream anyInputStream = new ByteArrayInputStream("test data".getBytes());

### create bytes array and use fill it with random

```java

byte [] bytes = new byte[50];

Random random = new Random();
random.nextBytes(bytes)

InputStream anyInputStream = new ByteArrayInputStream(bytes);
```