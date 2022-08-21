

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
```bash
if [[ $VAR -gt 10 ]] && [[ $VAR1 -ge $VAR3 ]]
then
  echo "The variable is greater than 10."
elif [[ $VAR -eq 10 ]]
then
  echo "The variable is equal to 10."
else
  echo "The variable is less than 10."
fi

## Check empty variable in if statement
if [[ -z $VAR ]] # - True if the VAR is empty.

## Check of file exists and is readable
if [[ -r FILE ]] # - True if the FILE exists and is readable.
```

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

**`bash`**  
```bash
#The let command is used to evaluate arithmetic expressions on shell variables
# Using let is similar to enclosing an arithmetic expression in double parentheses (( .. ))
let "v1=2"
let "v2=3"
let "v3 = v1 + v2"
echo $v3 #5
# Variables used in expressions have scope local to the command. So, for instance, an argument to let will not be aware of other shell variables, unless they are exported.

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


let object1 = {value: 10};
let object2 = object1;
let object3 = {value: 10};
console.log(object1 == object2);
// → true
console.log(object1 == object3);
// → false
object1.value = 15;
console.log(object2.value);
// → 15
console.log(object3.value);
// → 10
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

### For Loop

**`javascript`:**  
```javascript
for (let number = 0; number <= 12; number = number + 2) {
  console.log(number);
}

// works for arrays, strings and other data structures
for (let entry of JOURNAL) {
  console.log(`${entry.events.length} events.`);
}
```
**`python`:**    
```python
for number in numbers:
     print(number)
new_numbers = [i + 10 for i in numbers if i % 2] 
```

**`bash`**  
```bash
for i in 1 2 3 4 5
do
   echo "Welcome $i times"
done
```

### Functions
A function definition is a regular binding where the value of the binding is a function  

**`javascript`:**  
```javascript
const square = function(x) { return x * x;};
console.log(square(12));

// Arrow functions : Instead of the function keyword, it uses an arrow (=>) 
const power = (base, exponent) => {
  let result = 1;
  for (let count = 0; count < exponent; count++) {
    result *= base;
  }
  return result;
};

// for single param can ignore brackets
const square2 = x => x * x;
const horn = () => { console.log("Toot");};

```
**`python`:**    
```python
```

**`bash`**  
```bash
function quit {
   exit
}  
function e {
    echo $1 
}  
e Hello
e World
quit
```

### Function Default Params
**`javascript`:**  
https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Default_parameters  

```javascript
function connect(hostname = "localhost",
                 port = 80,
                 method = "HTTP") {
  ...
}

// uses defaults for all parameters (connects to localhost over HTTP)
connect();
// overrides hostname, keeps port=80 and method=HTTP
connect('www.google.com');
// overrides hostname, port, and method
connect('www.google.com', 443, 'HTTPS');
```

**`python`:**    
```python
def connect(hostname = "localhost",port = 80,method = "HTTP") :
 
// uses defaults for all parameters (connects to localhost over HTTP)
connect();
// overrides hostname, keeps port=80 and method=HTTP
connect(hostname = 'www.google.com');
// overrides hostname, port, and method
connect('www.google.com', 443, 'HTTPS');

```

**`bash`**  
```bash
```

### Closure
 A function that references bindings from local scopes around it is called a closure. This behavior not only frees you from having to worry about lifetimes of bindings but also makes it possible to use function values in some creative ways.
 
**`javascript`:**  
```javascript
function wrapValue(n) {
  let local = n;
  return () => local;
}
// the local bindings are preserved even when the caller function is gone
let wrap1 = wrapValue(1);
let wrap2 = wrapValue(2);
console.log(wrap1()); // → 1
console.log(wrap2()); // → 2
```
**`python`:**    
```python
def make_multiplier_of(n):
    def multiplier(x):
        return x * n
    return multiplier

# Multiplier of 3
times3 = make_multiplier_of(3)
# Multiplier of 5
times5 = make_multiplier_of(5)
# Output: 27
print(times3(9))
# Output: 15
print(times5(3))
# Output: 30
print(times5(times3(2)))
```
**`bash`**  
```bash

## Data Structures


