
`Input Stream` : Read data from a source

`Output Stream` : Write data to destination

Three kind of stream
1) Byte Stream
2) Character Stream
3) Buffered Stream

 ### Byte Stream 
 byte streams to perform input and output of 8-bit bytes

``` java
FileInputStream in = new FileInputStream("xanadu.txt");
FileOutputStream out = new FileOutputStream("outagain.txt");
int c;
while ((c = in.read()) != -1) {
    out.write(c);
}
```
Byte streams should only be used for the most primitive I/O. If the file contains character data then better to use character stream.
A byte stream is suitable for processing raw data like binary files.

### Character Stream
Java stores character values using Unicode conventions. If internationalization isn't a priority, you can simply use the character stream classes without paying much attention to character set issues. Later, if internationalization becomes a priority, your program can be adapted without extensive recoding.

```java
FileReader inputStream = new FileReader("xanadu.txt");
FileWriter outputStream = new FileWriter("characteroutput.txt");
int c;
while ((c = inputStream.read()) != -1) {
    outputStream.write(c);
}
```

#### Character Streams as wrappers for byte stream
Character streams are often "wrappers" for byte streams. The character stream uses the byte stream to perform the physical I/O, while the character stream handles translation between characters and bytes. FileReader, for example, uses FileInputStream, while FileWriter uses FileOutputStream.

#### InputStreamReader and OuputStreamWriter
There are two general-purpose byte-to-character "bridge" streams: `InputStreamReader` and `OutputStreamWriter`. Use them to create character streams when there are no prepackaged character stream classes that meet your needs. 

### Buffered Stream
Byte and Character stream are unbuffered IO.This means each read or write request is handled directly by the underlying OS. This can make a program much less efficient, since each such request often triggers disk access, network activity, or some other operation that is relatively expensive.

To reduce this kind of overhead, the Java implements buffered I/O streams. Buffered input streams read data from a memory area known as a buffer; the native input API is called only when the buffer is empty. Similarly, buffered output streams write data to a buffer, and the native output API is called only when the buffer is full.

A program can convert an unbuffered stream into a buffered stream using the wrapping idiom, where the unbuffered stream object is passed to the constructor for a buffered stream class. Here's how you might modify the constructor invocations in the CopyCharacters example to use buffered I/O:
```java
inputStream = new BufferedReader(new FileReader("xanadu.txt"));
outputStream = new BufferedWriter(new FileWriter("characteroutput.txt"));
```
There are four buffered stream classes used to wrap unbuffered streams: 
1) Wrapping Byte Stream
- BufferedInputStream
- BufferedOutputStream
2) Wrapping Character Stream
- BufferedReader
- BufferedWriter
