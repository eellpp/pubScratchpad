
The reference interpreter of Python, the one that the others use as a guide, is written in C, and it is nicknamed `CPython` (not to be confused with Cython, which isn't an interpreter).  
It compiles Python code to Python bytecode and runs it on its virtual machine, which is also written in C.

There are other interpreters. Here are a few that are most well-known.  

`PyPy`:  written in RPython (a stricter branch of Python), which compiles Python to PyPy bytecode (mostly the same as CPython bytecode) and runs it on its virtual machine.    
PyPy uses just-in-time (JIT) compilation to translate Python code into machine-native assembly language.  
 More info: http://doc.pypy.org/en/latest/interpreter.html  

`Jython`:  written in Java, which compiles Python to Java bytecode, and runs it on the Java Virtual Machine. It allows Python code to call Java code. Somehow.  

`IronPython`:  written in C# (some of which is apparently written BY Python), which compiles Python to Microsoft's CLI (correct me if I'm wrong) bytecode, and runs it on the corresponding virtual machine.  


Theoretically and ideally, all strictly-legal Python code should run the same on any of these. Think of it like different compilers for C: strictly-legal C code will compile to equivalent programs on any of the compilers


CPython compiles Python to intermediate bytecode that is then interpreted by a virtual machine. 


