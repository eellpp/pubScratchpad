
#### Clean up and optimize repo
git gc

#### List large files in git commit history
git rev-list --objects --all | grep "$(git verify-pack -v .git/objects/pack/*.idx | sort -k 3 -n | tail -10 | awk '{print$1}')"


### Git push with password

```bash
$ git config credential.helper store
$ git push https://github.com/owner/repo.git

Username for 'https://github.com': <USERNAME>
Password for 'https://USERNAME@github.com': <PASSWORD>

#You should also specify caching expire,

git config --global credential.helper 'cache --timeout 7200'

```