**`javascript`:**  
```javascript
let sequence = [1, 2, 3];
sequence.push(4);
sequence.pop()
sequence.length
// search for item. Returns -1 if not found
sequence.indexof(3)
//slice
sequence.slice(1) // all items from 1
sequence.slice(1,3) // items from 1 to 3

console.log(sequence.filter(s => s % 2)); // 1, 3
countries = [{'name':"india"},{'name':"france"}]
console.log(countries.filter(s => s.name.indexOf("d") > 0 )); // india
countries.findIndex(s => s.name == "india")
countries.find(s => s.name == "india")
countries.forEach(element => console.log(element.name));
// flatten list
t = [[1,2,3],[4,5,6]]
t.reduce((a,b) => a.concat(b))

// Strings all have array like methods
str.split(" ") // returns array
words.join(".")
str.trim()

//objects
let day1 = {
  squirrel: false,
  events: ["work", "touched tree", "pizza", "running"]
};
console.log(day1.squirrel);
// → false
console.log(day1.wolf);
// → undefined
day1.wolf = false;
console.log(day1.wolf);
// → false

// get the keys
console.log(Object.keys({x: 0, y: 0, z: 2}));
// → ["x", "y", "z"]

## looping over dicts
mydict = {a:1,b:2}
for (var k of Object.keys(mydict)){ console.log(k,a[k]) }

### looping over values
Object.values(mydict)

```
**`python`:**    
```python
mystr.split(" ")
".".join(words) 
arr[1:]

## looping for dictionaries
for k,v in {"a":1,"b":2}.items():
    print ...

```

**`bash`**  
```bash
myarray=(1 2 4 8 16 32 64 128)
myarray=(1 2 "three" 4 "five")
echo ${myarray[$i]}
//Second, to output all the elements of an array, we replace the numeric index with the @
echo ${myarray[@]}.

for t in ${myarray[@]}; do
  ./pipeline --threads $t
done

// declare dicts or associative array in bash
declare -A animals
animals=( ["moo"]="cow" ["woof"]="dog")
animals['key']='value' // to set value
"${animals[@]}" // to expand the values
"${!animals[@]}" // (notice the !) to expand the keys
for sound in "${!animals[@]}"; do echo "$sound - ${animals[$sound]}"; done

```

### JSON
**`javascript`:**  
```javascript
let string = JSON.stringify({squirrel: false,
                             events: ["weekend"]});
console.log(string);
// → {"squirrel":false,"events":["weekend"]}
console.log(JSON.parse(string).events);
// → ["weekend"]
```
**`python`:**    
```python
import json
// to string
json.dumps(['foo', {'bar': ('baz', None, 1.0, 2)}])
// parse  json from string
json.loads('["foo", {"bar":["baz", null, 1.0, 2]}]')

```

**`bash`**  
```bash
```

### OOP

**`javascript`:**
Javascript objects have prototype. This is a fallback source of properties.   
When an object gets a request for a property that it does not have, its prototype will be searched for the property, then the prototype’s prototype, and so on.  
The prototype relations of JavaScript objects form a tree-shaped structure, and at the root of this structure sits Object.prototype. It provides a few methods that show up in all objects, such as toString, which converts an object to a string representation.  
Many objects don’t directly have Object.prototype as their prototype but instead have another object that provides a different set of default properties. Functions derive from Function.prototype, and arrays derive from Array.prototype.  

```javascript
class Rabbit {
  constructor(type) {
    this.type = type;
  }
  speak(line) {
    console.log(`The ${this.type} rabbit says '${line}'`);
  }
}

let killerRabbit = new Rabbit("killer");
let blackRabbit = new Rabbit("black");
// Class declarations currently allow only methods—properties that hold functions—to be added to the prototype.

//When you add a property to an object, whether it is present in the prototype or not, the property is added to the object itself. If there was already a property with the same name in the prototype, this property will no longer affect the object, as it is now hidden behind the object’s own property.

Rabbit.prototype.teeth = "small";
console.log(killerRabbit.teeth);
// → small
killerRabbit.teeth = "long, sharp, and bloody";
console.log(killerRabbit.teeth);
// → long, sharp, and bloody
console.log(blackRabbit.teeth);
// → small
console.log(Rabbit.prototype.teeth);
// → small
```
**`python`:**    
```python
```

**`bash`**  
```bash
```


---
---

**`javascript`:**  
```javascript
```
**`python`:**    
```python
class Person:
  def __init__(self, name, age):
    self.name = name
    self.age = age

p1 = Person("John", 36)

print(p1.name)
print(p1.age)
```

**`bash`**  
```bash
```
