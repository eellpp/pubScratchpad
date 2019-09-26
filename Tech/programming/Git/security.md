### Creating a personal access token for the command line
You can create a personal access token and use it in place of a password when performing Git operations over HTTPS with Git on the command line or the API.  
https://help.github.com/en/articles/creating-a-personal-access-token-for-the-command-line  

Create tokens with read only , read-delete access.  

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

