
### Difference between --track and checkout
Tracking means that a local branch has its upstream set to a remote branch.

```bash
$ git checkout --track origin/serverfix
Branch serverfix set up to track remote branch serverfix from origin.
Switched to a new branch 'serverfix'
```
This is same as the shortcut
```bash
$ git checkout serverfix
Branch serverfix set up to track remote branch serverfix from origin.
Switched to a new branch 'serverfix'
```
or tracking with a different local name
```bash
git checkout -b sf origin/serverfix
Branch sf set up to track remote branch serverfix from origin.
Switched to a new branch 'sf
```
If you’re on a tracking branch and type git pull, Git automatically knows which server to fetch from and which branch to merge in.

### Setting upstream

### general
- git branch featureA  ## will create featureA branch but still would be master. Future commits still on master
- git checkout -b featureA ## will create featureA and would checkout the featureA. Future commits on this branch
