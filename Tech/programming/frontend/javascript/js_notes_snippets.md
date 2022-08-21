```javascript
```

### Data Types
`Primitive`
- Number
- String
- Boolean
- Null : This type can be assigned only the value null and is used to indicate a nonexistent or invalid reference.
- Undefined : This type is used when a variable has been defined but has not been assigned a value.
- Symbol:This type is used to represent unique constant values, such as keys in collections  

`Non Primitive`
- Symbol

### Object
Object is a container with properties  
```javascript
const car = {type:"Fiat", model:"500", color:"white"};  

const person = {
  firstName: "John",
  lastName : "Doe",
  id       : 5566,
  fullName : function() {
    return this.firstName + " " + this.lastName;
  }
};

```

### JavaScript is a prototypal object oriented language

- Nearly all objects in JavaScript are instances of Object which sits just below null on the top of a prototype chain.(Exceptions are primitive data types (boolean, number and string), and undefined.)  
- Objects are dynamic "bags" of properties
- When trying to access a property of an object, the property will not only be sought on the object but on the *prototype* of the object, the prototype of the prototype, and so on until either a property with a matching name is found or the end of the prototype chain is reached.
- any function can be added to an object in the form of a property. An inherited function acts just as any other property  
 

### Objects and prototypes
Every object in javascript has a prototype. This is simply another object from which it 'inherits' properties and methods. This concept is called prototypal inheritance and is the only form of inheritance which exist in javascript. Constructs such as the class keyword in javascript is merely syntactic sugar built on top of this prototypal inheritance system.  

JS inheritance with protype chain  
https://developer.mozilla.org/en-US/docs/Web/JavaScript/Inheritance_and_the_prototype_chain#inheritance_with_the_prototype_chain

When it comes to inheritance, JavaScript only has one construct: `objects`.  
Each object has a private property which holds *a link to another object* called its prototype.  
That *prototype object has a prototype of its own*, and so on until an object is reached with null as its prototype.   
By definition, null has no prototype, and acts as the final link in this prototype chain.

### Function
function is also an object   
has properties: length and name  
has methods: apply, call and bind  

```javascript
function Dog(name){
  console.log(`Name:${name}`)
}
Dog("coco")
// Shows Name:coco

var dog = Dog("coco") // dog is null
var dog = new Dog("coco") // dog is Object
```
To create an Object from function, use the new keyword   
Also the new keyword is use to create Object. 
When object is created by using the new keyword, then a constructor function is called which sets up the this keyword,sets up its values and returns this as instance of object  

```javascript
function Dog(name) {
  this.age = 12;
  this.show = () => {console.log(`Dog age: ${this.age}`, name: ${name})}
  console.log(`Dog name:${name}.this global:${this === global}`)
}

Dog("coco") //Prints: Dog name:coco.this global:true; returns null
dog = new Dog("coco") //Prints: Dog name:coco.this global:false; returns object
dog.age // 12
dog.show() // Dog age: 12, name: coco

```
**Every function has a prototype object property.  **

```javascript
Dog.prototype.bark = function () { console.log('woof'); };
var dog = new Dog('fluffie');
dog.bark(); //woof
dog.show() ; //Dog age: 12, name: fluffie
```

**Prototype Chain**  
```javascript
function Car(name) {
  this.name = name;
}
Car.prototype.start = function() {
  return "engine of "+this.name + " starting...";
};
var c1 = new Car("Santa Fe");
var c2 = new Car("Fiesta");
c2.speak = function() {
  console.log("Hello, " + this.start());
};
c2.speak();  //"Hello, engine of Fiesta starting..."
```
Car ---(prototype) ---> start()  
start() ---[[prototype]]--> (linked to Object with properties .tostring, .typeof etc )  
c1(with property name) ---[[prototype]]---> start()  
c2(with property name,speak) ---[[prototype]]---> start()  

where:  
- [[prototype]] is the internal linkage. This forms internal linkage chain.  
- \__proto__ is a public property of Object.prototype to access the [[Prototype]] linkage.  
```javascript
console.log(c1.__proto__ === Car.prototype);    // true
console.log(c1.__proto__ === c2.__proto__);     // true
```

