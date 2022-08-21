Some programming languages (e.g., C++) are translated into instructions that run directly on hardware. We speak of compiling programs in that language onto a specific hardware architecture.  
Other programming languages (e.g., Java and Python) are translated to run on a common architecture: interpreters (or virtual machines) for that architecture can be written in a low-level language  
(like C, which targets most architectures), so that exactly the same translated programs can run on any architecture that has the  virtual machine program implemented on it.

Python and Java are both interpreted languages. The intermediate byte code is run by the VM


Python code - - - > Interpreter produced Byte Code - - ->Run in Python Virtual Machine - - -> Converts to h/w specific instructions run by CPU

The reference interpreter of Python, the one that the others use as a guide, is written in C, and it is nicknamed `CPython` (not to be confused with Cython, which isn't an interpreter).  
It compiles Python code to Python bytecode and runs it on its virtual machine, which is also written in C.

Python interpreter contains the  `Python Virtual Machine` where the byte code is run. The default interpreter is known as CPython virtual machine

There are other interpreters. Here are a few that are most well-known.  

`PyPy`:  written in RPython (a stricter branch of Python), which compiles Python to PyPy bytecode (mostly the same as CPython bytecode) and runs it on its virtual machine.    
PyPy uses just-in-time (JIT) compilation to translate Python code into machine-native assembly language.  
 More info: http://doc.pypy.org/en/latest/interpreter.html  

`Jython`:  written in Java, which compiles Python to Java bytecode, and runs it on the Java Virtual Machine. It allows Python code to call Java code. Somehow.  

`IronPython`:  written in C# (some of which is apparently written BY Python), which compiles Python to Microsoft's CLI (correct me if I'm wrong) bytecode, and runs it on the corresponding virtual machine.  


Theoretically and ideally, all strictly-legal Python code should run the same on any of these. Think of it like different compilers for C: strictly-legal C code will compile to equivalent programs on any of the compilers


CPython compiles Python to intermediate bytecode that is then interpreted by a virtual machine.  

Python Shell lets users use the dehttps://stackoverflow.com/questions/441824/java-virtual-machine-vs-python-interpreter-parlancefault python interpreter in interactive mode.  


### Execution Steps
The Python interpreter performs following tasks to execute a Python program :

`Step 1` : The interpreter reads a python code or instruction. Then it verifies that the instruction is well formatted, i.e. it checks the syntax of each line.If it encounters any error, it immediately halts the translation and shows an error message.  
`Step 2` : If there is no error, i.e. if the python instruction or code is well formatted then the interpreter translates it into its equivalent form in intermediate language called “Byte code”.Thus, after successful execution of Python script or code, it is completely translated into Byte code.  
`Step 3` : Byte code is sent to the Python Virtual Machine(PVM).Here again the byte code is executed on PVM.If an error occurs during this execution then the execution is halted with an error message.  

### Why Java Virtual Machine but python Interpreter
https://stackoverflow.com/questions/441824/java-virtual-machine-vs-python-interpreter-parlance  

Python was initially designed as a kind of scripting programing language which interprets scripts (programs in the form of the text written in accordance with the programming language rules). Due to this, Python has initially supported a dynamic interpretation of one-line commands or statements, as the Bash or Windows CMD do. For the same reason, initial implementations of Python had not any kind of bytecode compilers and virtual machines for execution of such bytecode inside, but from the start Python had required interpreter which is capable to understand and evaluate Python program text.

Currently, Python also has the virtual machine under the hood and can compile and interpret Python bytecode.   


### Python and Java are both Interpreted languages, then why python is much slower
Dynamically typed languages must make all of their checks at runtime because the type might change during the course of the execution.

Static typed languages resolve all types during compile time so the cost is consumed up front, one time.

In a dynamically typed language, the storage associated with each variable contains a numeric code that says what type is currently stored in that variable, in addition to the actual value. If you want to add 3 to a variable ‘x’, the language run-time system first looks at the type code for variable ‘x’ to see if it’s something that 3 can be added to, then performs the operation. Some languages, finding that ‘x’ is a character string, might go so far as to try to convert it to a number, and then add 3 to it if it could successfully be converted.

These extra steps make dynamically typed languages slower.

  



