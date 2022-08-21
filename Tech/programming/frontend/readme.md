Javascript is a programming language that is used for writing scripts on the website. NodeJS is a Javascript runtime environment.  
Node.js is a back-end JavaScript runtime environment that runs on the V8 engine and executes JavaScript code outside a web browser.  

Check the current node version  
https://nodejs.org/en/about/releases/  

node --version  

brew install node@16 # current LTS

## PNPM 
Fast, disk space efficient package manager  
Uses symlinks to avoid copy files and create better structure.  
Faster than npm.  


## NPM basics  

npm is two things: first and foremost, it is an online repository for the publishing of open-source Node.js projects; second, it is a command-line utility for interacting with said repository that aids in package installation, version management, and dependency management.  


any project that's using Node.js will need to have a package.json file   
```json
{
  "name": "metaverse",
  "version": "0.92.12",
  "description": "The Metaverse virtual reality. The final outcome of all virtual worlds, augmented reality, and the Internet.",
  "main": "index.js"
  "license": "MIT",
  "devDependencies": {
    "mocha": "~3.1",
    "native-hello-world": "^1.0.0",
    "should": "~3.3",
    "sinon": "~1.9"
  },
  "dependencies": {
    "fill-keys": "^1.0.2",
    "module-not-found-error": "^1.0.0",
    "resolve": "~1.1.7"
  }
}
```

**npm init** to Initialize a Project  
Once you run through the npm init steps above, a package.json file will be generated and placed in the current directory.   


**npm install module_name**  
**npm install module_name --save**  # This flag will add the module as a dependency of your project to the project's package.json as an entry in dependencies.   
**npm install module_name --save-dev** # evDependencies are a collection of the dependencies that are used in development of your application - the modules that you use to build it, but don't need to use when it's running. This could include things like testing tools, a local server to speed up your development, and more.  
**npm install module --global** # this will install the module globally in system path and may require authentication. Instead provide user path for global install  


**npx** - runs a command of a package without installing it explicitly.    
The npx stands for Node Package Execute and it comes with the npm   

**degit** makes copies of git repositories. 
degit user/repo  is equivalent to  `degit github:user/repo`  

**Cloning repositories using degit**
**npx degit user/repo#branch-name folder-name**     
folder name is optional. Master branch is default  
  


**npm install**	- Install everything in package.json  
**npm i sax@3.0.0** - install specific version  

npm run <command>  
You can easily run scripts using npm by adding them to the "scripts" field in package.json and run them with npm run <script-name>.   
```json
  {
	"name": "my-package",
	"scripts": {
		"lint": "eslint .",
    "start": "node server.js",
    "test": "jest"
	},
	"devDependencies": {
		"eslint": "^4.19.0"
	}
}
```
npm run lint  
npm start  
npm run  



