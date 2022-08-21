Documentation is written in markdown in github repo 

A webapp that reads from this markdown and generates a html page. 

Tools 

**Svelte Markdown**
https://github.com/pablo-abc/svelte-markdown 

This takes in a markdown content as a variable and renders the html for it as a svelte component

**Markdownit** 
https://github.com/markdown-it/markdown-it
This is js markdown parser 


**sveltekit document app**
Svelte kit documentation is part of the docs in git folder. The example app that creates the the sveltekit public website reads the documentation at server side the renders into html. 
Sveltekit webapp
https://kit.svelte.dev/docs/hooks

SvelteKit App src: 
https://github.com/sveltejs/kit/tree/master/sites/kit.svelte.dev
https://github.com/sveltejs/kit/tree/master/sites/kit.svelte.dev/src/lib/docs

---
The documentation is part of App. Whenever the doc is updated and merged to master. The build process can deploy App to production with the latest changes. The code and associated documentation go together. 

Note: repl.it and riju provide various programming terminals. However these terminals are connected to lightweight docker infra on server side. 
For clients language scripts, it might be useful to show , how the API can be consumed in various languages etc 



