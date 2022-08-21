https://www.digitalocean.com/community/tutorials/svelte-slots  
https://svelte.dev/tutorial/slots  

In Svelte components can be composed together using slots. Composition means allowing your components to contain other components or HTML elements. Slots are made possible in Svelte by using the <slot> component inside components that can accept components or markup within.

  
```bash
### card.svelte
<style>
  /* Make it pretty! */
</style>

<section>
  <slot name="title" />

  <slot name="description">
    <p>😮 No description!</p>
  </slot>

  <footer>
    <slot />
  </footer>
</section>
 
### App.svelte
  <script>
  import Card from "./Card.svelte";

  const items = [
    {
      title: "Pirate",
      description: "Argg!!",
      imageUrl: "https://alligator.io/images/pirate.svg"
    },
    {
      title: "Chef",
      description: "À la soupe!",
      imageUrl: "https://alligator.io/images/chef.svg"
    }
  ];
</script>

{#each items as item}
    <Card>
    <h1 slot="title">
      <img src={item.imageUrl} alt="Avatar for {item.title}" />
       {item.title}
    </h1>

    <p slot="description">{item.description}</p>

    <p>Something else!</p>
  </Card>
{/each}
```
