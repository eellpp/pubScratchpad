Command pipelines already run in parallel. With the command:

command1 | command2  
Both command1 and command2 are started. If command2 is scheduled and the pipe is empty, it blocks waiting to read. If command1 tries to write to the pipe and its full, command1 blocks until there's room to write. Otherwise, both command1 and command2 execute in parallel, writing to and reading from the pipe.
