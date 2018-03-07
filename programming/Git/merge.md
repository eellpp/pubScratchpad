
The rules to follow
1. pull and merge at least once daily with the public develop branch
2. push changes as fast as possible to develop

The two rules keeps it simple for multiple developers to work on same file.

### Issue in merging

Say DevA creates a branch featureA from develop. He works on it for days and never pulls to merge the changes from latest develop.

At the same time DevB start on a featureB from develop. But as part of this he modifies same files as required by featureA. He finishes his work on day2 and commits to develop. DevC checked this out and added his featureC  which further enahnces the same files and commited it to master on Day3.

At day4 when DevA completes his work and tries to merge with develop, he can't cherry pick the merge conflicts.

### Rebase and Merging
rebase is rewriting of the project history, by creating brand new commits in develop branch for each commit in featureA branch. 

- Rebasing creates a cleaner project history. Eliminates the unnecessary merge commits and creates a linear history.
- Rebasing distroys the context required in merge commits

### Golden rule in rebase
 The golden rule of git rebase is to never use it on public branches. This is only for your private local branches. 
 