Javascript provides method getPrototypeOf() also to get the internal [[Prototype]] linkage. 
So in the above code snippet, Object.getPrototypeOf(c1) and c1.__proto__ returns the same object.    
```javascript
console.log(c1.__proto__ === Object.getPrototypeOf(c1)); //true
```

```javascript
console.log(c1.constructor === Car);            // true
console.log(c1.constructor === c2.constructor); // true
```
Constructor is a function, called with new keyword in front of it but .constructor is a property.  
c1.constructor returns reference to Car function. .constructor property is not available on c1 object but it gets hold of it because of [[Prototype]] chain and .constructor is a property of Object.prototype.


**Difference between .prototype and Object.getPrototypeOf(<something>)**  
  
The difference is that .prototype will get the prototype of a specified constructor function's instances, while Object.getPrototypeOf() will get the prototype of the object specified inside the parentheses

 ```javascript
function MyConstructor() {}

var obj = new MyConstructor()

Object.getPrototypeOf(obj) === obj.prototype // false
Object.getPrototypeOf(obj) === MyConstructor.prototype // true

MyConstructor.prototype // MyConstructor {}
obj.prototype // undefined

MyConstructor.prototype.constructor === MyConstructor  // true
Object.getPrototypeOf(MyConstructor) === Function.prototype // true
```
https://stackoverflow.com/a/38972040
  
  
  ### Javascript classes
Behind the scenes, JavaScript classes are implemented using prototypes, which means that JavaScript classes have some differences from those in languages such as C# and Java.   
 
Js Class vs Composition via function     
https://www.toptal.com/javascript/es6-class-chaos-keeps-js-developer-up  


### Constructor function 
Constructor functions are invoked with the new keyword.   
The JavaScript runtime creates a new object and uses it as the this value to invoke the constructor function, providing the argument values as parameters. The constructor function can configure the object’s own properties using this, which is set to the new object.    
```javascript
function Dog(name) {
  this.name = name;
}
let dog = new Dog("fluffie")
```
https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function  

### Static methods and properties of constructor function
Properties and methods that are defined on the constructor function are often referred to as static  
```javscript
let Product = function(name, price) { 
  this.name = name;
  this.price = price;
}
Product.prototype.toString = function() {
  return `toString: Name: ${this.name}, Price: ${this.price}`;
}
Product.process = (...products) => products.forEach(p => console.log(p.toString()));
Product.process(new Product("Hat", 100, 1.2), new Product("Boots", 100));
```

### Modules
The **`export`** keyword is used to denote the features that will be available outside the module. By default, the contents of the JavaScript file are private and must be explicitly shared using the export keyword before they can be used in the rest of the application.   
The **`default`** keyword is used when the module contains a single feature  

```javascript
//in tax.js
export default function(price) { 
  return Number(price) * 1.2;
 }
 
 // calculate.js
 import calcTax from "./tax";
let taxedPrice = calcTax(100);
```
The import keyword is followed by an identifier, which is the name by which the function in the module will be known when it is used  

multiple named features for module
```javascript
//tax.js
export function calculateTax(price) { 
  return Number(price) * 1.2;
}
export default function calcTaxandSum(...prices) {
  return prices.reduce((total, p) => total += calculateTax(p), 0);
}

//util.js
import { calculateTax } from "./tax";
export function printDetails(product) {
  let taxedPrice = calculateTax(product.price);
  console.log(`Name: ${product.name}, Taxed Price: ${taxedPrice}`);
}
export function applyDiscount(product, discount = 5) { 
  product.price = product.price - 5;
}

// from calc.js
import calcTaxAndSum, { calculateTax } from "./tax";
import { printDetails, applyDiscount } from "./utils";
```



