
IO Streams are a core concept in Java IO. A stream is a conceptually endless flow of data. You can either read from a stream or write to a stream. A stream is connected to a data source or a data destination. Streams in Java IO can be either byte based (reading and writing bytes) or character based (reading and writing characters).

### Input vs Output Stream
An input stream is used to read data from the source. And, an output stream is used to write data to the destination

The Java InputStream class is the base class (superclass) of all input streams in the Java IO API. Each subclass of InputStream typically has a very specific use, but can be used as an InputStream. The InputStream subclasses are:

The read() method of an InputStream returns an int which contains the byte value of the byte read.   
If the read() method returns -1, the end of stream has been reached, meaning there is no more data to read in the InputStream.   

- int read()
- int read(byte[])
- int read(byte[], int offset, int length)

Reading an array of bytes at a time is faster than reading a single byte at a time from a Java InputStream. The difference can easily be a factor 10 or more in performance increase, by reading an array of bytes rather than reading a single byte at a time.  


```bash

ByteArrayInputStream
FileInputStream
PipedInputStream
BufferedInputStream
FilterInputStream
PushbackInputStream
DataInputStream
ObjectInputStream
SequenceInputStream
```

### use buffered Input Stream for speed up
You can add transparent, automatic reading and buffering of an array of bytes from an InputStream using a Java BufferedInputStream . The BufferedInputStream reads a chunk of bytes into a byte array from the underlying InputStream. You can then read the bytes one by one from the BufferedInputStream and still get a lot of the speedup that comes from reading an array of bytes rather than one byte at a time.

```java
InputStream input = new BufferedInputStream(
                      new FileInputStream("c:\\data\\input-file.txt"),
                        1024 * 1024        /* buffer size */
    );
```


### input stream reader
InputStreamReader is a class in Java that allows you to bridge the gap between byte streams (InputStream) and character streams (Reader). It reads bytes from an InputStream and decodes them into characters using a specified character encoding.

```java
InputStream inputStream = ...; // Your input stream
String encoding = "UTF-8"; // The character encoding

InputStreamReader reader = new InputStreamReader(inputStream, encoding);

```


### data Input Stream
DataInputStream is a class in Java that allows you to read primitive data types from an underlying input stream (InputStream). It provides methods to read data types such as boolean, byte, char, short, int, long, float, double, and String in a platform-independent way.

The DataInputStream class provides constructors that accept an InputStream as the source from which it reads data. Here's an example of creating a DataInputStream:


```java
InputStream inputStream = ...; // Your input stream

try (DataInputStream dataInputStream = new DataInputStream(inputStream)) {
    int intValue = dataInputStream.readInt();
    long longValue = dataInputStream.readLong();
    double doubleValue = dataInputStream.readDouble();
    String stringValue = dataInputStream.readUTF();
    boolean booleanValue = dataInputStream.readBoolean();
    byte byteValue = dataInputStream.readByte();

    // Process the read values
    System.out.println("int value: " + intValue);
    System.out.println("long value: " + longValue);
    System.out.println("double value: " + doubleValue);
    System.out.println("string value: " + stringValue);
    System.out.println("boolean value: " + booleanValue);
    System.out.println("byte value: " + byteValue);
} catch (IOException e) {
    // Handle the exception
}


```

It's worth noting that the DataInputStream class is primarily used for reading data that has been previously written using a DataOutputStream. It provides a convenient way to read and interpret the binary data in a specific format.


### Object Input Stream
The ObjectInputStream class is commonly used when you need to deserialize objects from a serialized form stored in an input stream. It allows you to recreate objects from their serialized representation, which can be useful in various scenarios. Here are some common use cases for ObjectInputStream:

```java
InputStream inputStream = ...; // Your input stream

try (ObjectInputStream objectInputStream = new ObjectInputStream(inputStream)) {
    Object object = objectInputStream.readObject();

    // Process the read object
    if (object instanceof MyClass) {
        MyClass myObject = (MyClass) object;
        // Do something with myObject
    } else if (object instanceof AnotherClass) {
        AnotherClass anotherObject = (AnotherClass) object;
        // Do something with anotherObject
    } else {
        // Handle unknown object type
    }
} catch (IOException | ClassNotFoundException e) {
    // Handle the exception
}
```

