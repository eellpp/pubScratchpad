### Two way data binding between parent and child
Data ordinarily flows down from parent to child using props. If we want it to also flow the other way — from child to parent — we can use the bind: directive   
<FilterButton bind:child_var={parent_var} />  
Whenever child_var is changed, the parent_val is updated   
Now if we want a function to be called in parent whenever child var is updated, we can make use of reactivity  
$: myFunc(parent_var)

### Dom bindings 

Using this you can bind to properties of DOM elements
- bind value
- bind checked
- bind group
Two-way data binding for an HTML element valies

```bash
<input bind:value={name}>  
<input type=checkbox bind:checked={yes}>    
<input type=radio bind:group={scoops} name="scoops" value={2}>  
<textarea bind:value></textarea>  
<select bind:value={selected} on:change="{() => answer = ''}">  
  
```

**Radio and Checkbox group binding**  
By adding  `bind:group={selected} value="this option value"`  
- checkbox: selected is an array where values is added/deleted based on selection  
- radio : selected is a variable whose value is set based on selection  

```bash

	<input bind:group={selected} type="radio" name="amount" value="10" /> 10
	<input bind:group={selected} type="radio" name="amount" value="20" /> 20
	<input bind:group={selected} type="radio" name="amount" value="30" /> 30

```

### Component Bindings
you can bind to component props (use sparingly)  