### Iterator
An iterator defines a function named next that returns an object with value and done properties: the value property returns the next value in the sequence, and the done property is set to true when the sequence is complete.  
```javascript
function makeRangeIterator(start = 0, end = Infinity, step = 1) {
    let nextIndex = start;
    let iterationCount = 0;

    const rangeIterator = {
       next() {
           let result;
           if (nextIndex < end) {
               result = { value: nextIndex, done: false }
               nextIndex += step;
               iterationCount++;
               return result;
           }
           return { value: iterationCount, done: true }
       }
    };
    return rangeIterator;
}
const it = makeRangeIterator(1, 10, 2);

let result = it.next();
while (!result.done) {
 console.log(result.value); // 1 3 5 7 9
 result = it.next();
}
```

### Generator
Writing iterators can be awkward because the code has to maintain state data to keep track of the current position in the sequence each time the next function is invoked. A simpler approach is to use a generator, which is a function that is invoked once and uses the yield keyword to produce the values in the sequence,  

Generator functions are denoted with an asterisk 


```javascript
function* makeRangeIterator(start = 0, end = 100, step = 1) {
    let iterationCount = 0;
    for (let i = start; i < end; i += step) {
        iterationCount++;
        yield i;
    }
    return iterationCount;
}
```

### Iterable objects 
The Symbol.iterator property is used to denote the default iterator for an object. Using the Symbol.iterator value as the name for a generator allows the object to be iterated directly.

```javascript
const myIterable = {
    *[Symbol.iterator]() {
        yield 1;
        yield 2;
        yield 3;
    }
}

for (let value of myIterable) {
    console.log(value);
}
// 1
// 2
// 3

or

[...myIterable]; // [1, 2, 3]
```
Instead of above we could have written and explicit generator function and called as   
[...myIterable.mygenerator()]  
Having a default iterator is more elegant syntax  


### Using objects as storage of collections
We can iterate on the keys/values of an object using the methods  
Object.keys(obj)  
Object.values(obj)  

```javascript
let data = {
hat: new Product("Hat", 100)
}
data.boots = new Product("Boots", 100); 
Object.keys(data).forEach(key => console.log(data[key].myFunc()));
```  
Above iteration can be done only on string value  
Using Map , we can iterate on different value types  

```javascript
class Product {
    constructor(name, price) {
  this.name = name;
  this.price = price; 
  }
  toString() {
    return `toString: Name: ${this.name}, Price: ${this.price}`;
  } 
  }
let data = new Map();
data.set("hat", new Product("Hat", 100)); 
data.set("boots", new Product("Boots", 100));
[...data.keys()].forEach(key => console.log(data.get(key).toString()));
```  




### Chain of custom prototypes with setPropertyOf
```javascript
let ProductProto = {
    toString: function() {
return `toString: Name: ${this.name}, Price: ${this.price}`; }
}
let hat = { name: "Hat",
    price: 100,
    getPriceIncTax() {
return Number(this.price) * 1.2; }
};
let boots = { name: "Boots",
    price: 100,
    getPriceIncTax() {
return Number(this.price) * 1.2; }
}
Object.setPrototypeOf(hat, ProductProto); Object.setPrototypeOf(boots, ProductProto);
console.log(hat.toString()); console.log(boots.toString());
```


### Array
JavaScript arrays follow the approach taken by most programming languages, except they are dynamically resized and can contain any combination of values and, therefore, any combination of types.   

methods:   
concat(),copyWithin(),entries(),every(),fill(),filter(),find(),findIndex(),forEach(),from(),includes(),indexOf(),isArray(),join(),keys(),lastIndexOf(),map(),pop(),push(),reduce(),reduceRight(),reverse(),shift(),slice(),some(),sort(),splice(),toString(),unshift(),valueOf()  

### Set
Set is a collection of unique values.  

methods:  
new Set(),add(),delete(),has(),clear(),forEach(),values(),keys(),entries()   

### Map
methods:  
new Map(),set(),get(),clear(),delete(),has(),forEach(),entries(),keys(),values(),  

let fruits = new Map([["apples", 500],["bananas", 300],["oranges", 200]]);  
fruits.get("apples")  
fruits.set("kiwi",300)  


