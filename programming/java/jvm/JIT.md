JVM stays on the top of the operating system and provides abstraction between the compiled java program and operating system. This way, java compiled program doesn’t have to worry about which platform it has to work. Java program compiles code into bytecodes which JVM can understand and execute.

When JVM compiles the class file, it doesn’t complete the full class file; it compiles only a part of it on need basis. This avoids heavy parsing of complete source code. This type of compilation is termed as JIT or Just-In-Time compilation. JVM is Platform(OS) dependent Code generation JIT is Platform Oriented, generates the native byte code, so it is faster one than JVM :)

JVM compiles bytecode methods into native machinecode methods store these methods in the "Perm Gen" in Java <= 7 and "meta space" in Java 8.

the execution engine ( that is usually written in C / C++ ) invokes these JIT compiled functions
