Interface is contract.   
TS uses interfaces just to see if you respect the contracts “at compile time”, it doesn’t translate into anything in JS (in opposite to classes).   

```typescript
interface Person{
    name: string;
    age : number;
}
var data = [{name:"X",age:23},{name:"y",age:33}]
var persons : Person[] = data as Person[]
```

https://medium.com/front-end-weekly/typescript-class-vs-interface-99c0ae1c2136