### Spread Operator
The spread operator can be used to expand the contents of an array so that its elements can be used as arguments to a function. The spread operator is three periods (...) 

```javascript
function sumPrices1(a,b,c){
  return a + b +c 
}
function sumPrices2(...numbers){
  return numbers.reduce((a,b) => a + b, 0)
}
let prices = [100,200,300];
let totalPrice = sumPrices1(...prices);
let totalPrice = sumPrices2(...prices);
```

The spread operator can be used to copy the values of object into another object
```javascript
let otherHat = { ...hat };
```

Adding, replacing and absorbing properties
```javascript
let hat = { name: "Hat",price: 100 };
let boots = { name: "Boots",price: "100" }

let additionalProperties = { ...hat, discounted: true}; 
console.log(`Additional: ${JSON.stringify(additionalProperties)}`);
let replacedProperties = { ...hat, price: 10}; 
console.log(`Replaced: ${JSON.stringify(replacedProperties)}`);
let { price , ...someProperties } = hat; 
console.log(`Selected: ${JSON.stringify(someProperties)}`);
```
output is   
Additional: {"name":"Hat","price":100,"discounted":true}     
Replaced: {"name":"Hat","price":10}  
Selected: {"name":"Hat"}  


### unpack Array
```javascript
let names = ["Hat", "Boots", "Gloves"];
let [one, two] = names;
let [, , three] = names;
```
The last variable name in a destructuring assignment can be prefixed with three periods (...), known as the rest expression or rest pattern, which assigns any remaining elements to an array

The prices array is sorted, the first element is discarded, and the remaining elements are assigned to an array named highest,
```javascript
let prices = [100, 120, 50.25];
let [, ...highest] = prices.sort((a, b) => a - b);
```

### Arrow functions
Arrow functions—also known as fat arrow functions or lambda expressions—are an alternative way of concisely defining functions and are often used to define functions that are arguments to other functions.  

```javascript
let sumPrices = (...numbers) => numbers.reduce((total, val) => total + (Number.isNaN(Number(val)) ? 0 : Number(val)));  
```



### Rest Parameter
A rest parameter is an array containing all the arguments for which parameters are not defined. The function below defines only a rest parameter, which means that its value will be an array containing all of the arguments used to invoke the function.   

```javascript
function sumPrices(...numbers) {
return numbers.reduce(function(total, val) {
        return total + val
    }, 0);
}
let totalPrice = sumPrices(hatPrice, bootsPrice);
totalPrice = sumPrices(100, 200, 300);  
```

### Object type
This is the only non primitive type  

```javascript
let gloves = { productName: "Gloves", price: "40"}
gloves.name = gloves.productName; 
delete gloves.productName; 
gloves.price = 20;
```
Because the shape of an object can change, setting or getting the value of a property that has not been defined is not an error. If you set a nonexistent property, then it will be added to the object and assigned the specified value. If you read a nonexistent property, then you will receive undefined. One useful way to ensure that code always has values to work with is to rely on the type coercion feature and the nullish or logical OR operators.  

```javascript

let propertyCheck = hat.price ?? 0;
let objectAndPropertyCheck = hat?.price ?? 0;
console.log(`Checks: ${propertyCheck}, ${objectAndPropertyCheck}`);

```
?? operator will coerce undefined and null values to false and other values to true. The checks can be used to provide a fallback for an individual property, for an object, or for a combination of both.  
he optional changing operator (the ? character) will stop evaluating an expression if the value it is applied to is null or undefined.  

getters/setters in object   
```javascript
let hat = { 
name: "Hat",
_price: 100, 
priceIncTax: 100 * 1.2,
set price(newPrice) {
        this._price = newPrice; this.priceIncTax = this._price * 1.2;
       },
get price() {
        return this._price;
        }
};
hat.price = 12

```

A property can have function  
```javascript
let hat ={

        write_details: function(){
                console.log("writing some details")
        }
}
// this is eqivalent to : write_details() { ...}
```

### this object 
global and local scope

inside stand alone function like below, 'this' is referring to level in global scope
```
function show(m){
        console.log(`${this.level} : ${m}`)
}
```

