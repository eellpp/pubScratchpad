https://basarat.gitbook.io/typescript/type-system  
https://www.typescriptlang.org/docs/handbook/intro.html    

#### Typescript Do's and Dont's  
https://www.typescriptlang.org/docs/handbook/declaration-files/do-s-and-don-ts.html
- Don’t ever use the types Number, String, Boolean, Symbol, or Object These types refer to non-primitive boxed objects that are almost never used appropriately in JavaScript code. Do use the types number, string, boolean, and symbol.
- Don’t use any as a type unless you are in the process of migrating a JavaScript project to TypeScript.  
- Don’t use the return type any for callbacks whose value will be ignored. Instead use void


node package.json  
```json
{
"name": "tools", "version": "1.0.0", "description": "", "main": "index.js", 
"scripts": {"start": "tsc-watch --onsuccess \"node dist/index.js\""},
"keywords": [], "author": "", "license": "ISC", 
"devDependencies": {
  "tsc-watch": "^4.2.9",
  "typescript": "^4.2.2" 
}
}
```
use `npm start` command to start the typescript compiler  

typescript compiler option in tsconfig.json
```javascript
{
  // Change this to match your project
  "include": ["src/**/*"],
  "compilerOptions": {
    //The version of the JavaScript language targeted by the compiler
    // is specified by the target setting
    target": "es2018", 
    // Types should go into this directory.
    // Removing this would place the .d.ts files
    // next to the .js files
    "outDir": "dist", 
    "rootDir": "./src", 
    // output will be generated only when 
    //there are no errors detected in the JavaScript code.
    "noEmitOnError": true
    // Tells TypeScript to read JS files, as
    // normally they are ignored as source files
    "allowJs": true,
    // Generate d.ts files
    "declaration": true,
    // This compiler run should
    // only output d.ts files
    "emitDeclarationOnly": true,
    // go to js file when using IDE functions like
    // "Go to Definition" in VSCode
    "declarationMap": true,
    // Node.js supports CommonJS modules and ECMAScript modules,
    "module": "CommonJS",
    // To help the debugger correlate the JavaScript code with the TypeScript code
    // compilers generates a source map files, which has the map file extension, 
    //alongside the JavaScript files in the dist folder.
    "sourceMap": true,
    // the compiler will report an error when there are paths through functions 
    // that don’t explicitly produce a result with the result keyword or throw an error
    noImplicitReturns: true
}
  }
}
```

### Unit Testing
npm install --save-dev jest@26.6.3  
npm install --save-dev ts-jest@26.4.4  
The jest package contains the testing framework. The ts-jest package is a plugin to the Jest framework and is responsible for compiling TypeScript files before tests are applied.   

Add jest.config.js to the tools folder  
```javscript
module.exports = {
"roots": ["src"],
"transform": {"^.+\\.tsx?$": "ts-jest"}
}
```
The transform property is used to tell Jest that files with the ts and tsx file extension should be processed with the ts-jest package, which ensures that changes to the code are reflected in tests without needing to explicitly start the compiler.

### Types
number,string,boolean,null,any,unknown  

Much like `any`, any value is assignable to `unknown`; however, unlike any, you cannot access any properties on values with the type `unknown`, nor can you call/construct them. Furthermore, values of type `unknown` can only be assigned to `unknown` or `any`  

```javascript
let vAny: any = 10;          // We can assign anything to any
let vUnknown: unknown =  10; // We can assign anything to unknown just like any 


let s1: string = vAny;     // Any is assignable to anything 
let s2: string = vUnknown; // Invalid; we can't assign vUnknown to any other type (without an explicit assertion)

vAny.method();     // Ok; anything goes with any
vUnknown.method(); // Not ok; we don't know anything about this variable
```


### Type assertion
<var> as <type>  
amount as number   

### Nullable type  
by default, TypeScript treats null and undefined as legal values for all types  
the use of null and undefined can be restricted by enabling the `strictNullChecks` compiler setting  

A non-null value is asserted by applying the ! character after the value
let amount:number = getAmount()!

removing non null with type guard
 ``` javascript
let amount:number | null = getAmount()
if (amount !== null){
  profit : number = amount - cost 
}
```
### Unions
https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#union-types  

