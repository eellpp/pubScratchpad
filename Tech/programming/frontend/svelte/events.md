### HTML DOM Events 
https://www.w3schools.com/tags/ref_eventattributes.asp
eg: handleMousemove  

on:click={() => removeTodo(todo)} as the handler with params.  
If removeTodo() received no params, you could use on:event={removeTodo}, but not on:event={removeTodo()}   


```js
<div on:mousemove={handleMousemove}>
	The mouse position is {m.x} x {m.y}
</div>
```

inline event
```js
<script>
	let m = { x: 0, y: 0 };
</script>

<div on:mousemove="{e => m = { x: e.clientX, y: e.clientY }}">
	The mouse position is {m.x} x {m.y}
</div>
```

Event Modifiers  
Eg; preventDefault in <a> element   
<button on:click|preventDefault={handleClick}>   

### Component Event

```js
 // myEvent.svelte
  <script>
	import { createEventDispatcher } from 'svelte';

	const dispatch = createEventDispatcher();

	function sayHello() {
		dispatch('message', {
			text: 'Hello!'
		});
	}
</script>
 
// app.svelte
 <myEvent on:message={handleMessage}/>
```
  
  
