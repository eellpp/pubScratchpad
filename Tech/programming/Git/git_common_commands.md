Here’s a table of the most commonly used Git commands for day-to-day development, including brief descriptions and examples:

| **Command**                | **Description**                                                            | **Example**                                |
|----------------------------|----------------------------------------------------------------------------|--------------------------------------------|
| `git init`                 | Initializes a new Git repository in the current directory.                  | `git init`                                 |
| `git clone <url>`          | Clones a remote repository to your local machine.                           | `git clone https://github.com/user/repo.git` |
| `git add <file>`           | Stages a file for the next commit.                                          | `git add file.txt`                         |
| `git add .`                | Stages all changes (new, modified, and deleted files) in the current directory. | `git add .`                                |
| `git commit -m "<message>"`| Commits the staged changes with a commit message.                           | `git commit -m "Fix login bug"`            |
| `git status`               | Displays the state of the working directory and staging area.               | `git status`                               |
| `git log`                  | Shows the commit history.                                                   | `git log`                                  |
| `git diff`                 | Shows the differences between working directory and staging area or between commits. | `git diff`                                 |
| `git branch`               | Lists all branches in the repository or creates a new branch.               | `git branch new-feature`                   |
| `git checkout <branch>`    | Switches to the specified branch.                                           | `git checkout main`                        |
| `git checkout -b <branch>` | Creates and switches to a new branch.                                       | `git checkout -b new-feature`              |
| `git merge <branch>`       | Merges the specified branch into the current branch.                        | `git merge new-feature`                    |
| `git pull`                 | Fetches changes from the remote repository and merges them into the current branch. | `git pull origin main`                     |
| `git push`                 | Pushes the committed changes to the remote repository.                      | `git push origin main`                     |
| `git reset --soft <commit>`| Moves `HEAD` to a specific commit but keeps changes in the staging area.     | `git reset --soft HEAD~1`                  |
| `git reset --hard <commit>`| Resets the working directory and staging area to a specific commit, discarding all changes. | `git reset --hard HEAD~1`                  |
| `git stash`                | Temporarily saves changes in a stash for later use.                         | `git stash`                                |
| `git stash apply`          | Reapplies stashed changes.                                                  | `git stash apply`                          |
| `git rebase <branch>`      | Reapplies commits on top of another branch, often used to clean up commit history. | `git rebase main`                          |
| `git remote -v`            | Shows the remote repositories associated with the local repo.               | `git remote -v`                            |
| `git fetch`                | Fetches changes from the remote without merging them into your current branch. | `git fetch origin`                         |
| `git tag <tagname>`        | Creates a new tag (usually for versioning or releases).                     | `git tag v1.0`                             |
| `git rm <file>`            | Removes a file from the working directory and stages the removal.           | `git rm file.txt`                          |