Object Persistence: ObjectInputStream is often used for reading objects stored in files or other persistent storage mechanisms. For example, if you have a file containing serialized objects, you can use ObjectInputStream to read and recreate those objects in memory.

Network Communication: When objects are transmitted over a network, they are typically serialized before sending and deserialized upon receiving. ObjectInputStream is used to deserialize objects received from a network stream, allowing you to reconstruct the objects on the receiving side.

Caching and Data Sharing: In some scenarios, you may want to cache objects in serialized form to improve performance or enable data sharing across different components of an application. ObjectInputStream allows you to read serialized objects from a cache or shared data source and recreate the objects as needed.

Interoperability and Integration: ObjectInputStream can be used for integrating components or systems implemented in different languages. For instance, if you have a Java system that needs to communicate with a system written in a different language and objects are serialized using a standard format (e.g., JSON), you can use ObjectInputStream to deserialize the objects received from the other system.

Application State Management: ObjectInputStream is useful for saving and restoring application state. You can serialize the state of an application, store it in a file or database, and later use ObjectInputStream to restore the application's state by deserializing the objects.
It's important to exercise caution when using ObjectInputStream since it involves deserializing data received from untrusted or potentially malicious sources. Deserialization vulnerabilities can be exploited to execute arbitrary code or perform other malicious actions. Ensure that you validate and sanitize the serialized data, and be cautious when deserializing objects from untrusted sources.

Overall, ObjectInputStream provides a convenient way to deserialize objects, enabling data persistence, network communication, and interoperability between different components or systems.

USES 

1) Java Serialization Framework: The core Java Serialization Framework itself extensively uses ObjectInputStream and ObjectOutputStream for serializing and deserializing objects. It is used for object persistence, interprocess communication, and storing objects in a serialized format.

2) Apache Kafka: Apache Kafka is a popular distributed streaming platform. It provides support for object serialization and deserialization using ObjectInputStream and ObjectOutputStream via the Kafka Serializer and Deserializer interfaces. It allows developers to configure custom serializers and deserializers to handle the serialization and deserialization of objects sent through Kafka topics.

3) Hibernate ORM: Hibernate is a widely used object-relational mapping (ORM) framework for Java. It provides support for object serialization and deserialization during the process of persisting and retrieving Java objects to/from a relational database. ObjectInputStream is used internally to deserialize objects retrieved from the database.

4) Spring Framework: The Spring Framework is a comprehensive framework for building Java applications. It includes support for object serialization and deserialization using ObjectInputStream and ObjectOutputStream. Spring provides utilities for serializing objects to various formats (such as JSON, XML, and binary) and deserializing them back to objects.

5) Apache Avro: Apache Avro is a data serialization system that provides a compact binary format for serialized data. It includes support for object serialization and deserialization using ObjectInputStream and ObjectOutputStream through Avro's specific serialization API.


### Sequence Input Streams
SequenceInputStream is a class that allows you to concatenate multiple input streams together to create a single sequential input stream. It enables you to read data from multiple sources as if they were a single continuous stream.

The SequenceInputStream class provides constructors that accept two or more input streams as parameters. Here's an example of creating a SequenceInputStream:

```java
InputStream inputStream1 = new ByteArrayInputStream("Hello, ".getBytes());
InputStream inputStream2 = new ByteArrayInputStream("World!".getBytes());

try (SequenceInputStream sequenceInputStream = new SequenceInputStream(inputStream1, inputStream2)) {
    int character;
    while ((character = sequenceInputStream.read()) != -1) {
        // Process the character
        System.out.print((char) character);
    }
} catch (IOException e) {
    // Handle the exception
}


```

USES

The SequenceInputStream allows Ant build tool to efficiently merge the contents of multiple files without loading the entire content into memory at once. It reads the files sequentially, minimizing memory usage and allowing large files to be concatenated.

