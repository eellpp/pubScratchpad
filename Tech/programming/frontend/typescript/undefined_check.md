
### optional chaining operator
https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Optional_chaining  

The optional chaining operator (?.) enables you to read the value of a property located deep within a chain of connected objects without having to check that each reference in the chain is valid.

obj.val?.prop  
obj.val?.[expr]  
obj.arr?.[index]  
obj.func?.(args)  

When using optional chaining with expressions, if the left operand is null or undefined, the expression will not be evaluated.   

used with nullish coalescing  
const customerCity = customer?.city ?? "Unknown city";  


### Nullish_coalescing_operator
https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Nullish_coalescing_operator  

The nullish coalescing operator (??) is a logical operator that returns its right-hand side operand when its left-hand side operand is null or undefined, and otherwise returns its left-hand side operand.  

const foo = null ?? 'default string';
