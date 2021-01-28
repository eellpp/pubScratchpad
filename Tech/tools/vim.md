
### Set Encryption key
set cm=blowfish2  

You use encryption by pressing :X within a vim session. You will be asked for a pass phrase (twice), and from now on that file will be saved in encrypted mode. You will see [blowfish2] on the status line at bottom when you write out the file. A salt is used, so each subsequent encryption of the same cleartext with the same pass phrase generates different ciphertext.

The next time you try to open the file, you will be asked for the pass phrase. Anything other than the correct pass phrase puts you into a buffer of ciphertext gibberish.

Add these to the vimrc for the account you are using to have encrypted files:   
set cm=blowfish2  
set viminfo=  
set nobackup  
set nowritebackup  

### viminfo
The viminfo file is used to store:
- The command line history.
- The search string history.
- The input-line history.
- Contents of non-empty registers.
- Marks for several files.
- File marks, pointing to locations in files.
- Last search/substitute pattern (for 'n' and '&').
- The buffer list.
- Global variables

### g Command

https://vim.fandom.com/wiki/Power_of_g  
:[range]g/pattern/cmd  

##### Delete all lines matching a pattern.  
:g/pattern/d  

##### Copy lines Matching Pattern  
qaq  
:g/pattern/y A  
:let @+ = @a  
The first command clears register a. The second appends all matching lines to that register. The third copies register a to the clipboard (register +) for easy pasting into another application.  

##### Delete all lines that do not match a pattern.    
:g!/pattern/d  

##### Copy all lines matching a pattern to end of file.  
:g/pattern/t$  

##### Move all lines matching a pattern to end of file.  
:g/pattern/m$  

##### Reverse a file (just to show the power of g).  
:g/^/m0


### Find number of matches of a pattern
User the substitute command 's' with the n flag  
:%s/pattern//n

### Remove duplicate lines
:sort u

### Ignore case in search pattern
:set ic  
:set ignorecase  
:set noic  

### show linenumbers
:set number  
:set nonumber  

### Delete From current position to end of search pattern
d/<pattern>
