

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
`javascript`: console.log(NaN == NaN) => false ; console.log(null == null) => true  
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
vvar t1 = true
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

#true value
#key in dict
```
`bash`:  |  


`javascript`: |  
`python`: |   
`bash`:  |  
