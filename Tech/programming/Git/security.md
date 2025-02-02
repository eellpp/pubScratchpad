### Using ssh key
copy the key from ~/.ssh/id_rsa.pub to github settings  

To see your repo URL, run:  

git remote show origin  
You can change the URL with:  

git remote set-url origin git+ssh://git@github.com/username/reponame.git  

https://stackoverflow.com/a/8588786  

### Creating a personal access token for the command line
You can create a personal access token and use it in place of a password when performing Git operations over HTTPS with Git on the command line or the API.  
https://help.github.com/en/articles/creating-a-personal-access-token-for-the-command-line  

Create tokens with read only , read-delete access.  

Once GIT is configured, we can begin using it to access GitHub. Example:

```bash
$ git pull
$ Username for 'https://github.com' : username
$ Password for 'https://github.com' : give your personal access token here
## Now cache the given record in your computer to remembers the token:

$ git config --global credential.helper cache
## If needed, anytime you can delete the cache record by:

$ git config --global --unset credential.helper
$ git config --system --unset credential.helper

## Now try to pull with -v to verify

$ git pull -v

```

### Pushing an existing repo to git
```bash
git remote add origin https://github.com/<username>/<repo>.git
git branch -M main
git push origin main

// when prompted for password input the token
```
### Saving the credentials
You can use the git config to enable credentials storage in git.  
```bash
git config --global credential.helper store  
```
When running this command, the first time you pull or push from the remote repository, you'll get asked about the username and password.  
Afterwards, for consequent communications with the remote repository you don't have to provide the username and password.  

The storage format is a .git-credentials file, stored in plaintext.  
On Linux the password is stored in plain text at : ~/.git-credentials
Provide your auth token as password

Also, you can use other helpers for the git config credential.helper, namely memory cache:  
```bash
git config credential.helper cache <timeout>
```
which takes an optional timeout parameter, determining for how long the credentials will be kept in memory. Using the helper, the credentials will never touch the disk and will be erased after the specified timeout. The default value is 900 seconds (15 minutes). 

https://stackoverflow.com/a/35943882

