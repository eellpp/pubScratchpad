## References

- http://www.oopweb.com/Java/Documents/JavaNotes/VolumeFrames.html

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


One example of appropriate public instance variables is the case where the class is essentially a data structure, with no behavior. *In other words, if you would have used a struct instead of a class (if Java supported struct), then it's appropriate to make the class's instance variables public.*
