### Svelte javascript typescript debugging VSCode 

Add Launch Chrome settings in .vscode/launch.json
```json
{
    "version": "0.2.0",
    "configurations": [

        {
            "name": "Launch Chrome",
            "request": "launch",
            "type": "chrome",
            "url": "http://localhost:3000",
            "webRoot": "${workspaceFolder}/src"
        }
    ]
}
```
Step 2)   
run the app   
pnpm run dev  

Step 3)  
In "Run And Debug" option for Vscode, click the triangular Play button for Launch Chrome for the App  
This is open a browser window with the default url for APP  
Now setup the breakpoints and go to the app link/action which will cause the breakpoint to hit  
Vscode with stop at the breakpoint  