```typescript
function getReturns(amount:number,format:boolean):string | number| null {
  if (amount === 0) {
          return null;
  }
  return format: `${amount}`:number
}
```
by default, TypeScript treats null and undefined as legal values for all types. 
The use of null and undefined can be restricted by enabling the strictNullChecks compiler setting: "strictNullChecks": true   
When true, this setting tells the compiler not to allow null or undefined values to be assigned to other types.   
In the above example, null is explicity added  

### Typeguards
https://basarat.gitbook.io/typescript/type-system/typeguard  

Type Guards allow you to narrow down the type of an object within a conditional block  

```typescript
if (typeof x === 'string') { // Within the block TypeScript knows that `x` must be a string
...
}
if (arg instanceof Foo) { // FOO is a class
}
```
Use `in` to check if object contains property
```typescript
interface A {
  x: number;
}

function doStuff(q: A | B) {
  if ('x' in q) {
    // q: A
  }
```

### Functions 
https://basarat.gitbook.io/typescript/type-system/functions

Optional Parameters    
function foo(bar: number, bas?: string): void { ... }

Rest parameters: Allow to call with variable number of parameters  
function myfunc(p1,p2,p3,...extras)    
where extras is rest parameter   
Any arguments for which there are no corresponding parameters are assigned to the rest parameter, which is an array. The array will always be initialized and will contain no items if there were no extra arguments.  

Implicit return  
Javascript returns undefined as value for any return path which is not defined in function  
Disable this with `noImplicitReturns` compiler settings  

overloading 
```typescript
function padding(all: number);
function padding(topAndBottom: number, leftAndRight: number);
function padding(top: number, right: number, bottom: number, left: number);
function padding(a: number, b?: number, c?: number, d?: number) { ...}
```
declaring types of a function

```typescript
type LongHand = {
    (a: number): number;
};

type ShortHand = (a: number) => number;
```
  
**Error handling **  
https://medium.com/fashioncloud/a-functional-programming-approach-to-error-handling-in-typescript-d9e8c58ab7f  
  
  
### Tuples
https://www.typescriptlang.org/docs/handbook/2/objects.html#tuple-types  
A tuple type is another sort of Array type that knows exactly how many elements it contains, and exactly which types it contains at specific positions.
```typescript
function doSomething(pair: [string, number]) {
  const a = pair[0];  // const a: string
  const b = pair[1]; //const b: number
}
```

### Classes
https://www.typescriptlang.org/docs/handbook/2/classes.html

```typescript
class Point {
  // Overloads
  constructor(x: number, y: string);
  constructor(s: string);
  constructor(xs: any, y?: any) {
    // TBD
  }
}

// Another example
interface Pingable {
  ping(): void;
}
 
class Sonar implements Pingable {
  ping() {
    console.log("ping!");
  }
}

// Example of inheritance
class Animal {
  move() {
    console.log("Moving along!");
  }
}
 
class Dog extends Animal {
  woof(times: number) {
    for (let i = 0; i < times; i++) {
      console.log("woof!");
    }
  }
}
 
const d = new Dog();
// Base class method
d.move();
// Derived class method
d.woof(3);
```


### Interfaces

### Generics

Example of generic to addItem of different types to array(instead of declaring different functions)   

```typescript
function addItem<T extends boolean | string>(item: T, array: T[]) {
  array = [...array, item];
  return array;
}

addItem('hello', []);

addItem(true, [true, true]);
```

### Mapped Types
https://www.typescriptlang.org/docs/handbook/2/mapped-types.html  
mapped types allow us to create new types based on existing ones.    
TypeScript does ship with a lot of utility types, so we don’t have to rewrite those in each project. Let’s look at some of the most common: Omit, Partial, Readonly, Readonly, Exclude, Extract, NonNullable, and ReturnType.  

Example of a readonly teacher type
```typescript

interface Teacher {
  name: string;
  email: string;
}

type ReadonlyTeacher = Readonly<Teacher>;

const t: ReadonlyTeacher = { name: 'jose', email: 'jose@test.com'};

```


