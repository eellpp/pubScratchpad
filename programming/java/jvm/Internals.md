The JVM is by definition a virtual machine, that is a software machine that simulates what a real machine does. Like real machines it has an instruction set, a virtual computer architecture and an execution model. It is capable of running code written with this virtual instruction set, pretty much like a real machine can run machine code.

HotSpot is an an implementation of the JVM concept, originally developed by Sun and now owned by Oracle. Used by both Oracle Java and OpenJDK. It  is called HotSpot because it seeks hot spots of use in the code (places where code is more intensively used) for "just-in-time" optimization. HotSpot is written mainly in C++, and was originally developed under Sun Microsystems

From JDK 7 itself, JRockit and HotSpot has been merged into single JVM, incorporating the best features from both.

1) 
This article explains the internal architecture of the Java Virtual Machine (JVM). 

http://blog.jamesdbloom.com/JVMInternals.html


2) 
Anatomy of JVM 

https://shipilev.net/jvm-anatomy-park/jvm-anatomy-park-complete.pdf

3) JVM Spec

https://docs.oracle.com/javase/specs/jvms/se8/jvms8.pdf
