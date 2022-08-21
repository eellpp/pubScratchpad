

### uploading existing code to new repo path in github

Create repo in github

``` bash
git remote add origin https://github.com/<username>/<project>.git
git branch -M main
git push -u origin main
```

### Using personal Token
https://github.com/eellpp/pubScratchpad/blob/master/Tech/programming/Git/security.md#creating-a-personal-access-token-for-the-command-line   

### Using SSH key
https://github.com/eellpp/pubScratchpad/blob/master/Tech/programming/Git/security.md#using-ssh-key  

### useful scripts
Clean up and optimize repo  
git gc  

List large files in git commit history  
git rev-list --objects --all | grep "$(git verify-pack -v .git/objects/pack/*.idx | sort -k 3 -n | tail -10 | awk '{print$1}')"  

### Tagging
Tagging locally(Annotated tag)  
git tag -a v0.0.5 -m "Added tagging"  

tag have to be pushed seperatly to origin
git push --tag v0.0.5  

delete a local tag  
git tag -d v0.0.5  

delete a remote tag
git push --delete origin v0.0.5  

list the tags  
git tag  





