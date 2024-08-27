
flashcards based on the key concepts from the document 

### Flashcards on Java I/O

| **Question**                                                              | **Answer**                                   |
|---------------------------------------------------------------------------|----------------------------------------------|
| What is the purpose of `InputStream` in Java?                             | To read bytes of data from an input source   |
| How does `FileInputStream` work?                                          | It reads bytes from a file                   |
| What does `BufferedInputStream` do?                                       | Buffers input to provide efficient reading of bytes |
| What is the difference between `Reader` and `InputStream`?                | `Reader` is for reading characters, `InputStream` is for reading bytes |
| How does `FileReader` work?                                               | It reads characters from a file              |
| What is the purpose of `BufferedReader`?                                  | Buffers character input for efficient reading |
| How do `OutputStream` and `InputStream` differ?                           | `OutputStream` writes data, `InputStream` reads data |
| What does `FileOutputStream` do?                                          | Writes bytes to a file                       |
| What is the benefit of using `BufferedOutputStream`?                      | Buffers output to improve performance        |
| How does `PrintWriter` differ from `FileWriter`?                          | `PrintWriter` provides formatted output capabilities |
| What is `DataInputStream` used for?                                       | Reads primitive data types from an input stream |
| How does `ObjectOutputStream` work?                                       | Serializes objects to an output stream       |
| What does `ObjectInputStream` enable in Java I/O?                         | Deserializes objects from an input stream    |
| How is `RandomAccessFile` different from other I/O streams?               | It allows reading and writing to a file at any position |
| What is the purpose of `PipedInputStream` and `PipedOutputStream`?        | To enable communication between threads via I/O |
| How does `FileChannel` work with I/O?                                     | It provides an efficient way to transfer data between files and buffers |
| How does `InputStreamReader` work?                                        | Converts byte streams to character streams   |
| What is the use of `OutputStreamWriter`?                                  | Converts character streams to byte streams   |
| What does `PrintStream` offer over `OutputStream`?                        | It provides methods for writing formatted data |
| How does `Scanner` improve file reading in Java?                          | It simplifies reading text by parsing primitive types and strings |



`Input Stream` : Read data from a source

`Output Stream` : Write data to destination

Three kind of stream
1) Byte Stream
- FileInputStream
- FileOutputStream
2) Character Stream
- FileReader and FileWriter
- InputStreamReader and OutputStreamWriter
3) Buffered Stream
- BufferedInputStream and BufferedOutputStream (Byte)
- BufferedReader and BufferedWriter (Character)

The ones ending in Reader/Writer are character Streams (w/o buffered). The ones ending in Stream are byte stream (w/o buffered)
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


### Reading and Writing files
- FileReader
- BufferedReader
- Scanner

```java
BufferedReader reader = Files.newBufferedReader(Paths.get("filepath"), Charset.forName("UTF-8")) // NIO api
List contents = Files.readAllLines(Paths.get("filepath")); // NIO api
Files.lines(Paths.get("filepath")).forEach(System.out::println);//print each line in java8 stream

File file = new File("filename.txt");
BufferedReader br = new BufferedReader(new FileReader(file)); // from char stream
BufferedReader br = new BufferedReader(new InputStreamReader(file)); // from char Stream
BufferedReader br = new BufferedReader(new FileInputStream(file)); // from byte stream 
```

 A simple text scanner which can parse primitive types and strings using regular expressions.
A Scanner breaks its input into tokens using a delimiter pattern, which by default matches whitespace. The resulting tokens may then be converted into values of different types using the various next methods.

```java
Scanner sc = new Scanner(file);
Scanner sc = new Scanner(file).useDelimiter("\\s"); // to split text to words
```


### FileWriter vs OutputStreamWriter

```java
Writer writer = new FileWriter("test.txt");
Writer writer = new OutputStreamWriter(new FileOutputStream("test.txt"));
```
FileWriter is convinience. File writer writes in default characterset. The recommended way is to use the OutpuStreamWriter with proper character encoding.




