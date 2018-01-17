
#### Clean up and optimize repo
git gc

#### List large files in git commit history
git rev-list --objects --all | grep "$(git verify-pack -v .git/objects/pack/*.idx | sort -k 3 -n | tail -10 | awk '{print$1}')"

