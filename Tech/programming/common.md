

`javascript`:  https://repl.it/languages/javascript  
`python`:  https://repl.it/languages/python3   
`bash`:  https://repl.it/languages/bash  

### Screen output
`javascript`:  console.log()  
`python`: print()  
`bash`: echo  


### Double Quotes and Single Quotes
`javascript` : There is really no difference in the end between using single or double quotes, meaning they both represent a string in the end  
`python`: here is no difference in single or double quoted string  
`bash`: Single quotes won't interpolate anything, but double quotes will  


### Concat
`javascript`:  "hello" + "World" , `${var1} ${var2}`  
`python`:    "hello" + "World" , f"{var1} {var2}"  
`bash`:  "${VAR1} ${VAR2}"  

### Type
`javascript`:  typeof  
`python`: type     
`bash`:   

### None
`javascript`: null  
`python`: None  
`bash`:   


### None Comparison
`javascript`: console.log(NaN == NaN) => false ; console.log(null == null) => true ; console.log(false == 0) => true 
`python`: print(None == None) => True   
`bash`:   

### Boolean
`javascript`: true/false , boolean operator: && ||  
`python`: True/False , boolean operator: and | or . & | are bitwise operators on integer values   
`bash`: Use string/value comparison, Boolean operator: && ||  =  
```bash
if [[ $varA == 1 && ($varB == "t1" || $varC == "t2") ]]; then
```

### If bool check
`javascript`: 
```javascript
var1=''
if(var1){console.log("Empty String")}
var t1 = true
if(t1){console.log("true value")}
var t2 = []
if(t2){console.log("empty list")}
var t3 = NaN
if(t3){console.log("Nan Check")}
var t4 = null
if(t4){console.log("null check")}

//true value
//empty list
```
`python`:   
```python
var1 = []
if var1:
  print("empty list")
var1 = True
if var1:
  print("true value")
var1 = {'k1':'v1'}
if 'k1' in var1:
  print("key in dict")
var1 = ''
if var1:
  print("Empty String")

#true value
#key in dict
```
`bash`:  

### Type cast
`javascript`: 
```javascript
console.log(Number('5.5'))
console.log(String(5.5))
```
`python`:    
```python
print(int('5'))
print(str(34))
```

### variable scope
`javascript`
```javascript
// `const` is a signal that the identifier won’t be reassigned.
// `let` is a signal that the variable may be reassigned, such as a counter in a loop, or a value swap in an algorithm. 
//         It also signals that the variable will be used only in the block it’s defined in, which is not always the entire containing function.
// `var` is now the weakest signal available when you define a variable in JavaScript. The variable may or may not be reassigned, 
//         and the variable may or may not be used for an entire function, or just for the purpose of a block or loop.
```

### Immutable

`javascript`  
```javscript
var statement = "I am an immutable value";
var otherStr = statement.slice(8, 17);
// the second line in no way changes the string in statement. In fact, no string methods 
// change the string they operate on, they all return new strings. 
// The reason is that strings are immutable – they cannot change, we can only ever make new strings.
var arr = [];
var v2 = arr.push(2);
//  Here the arr reference has been updated to contain the number, and v2 contains the new length of arr.
```
`python`:    
Objects of built-in types like (int, float, bool, str, tuple, unicode) are immutable.   
Objects of built-in types like (list, set, dict) are mutable.  
Custom classes are generally mutable.  

```python
a = [1,2,3]
b = [1,2,3]
c = a
print(f"Before:id a : {id(a)} ; c: {id(c)}")
a = [4]
print(f"After: id a : {id(a)} ; c: {id(c)}")
print(a == b)
print(c == a)
#Before:id a : 140091722773248 ; c: 140091722773248
#After: id a : 140091722774016 ; c: 140091722773248
#False
#False
```

### Import 
**`javascript`:**  
```javascript
```
**`python`:**    
```python
```

**`bash`**  
```bash
```

### Function signature

**`javascript`:**  
```javascript
```
**`python`:**    
```python
```

**`bash`**  
```bash
```

---
---
### Import 
**`javascript`:**  
```javascript
```
**`python`:**    
```python
```

**`bash`**  
```bash
```