in local scope 
```javscript
let myobject = {
      name : "Joe",
      show_message(m){
        console.log(`${this.name}: ${m}`)
      }
}
```

**this in arrow function.**   
Arrow function don't have their own this value and so inherit the closest value that they find   
```javascript
let myObject = {
        greeting: "Hi, there",
        getWriter() {
                return (message) => console.log(`${this.greeting}, ${message}`);
                }
}

greeting = "Hello";
myObject.getWriter().("It is raining today");

// As standalone function
let standAlone = myObject.getWriter; 
let standAloneWriter = standAlone(); 
standAloneWriter("It is sunny today");
```
Output is   
Hi, there, It is raining today  
Hello, It is sunny today  

**bind method this values to its enclosing object**

```javascript
let hat = { 
    name: "Hat",
    _price: 100, 
    priceIncTax: 100 * 1.2,
    set price(newPrice) {
        this._price = newPrice; this.priceIncTax = this._price * 1.2;
    },
    get price() {
        return this._price;
    },
    writeDetails() {
        console.log(`${this.name}: ${this.price}, ${this.priceIncTax}`);
    }
};

hat.writeDetails()
func = hat.writeDetails
func()
func = hat.writeDetails.bind(hat)
func()
```
output    
Hat: 200, 240  
undefined: undefined, undefined  
Hat: 200, 240  

### Date Time  
  
```bash
// Set variable to current date and time
const now = new Date(); // By default UTC zone
# 2022-06-12T13:54:52.384Z
```
new Date()	: Current date and time  
new Date(timestamp)	: Creates date based on milliseconds since Epoch time  
new Date(date string)	: Creates date based on date string  
new Date(year, month, day, hours, minutes, seconds, milliseconds)	: Creates date based on specified date and time  
```bash
  // Timestamp method
new Date(-6106015800000);

// Date string method
new Date("July 4 1776 12:30");

// Date and time method
new Date(1776, 6, 4, 12, 30, 0, 0);
 ```
 ```bash
## Date/Time	         Method	Range	        Example
# Year	               getFullYear()	YYYY	        1970
# Month	               getMonth()	   0-11	        0 = January
# Day (of the month)	 getDate()	  1-31	1 = 1st of the month
# Day (of the week)	   getDay()	     0-6	  0 = Sunday
# Hour	               getHours()	   0-23	0 = midnight
# Minute	             getMinutes()	 0-59	
# Second	             getSeconds()	 0-59
```
https://www.digitalocean.com/community/tutorials/understanding-date-and-time-in-javascript  
  
### Looping

```bash
let a = [1, 2, 3]; // Your data
a.forEach(item => {
console.log(item); // Visit each item in the array
});

// Or (old-style JS)
for (let i = 0; i < a.length; ++i) {
const item = a[i];
// Visit each item
}

// Or (using modern JS iterators)
for (const item of a) {
// Visit each item
}

```

