
The rules to follow
1. pull and merge at least once daily with the public develop branch
2. push changes as fast as possible to develop

The two rules keeps it simple for multiple developers to work on same file.

### Issue in merging

1. `Day0` Say DevA creates a branch featureA from develop. 
 - He works on it for days and never pulls to merge the changes from latest develop.
 -At the same time DevB start on a featureB from develop. But as part of this he modifies same files as required by featureA. 
2. `Day2`. DevB finishes his work on day2 and commits to develop. 
3. `Day3`. DevC checked this out and added his featureC  which further enahnces the same files and commited it to master on Day3.
4. `Day4`. DevA completes his work and tries to merge with develop, he can't cherry pick the merge conflicts.He has to first merge with DevB and DevC should have built his featureC on devA and DevB's changes


looking at the logs, dev A can find the commit hash of when the featureB was done. 
- git log --graph --all --decorate
checkout the commit hash. Now the commit will be in detached head state
- git checkout dwerwer234de23423kj2342
create a temporary branch from this commit has
- git branch tempFeatureBDone
merge with the FeatureA
- git checkout featureA
- git merge tempFeatureBDone
resolve the merge issues. Test feature A and B. Commit and then delete the temp branch
- git branch -d tempFeatureBDone

Now the devA's featureA branch is tested with devB's changes. He can now merge with develop to get the devC's changes and test if feauture C is working as intended.

This way he can make up his mistake on not merging on day2 when devB had committed the changes.



### Rebase and Merging
rebase is rewriting of the project history, by creating brand new commits in develop branch for each commit in featureA branch. 

- Rebasing creates a cleaner project history. Eliminates the unnecessary merge commits and creates a linear history.
- Rebasing distroys the context required in merge commits

### Golden rule in rebase
 The golden rule of git rebase is to never use it on public branches. This is only for your private local branches. 
 
