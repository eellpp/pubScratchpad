
 `echo test  2>&1`  
 The above redirect the stderr to stdout  
 The below one redirects the stdout then to output.log. Thus the output file contains both stdout and stderror  
 `echo test  2>&1  > output.log`  
 
 
stdin, stdout, and stderr are normally numbered 0 through 2 respectively. 

When you're directing input and output on the shell (usually) the default is to wire up things as they'd make sense, but (without any IFS characters) a number on either side of the redirection operator codes tells the shell to grab a different input or output.

These will yield different results due to left to right parsing:

  echo test >/tmp/test 2>&1  
  echo test 2>&1 >/tmp/test  
In the second if there were any errors they'd be sent to the file, while in the first (assuming you can make temporary files, which normally you can) there won't be any errors printed but they would be sent as standard output on the shell.
