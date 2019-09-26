### Git push with password

```bash
$ git config credential.helper store
$ git push https://github.com/owner/repo.git

Username for 'https://github.com': <USERNAME>
Password for 'https://USERNAME@github.com': <PASSWORD>

#You should also specify caching expire,

git config --global credential.helper 'cache --timeout 7200'

```
