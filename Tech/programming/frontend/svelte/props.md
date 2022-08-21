 ### A variable that can be passed into a child within the child component itself
 
 ```bash
//APP.svelte
<script>
	import Nested from './Nested.svelte';
</script>

<Nested answer={42}/>

// Nested.svelte
<script>
	export let answer;
</script>

<p>The answer is {answer}</p>

 ```
export let answer;  
to indicate that Button takes text as a prop.  
Then in App.svelte , we write:  
<Button text='Toggle' />  
to pass in the string 'Toggle' to Button . Since Button references text between the button tags, we see the word Toggle as the text for the button.  


#### Spread Props
We can use the spread operator to spread an object’s properties into multiple props.  
For instance, if we want to pass in more than one prop, we can write the following:  
```bash
App.svelte ;
<script>
  import Info from "./Info.svelte";
  const person = {
    name: "Jane Smith",
    age: 20,
    gender: "female"
  };
</script>

<main>
  <Info {...person} />
</main>

Info.svelte :
<script>
  export let name;
  export let age;
  export let gender;
</script>
<p>{name} {age} {gender}</p>
```