```bash
// 1. Creating Arrays
let firstArray = ["a","b","c"];
let secondArray = ["d","e","f"];

// 2. Access an Array Item
console.log(firstArray[0]); // Results: "a"

// 3. Loop over an Array
firstArray.forEach(function(item, index, array){
    console.log(item, index); 
});
// Results: 
// a 0
// b 1
// c 2

// 4. Add new item to END of array
secondArray.push('g');
console.log(secondArray);
// Results: ["d","e","f", "g"]

// 5. Remove item from END of array
secondArray.pop();
console.log(secondArray);
// Results: ["d","e","f"]

// 6. Remove item from FRONT of array
secondArray.shift();
console.log(secondArray);
// Results: ["e","f"]

// 7. Add item to FRONT of array
secondArray.unshift("d");
console.log(secondArray);
// Results: ["d","e","f"]

// 8. Find INDEX of an item in array
let position = secondArray.indexOf('f');
// Results: 2

// 9. Remove Item by Index Position
secondArray.splice(position, 1); 
console.log(secondArray);
// Note, the second argument, in this case "1", 
// represent the number of array elements to be removed
// Results:  ["d","e"]

// 10. Copy an Array
let shallowCopy = secondArray.slice();
console.log(secondArray);
console.log(shallowCopy);
// Results: ShallowCopy === ["d","e"]

// 11. JavaScript properties that BEGIN with a digit MUST be accessed using bracket notation
renderer.3d.setTexture(model, 'character.png');     // a syntax error
renderer['3d'].setTexture(model, 'character.png');  // works properly


// 12. Combine two Arrays
let thirdArray = firstArray.concat(secondArray);
console.log(thirdArray);
// ["a","b","c", "d", "e"];

// 13. Combine all Array elements into a string
console.log(thirdArray.join()); // Results: a,b,c,d,e
console.log(thirdArray.join('')); // Results: abcde
console.log(thirdArray.join('-')); // Results: a-b-c-d-e

// 14. Reversing an Array (in place, i.e. destructive)
console.log(thirdArray.reverse()); // ["e", "d", "c", "b", "a"]

// 15. sort
// sort takes a function that defines the sort order.   
// If omitted, the array elements are converted to strings, then sorted according to each character's Unicode code point value.
let unsortedArray = ["Alphabet", "Zoo", "Products", "Computer Science", "Computer"];
console.log(unsortedArray.sort()); 
// Results: ["Alphabet", "Computer", "Computer Science", "Products", "Zoo" ]

fruit_counts = [{banana:16}, {mango:8}, {jackfruit:9},{apple:12}];
//by values
fruit_counts.sort((a, b) => Object.values(a)[0] - Object.values(b)[0]);
// [ { mango: 8 }, { jackfruit: 9 }, { apple: 12 }, { banana: 16 } ]
//by keys
fruit_counts.sort((a, b) => Object.keys(a)[0].localeCompare(Object.keys(b)[0]));
[ { apple: 12 }, { banana: 16 }, { jackfruit: 9 }, { mango: 8 } ]

// push array into array and flatten
target.push.apply(target, source);
```


### Random stuff
```bash
// random string
Math.random().toString(36).substr(2, 5);

// random numbers
Math.floor(Math.random() * 100)
```

### Array From
https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/from  

```bash
// manipulate the elements
Array.from([1, 2, 3], x => x + x);
// [2, 4, 6]

// Generate a sequence of numbers
// Since the array is initialized with `undefined` on each position,
// the value of `v` below will be `undefined`
Array.from({length: 5}, (v, i) => i);
// [0, 1, 2, 3, 4]

// Sequence of random integers between 100,1
Array.from({length: 5}, (v, i) => Math.floor((Math.random()*(100 - 1) + 1));

// Sequence of random strings 5 char long
Array.from({length: 5}, () => Math.random().toString(36).substr(2, 5));
//[ '59tyh', 'xd0re', 'eo105', 'm1icw', 'd9scx' ]
```


### Dictionary keys and values
- Object.keys()
- Object.values()
- Object.entries()
```bash
const object1 = {
  a: 'somestring',
  b: 42
};

for (const [key, value] of Object.entries(object1)) {
  console.log(`${key}: ${value}`);
}
```

### is dict empty
```bash
Object.keys(obj).length === 0;
```

### Json Parsing

