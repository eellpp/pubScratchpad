

| Need | Solution |
|---|---|
|Parent passes data to child|Props|
|Parent passes HTML and components to child|Slots|
|Child notifies parent, optionally including data|Events|
|Ancestor makes data available to descendants|Context|
|Component shares data between all instances|Module context|
|Any component subscribes to data|Stores|


Props are declared in the script element of a component with the export keyword.  
Prop values that are non-string literals or JavaScript expressions must be sur- rounded by curly braces instead of quotes.  

### Props
https://github.com/eellpp/pubScratchpad/blob/master/Tech/programming/frontend/svelte/props.md  


 
### SLots
https://github.com/eellpp/pubScratchpad/blob/master/Tech/programming/frontend/svelte/slots.md  

### Event Handling
on:event 

button on:click={event => clicked = event.target} # eg of setting a variable using anony function  
button on:click={doOneThing} on:click={doAnother} # invoking multiple functions  

Components can dispatch events by creating and using an event dispatcher.   
```bash
import {createEventDispatcher} from 'svelte';
const dispatch = createEventDispatcher(); 

function sendEvent(){
    dispatch('someEventName', optionalData);    
}
```

These events only go to the parent component. They do not automatically bubble far- ther up the component hierarchy.  
Parent components use the on directive to listen for events from child components.     
<Child on:someEventName={handleEvent} />  
The event-handling function (handleEvent in this case) is passed an event object. This object has a `detail` property that is set to the data passed as the second argument to the dispatch function. Any additional arguments passed to dispatch are ignored.  

const handleSelect = event => color = event.detail;  

**Multiple events with on directive**
on:click|once|preventDefault={handleClick}   


