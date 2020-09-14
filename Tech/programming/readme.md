
## Languages 

#### Python
[python/](./python/)

#### Javascript
[javascript](./javascript/)

#### Java
[java/](./java/)

#### Scala
[scala/](./scala/)

#### C
Compiling C Code  
https://www.geeksforgeeks.org/compiling-a-c-program-behind-the-scenes/  

test.c on compilation produces  
1) test.i : preprocessor output file  
2) test.s : assembly code  
3) test.o : object file
4) test.exe : executable file

A .c file is the source file that is written by the programmers in C-Language. When we compile a .c file, it is first submitted to the c-preprocessor for code substitutions. The C-Preprocessor substitutes codes from header files and macros defined by #define. All of these header files and macros are substituted from preprocessor directives. After substituing the codes, the C-precprocess generates the .i file. The .i file contains substituted code written in the source language which is further submitted to the compiler which converts the .i file into a .s file which consists of code in assembly level. The .s file is then passed to the assembler for further processing which converts the .s file into .o file which contains the object code. The .o file is an incomplete object file as it does not contain references to external subroutines and therefore cannot be executed directly by the operating system. When we execute a c-program for the first time, the .o file is passed through a linker which performs linking and generates a linked version of the program and is writes it into a .exe file. The .exe file is a complete object file with references to external subroutines and linkage to all sorts of dlls. The .exe files can be executed directly by the operating system.


### Programming Tools

##### Git
[git/](./git/)

- [branching](./git/branching.md)
- [merge](./git/merge.md)
- [security](./git/security.md)
- [writing_git_pr.md](./writing_git_pr.md) 