```bash
#Update a Property of an Object
    let object = {
        'myName' : {
            'FirstName' : 'Name',
            'SecondName' : 'Surname'
        },
        'myAge' : 1043
    }

    // Updates myAge to 2043
    object.myAge = 2043
    
#Turn an Object's Keys into an Array

    let object = {
        'myName' : 'Name',
        'myAge' : 1043
    }

    // Returns [ 'myName', 'myAge' ];
    let keys = Object.keys(object);

#Turn an Object's Values into an Array

    let object = {
        'myName' : 'Name',
        'myAge' : 1043
    }

    // Returns [ 'Name', 1043 ];
    let values = Object.values(object);

#Turn Array or Map sets into an Object
let arrSets = [ ['myName', 'Name'], ['myAge', 1043] ]

    /* Returns {
        'myName' : 'Name',
        'myAge' : 1043
    } */
    let generateObject = Object.fromEntries(arrSets);

#Shallow Clone an Object

    let object = {
        'myName' : 'Name',
        'myAge' : 1043
    }

    // Creates a copy of object, which we can edit separately
    let newObject = Object.assign({}, object);

    // Creates a copy of object, which we can edit separately
    let anotherClone =  { ...object };
    
#Deep Clone an Object with only variables

    let object = {
        'myName' : {
            'FirstName' : 'Name',
            'SecondName' : 'Surname'
        },
        'myAge' : 1043
    }

    // Creates a copy of object, which we can edit separately
    let newObject = JSON.parse(JSON.stringify(object));
    newObject.myName.FirstName = 'Hello';
    console.log(newObject, object);
    /*
    Returns {
      myAge: 1043,
      myName: {
        FirstName: "Hello",
        SecondName: "Surname"
      }
    }, {
      myAge: 1043,
      myName: {
        FirstName: "Name",
        SecondName: "Surname"
      }
    } */

#Merge two objects into the original variable

    let object = { 'myName' : 'Name' }
    let objectTwo = { 'myAge' : 1043 }
    Object.assign(object, objectTwo);

    console.log(object, objectTwo);
    /* Returns {
        myAge: 1043,
        myName: "Name"
    }, {
        myAge: 1043
    } */

# Merge two objects into a new variable 

    let object = { 'myName' : 'Name' }
    let objectTwo = { 'myAge' : 1043 }
    
    let newObject = { ...object, ...objectTwo }

    console.log(object, newObject);
    /* Returns {
        myName: "Name"
    }, {
        myName: "Name",
        myAge: 1043
    } */

#Prevent any changes to an object 

    let object = {
        'myName' : {
            'FirstName' : 'Name',
            'SecondName' : 'Surname'
        },
        'myAge' : 1043
    }

    Object.freeze(object);

    // Throws a TypeError
    object.myLocation = '123 Fake Street';
    // Throws a TypeError
    object.myAge = 2043

#Turn Object into a String 

    let object = {
        'myName' : {
            'FirstName' : 'Name',
            'SecondName' : 'Surname'
        },
        'myAge' : 1043
    }

    // Returns {"myName":{"FirstName":"Name","SecondName":"Surname"},"myAge":1043}
    console.log(JSON.stringify(object))

#Turn String into an Object 

    let stringObject = '{"myName":{"FirstName":"Name","SecondName":"Surname"},"myAge":1043}';

    /* Returns {
        'myName' : {
            'FirstName' : 'Name',
            'SecondName' : 'Surname'
        },
        'myAge' : 1043
    } */
    console.log(JSON.parse(object))

#Check if Object has a property 

    let object = {
        'myName' : {
            'FirstName' : 'Name',
            'SecondName' : 'Surname'
        },
        'myAge' : 1043
    }

    // Returns true
    console.log(object.hasOwnProperty('myName'))

#Convert Object to Array sets
    let object = {
        'myName' : 'Name',
        'myAge' : 1043
    }

    // Returns [ [ 'myName', 'Name' ], [ 'myAge', 1043 ]];
    let entries = Object.entries(object);


```

### Filter and Map

```bash
# Filter

let a = [10, 20, 8, 15, 12, 33];
function predicate(value) {
return value > 10; // Retain values > 10
}
let f = a.filter(v => predicate(v)); // Filter array

# Map
let a = [1, 2, 3, 4, 5];
function transform(value) {
return value + 1; // Increment all values by one.
}
let t = a.map(v => transform(v));

```

### Regex
```bash
let str = "hey JudE"
let re = /[A-Z]/g
let reDot = /[.]/g
console.log(str.search(re))    // returns 4, which is the index of the first capital letter "J"
console.log(str.search(reDot)) // returns -1 cannot find '.' dot punctuation
  
// check if string includes 
string.includes(substring);

 // replace
const regex = /Dog/i;
console.log(p.replace(regex, 'ferret'));
```
