### Guides:  
https://svelte.dev/tutorial/basics  
https://svelte.dev/docs  
https://svelte-recipes.netlify.app/  
https://sveltesociety.dev/cheatsheet  
https://sveltesociety.dev/components  
https://stackoverflow.com/questions/tagged/svelte?tab=Votes  
https://developer.mozilla.org/en-US/docs/Learn/Tools_and_testing/Client-side_JavaScript_frameworks/Svelte_getting_started  


1. Components are the building blocks of Svelte applications.
2. Reactivity means that the framework can automatically update the DOM when the state of any component is changed.
3. Assignments are 'reactive': https://svelte.dev/docs#2_Assignments_are_reactive
4. $: marks a statement as reactive. Svelte will generate the code to automatically update them whenever data they depend on is changed.
5. Svelte compiler processes the <style> section of every component and compiles them into the public/build/bundle.css file.
6. Svelte compiles the markup and <script> section of every component and stores the result in public/build/bundle.js
7. Export keyword marks a variable declaration as a property or prop, which means it becomes accessible to consumers of the component
8. on:click dom event handler that allows calling a function on click
9. Allow two way data bindings. For DOM elements and for component props  
11. Props down, events up is general pattern. Use createEventDispatcher to dispatch events  
12. Prefix stores with $ to access their values : https://svelte.dev/docs#4_Prefix_stores_with_$_to_access_their_values  
13. <script context="module">. This just runs once when the module first evaluates, rather than for each component instance  


### Component Communication: 

https://github.com/eellpp/pubScratchpad/blob/master/Tech/programming/frontend/svelte/component_communication.md  

### Props  
https://github.com/eellpp/pubScratchpad/blob/master/Tech/programming/frontend/svelte/props.md  

### Bindings  
https://github.com/eellpp/pubScratchpad/blob/master/Tech/programming/frontend/svelte/binding.md  

### Events  
https://github.com/eellpp/pubScratchpad/blob/master/Tech/programming/frontend/svelte/events.md  

### Patterns
App is split into components where each component should ideally only do one thing. If it ends up growing, it should be split into smaller subcomponents.
	
As a general rule, data flow in Svelte is top down — a parent component can set props on a child component, and a component can set attributes on an element, but not the other way around.

Use `component bindings` sparingly. It can be difficult to track the flow of data around your application if you have too many of them, especially if there is no 'single source of truth'.


### Sharing data between components: props-down, events-up pattern
events bubbling up 
```bash
# The hierarchy is App => Outer => Inner
#####################################
#App:

<script>
    import Outer from './Outer.svelte';

    function handleMessage(event) {
        alert(event.detail.text);
    }
</script>

<Outer on:message={handleMessage}/>

#####################################
	
#Outer:

<script>
    import Inner from './Inner.svelte';
</script>

<Inner on:message />
	
#####################################
#Inner:

<script>
    import { createEventDispatcher } from 'svelte';

    const dispatch = createEventDispatcher();

    function sayHello() {
        dispatch('message', {
            text: 'Hello!'
        });
    }
</script>

<button on:click={sayHello}>
    Click to say hello
</button>
```
	
## Tricks
#### Add class directive to add/remove class based on boolean values  
```bash
<div class:done={isDone}>
```
https://github.com/eellpp/pubScratchpad/blob/master/Tech/programming/frontend/svelte/directives.md#class-directives

 

#### Calling child functions from parent using instance binding 
https://svelte.dev/tutorial/component-this  

```bash
// App.svelte
<script>
	import InputField from './InputField.svelte';

	let field;
</script>

<InputField bind:this={field}/>

<button on:click={() => field.focus()}>Focus field</button>

// InputField.svelte
<script>
	let input;

	export function focus() {
		input.focus();
	}
</script>

<input bind:this={input} />
```

### Forwarding events
Unlike DOM events, component events don't bubble. If you want to listen to an event on some deeply nested component, the intermediate components must forward the event.  

an on:message event directive without a value means 'forward all message events'  
```js
// App.svelte
 <script>
	import Inner from './Inner.svelte';
</script>

//Inner.svelte
<script>
	import { createEventDispatcher } from 'svelte';

	const dispatch = createEventDispatcher();

	function sayHello() {
		dispatch('message', {
			text: 'Hello!'
		});
	}
</script>

<button on:click={sayHello}>
	Click to say hello
</button>

// Outer.svelte
<script>
	import Inner from './Inner.svelte';
</script>

<Inner on:message/>
<Inner on:message/>
```

### Reactive Declarations
$: n_squared = n * n;  

Whenever Svelte sees a reactive declaration, it makes sure to execute any reactive statements that depend on one another in the correct order and only when their direct dependencies have changed. A 'direct dependency' is a variable that is referenced inside the reactive declaration itself. References to variables inside functions that a reactive declaration calls are not considered dependencies.  

### Forcing function to called by reactive declaration
$: one, two, three, someFunc();  
This simple expression informs Svelte that it should rerun whenever one, two, or three changes. This expression runs the line of code whenever these dependencies change.  


```js
<script>
	let name = 'world';

	let one = 1;
let two = 2;
let three =3;

function sideEffect(){
	three = three + 3
}
	
const someFunc = () => sideEffect();

$: one, two, three, someFunc();
	
</script>

<h1>Hello {three}!</h1>
<button on:click={()=> one = one + 1}>
	Click
</button>
```

### Force function to called when boolean variable updated by reactive declaration
```js
let one;

const someFunc = () => sideEffect();

$: one && someFunc();
```

### Each Looping over data structures like map,set and string
https://svelte-recipes.netlify.app/language/#looping  

```js
{#each [...map] as [key, value]}
<div>
  {key}: {value}
</div>
{/each}

{#each [...map.keys()] as key}
<div>
  {key}
</div>
{/each} {#each [...map.values()] as value}
<div>
  {value}
</div>
{/each}

```

### Inserting HTML values   
```js
<p>{@html string}</p>
```
Svelte doesn't perform any sanitization of the expression inside {@html ...} before it gets inserted into the DOM. In other words, if you use this feature it's critical that you manually escape HTML that comes from sources you don't trust, otherwise you risk exposing your users to XSS attacks.  

	
### Export function from a component that changes value in component
https://stackoverflow.com/questions/58287729/how-can-i-export-a-function-from-a-svelte-component-that-changes-a-value-in-the  
	
