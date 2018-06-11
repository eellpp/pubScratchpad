JVM stays on the top of the operating system and provides abstraction between the compiled java program and operating system. This way, java compiled program doesn’t have to worry about which platform it has to work. Java program compiles code into bytecodes which JVM can understand and execute.

When JVM compiles the class file, it doesn’t complete the full class file; it compiles only a part of it on need basis. This avoids heavy parsing of complete source code. This type of compilation is termed as JIT or Just-In-Time compilation. JVM is Platform(OS) dependent Code generation JIT is Platform Oriented, generates the native byte code, so it is faster one than JVM :)

JVM compiles bytecode methods into native machinecode methods store these methods in the "Perm Gen" in Java <= 7 and "meta space" in Java 8.

the execution engine ( that is usually written in C / C++ ) invokes these JIT compiled functions

### Why Jit is faster ?
 When you go to the dynamic compiler, you get two advantages when the compiler’s running right at the last moment. One is you know exactly what chipset you’re running on. So many times when people are compiling a piece of C code, they have to compile it to run on kind of the generic x86 architecture. Almost none of the binaries you get are particularly well tuned for any of them. You download the latest copy of Mozilla,and it’ll run on pretty much any Intel architecture CPU. There’s pretty much one Linux binary. It’s pretty generic, and it’s compiled with GCC, which is not a very good C compiler.

When HotSpot runs, it knows exactly what chipset you’re running on. It knows exactly how the cache works. It knows exactly how the memory hierarchy works. It knows exactly how all the pipeline interlocks work in the CPU. It knows what instruction set extensions this chip has got. It optimizes for precisely what machine you’re on. Then the other half of it is that it actually sees the application as it’s running. It’s able to have statistics that know which things are important. It’s able to inline things that a C compiler could never do. The kind of stuff that gets inlined in the Java world is pretty amazing. Then you tack onto that the way the storage management works with the modern garbage collectors. With a modern garbage collector, storage allocation is extremely fast.
https://stackoverflow.com/a/5610085
