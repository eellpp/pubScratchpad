## References

- http://www.oopweb.com/Java/Documents/JavaNotes/VolumeFrames.html


### Difference between system.properties and environment variables
System properties are set on the Java command line using the -Dpropertyname=value syntax. They can also be added at runtime using System.setProperty(String key, String value) or via the various System.getProperties().load() methods.   

To get a specific system property you can use System.getProperty(String key) or System.getProperty(String key, String def).   

Environment variables are set in the OS, e.g. in Linux export HOME=/Users/myusername or on Windows SET WINDIR=C:\Windows etc, and, unlike properties, may not be set at runtime.   

To get a specific environment variable you can use System.getenv(String name).


## Why use OutputBufferedStream
Java has two kinds of classes for input and output (I/O): streams and readers/writers.

Streams (InputStream, OutputStream and everything that extends these) are for reading and writing binary data from files, the network, or whatever other device.

Readers and writers are for reading and writing text (characters). They are a layer on top of streams, that converts binary data (bytes) to characters and back, using a character encoding.

A stream is the connection and actual information being passed between points. The buffer is a storage container which stores part or all of the streamed data and feeds this to the output device.
If the stream slows beyond the data rate required to show the data, then the output would pause. The buffer prevents this.

```java 
BufferedReader br=new BufferedReader(new InputStreamReader(System.in));
```

InputStreamReader is the clπass to read the input stream of bytes.But to read each byte is expensive operation so we are wrapping it around BufferedReader to have it buffered


##  When to use getters and setters

(stackoverflow)[http://stackoverflow.com/a/36891]

Use common sense really. If you have something like:
```java
public class ScreenCoord2D{
    public int x;
    public int y;
}
```
Then there's little point in wrapping them up in getters and setters. You're never going to store an x, y coordinate in whole pixels any other way. Getters and setters will only slow you down.

On the other hand, with:
```java
public class BankAccount{
    public int balance;
}
```
You might want to change the way a balance is calculated at some point in the future. This should really use getters and setters.

It's always preferable to know why you're applying good practice, so that you know when it's ok to bend the rules.

http://stackoverflow.com/a/8565711

One example of appropriate public instance variables is the case where the class is essentially a data structure, with no behavior. *In other words, if you would have used a struct instead of a class (if Java supported struct), then it's appropriate to make the class's instance variables public.*
