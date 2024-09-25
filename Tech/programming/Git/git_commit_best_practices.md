The commit message should be structured as follows:
```bash
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```
**Example** 
```
feat(login): Fix login bug that caused 500 error on invalid credentials

When users entered invalid credentials, the application returned a 500 
error instead of a 401 Unauthorized. This was due to incorrect error 
handling in the authentication service. Updated the error handling logic 
to return the correct status code.

This commit also refactors the login controller to improve readability 
and ensures all edge cases are covered.

Resolves: #123
See also: #456
```


### Explanation:
- **Subject line**: Short (less than 50 characters), descriptive, and uses the imperative mood ("Fix" instead of "Fixed").
- **Blank line**: Separates the subject from the body.
- **Body**: Provides detailed explanation of what was changed and why, with a focus on explaining the problem (500 error) and the solution (correct error handling).
- **References**: Includes issue tracking references (`Resolves: #123`), which are placed at the bottom of the commit message.

### Use Temp checkpoint commit in local branch and squash later to a good commit
Refer to the steps for creating a branch and write checkpoint quick commits while developing in local   
When completed and pushing to branch write multine good commit and squash off the earlier checkpointing commits   
https://github.com/eellpp/pubScratchpad/blob/main/Tech/programming/Git/git_temp_checkpoint_commit.md


### Git Commit Messages

* Use the present tense ("Add feature" not "Added feature")
* Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
* Limit the first line *(title)* to 72 characters or less
* Reference issues and pull requests liberally after the first line
* When only changing documentation, include `[ci skip]` in the commit message *(after the first line (title) when possible)*
* Start the commit message with one of the following keywords (see [Conventional Commits](https://www.conventionalcommits.org/) specification):
  * `chore`: Tool changes, configuration changes and changes to things that do not actually go into production
  * `ci:` Changes that affect the build system or external dependencies
  * `docs:` Documentation only changes
  * `feat:` A new feature
  * `fix:` A bug fix
  * `perf:` A code change that improves performance
  * `refactor:` A code change that neither fixes a bug nor adds a feature
  * `style:` Changes that do not affect the meaning of the code *(white-space, formatting, missing semi-colons, etc)*
  * `test:` Adding missing tests or correcting existing tests
* Optionally mention the scope (affected section / module of the project) of the change, in parentheses, between the type keyword and the colon.

#### Examples

- Commit message for a fix:
  ```
  fix: sanitize input value in module xyz
  ```
- Commit message for a feature with a scope:
  ```
  feat(meetings): add new agenda section to the meetings page
  ```
- Commit message for a documentation change with a skip build flag:
  ```
  docs: add usage information to the README
  
  [skip ci]
  ```

Best practices for writing clear and meaningful commit messages.

### 1. **Separate Subject from Body with a Blank Line**:
   The subject should be a brief summary of the change (less than 50 characters), followed by a blank line and a more detailed explanation in the body if necessary.

### 2. **Limit the Subject Line to 50 Characters**:
   Keeping the subject concise helps readability and ensures tools like GitHub or Git logs display it cleanly.

### 3. **Capitalize the Subject Line**:
   Always start the subject line with a capital letter to maintain consistency and readability.

### 4. **Do Not End the Subject Line with a Period**:
   Periods are unnecessary and take up space in the subject line.

### 5. **Use the Imperative Mood in the Subject Line**:
   Write your subject as if you are giving an instruction (e.g., "Fix bug" instead of "Fixed bug"). This matches Git’s own built-in messages, like "Merge branch 'feature-x'."

### 6. **Wrap the Body at 72 Characters**:
   When writing a body, wrap lines at 72 characters to maintain readability across different tools and screens.

### 7. **Use the Body to Explain What and Why, Not How**:
   The body should describe the reasoning behind the change rather than explaining the code itself. This helps future developers understand the intent behind the commit.

These guidelines help ensure commit messages are clear, consistent, and easy to understand. This is especially important when collaborating with a team or reviewing past changes. 

## Multi Line Commits
>> git commit -m 'First line   
Second line  
Third line'  

>>> git commit




This structure makes it easy to understand both what was changed and the reasoning behind it.




> commit messages to me are almost as important as the code change itself
This is high on my list of code craftsmanship points. It's very difficult to explain to young programmers who have never worked on an old code base how valuable this is when done well. In fact, often you hear complaints about how a code base "is crap", but more often than not I'd wager this is just a result of the context at the time not being known or appreciated. Frankly, all code we write is heavily governed by context we take for granted at the time, but is in precious short supply 1, 5, 10 years later. If you come back with a different use case later, the original code may very well be unsuited for that purpose. We can argue all day about good judgement and YAGNI, but at the end of the day no one can see all ends, therefore the best we can do is document clearly why we did what we did.

Taking the time to rebase, cleanup, and explain your changes in detail will pay huge dividends for any long-lived project. I've literally had successors write me a thank you note for a commit message from over a decade ago because I take this so seriously.


## References

https://chris.beams.io/posts/git-commit/   
https://github.com/ietf-tools/.github/blob/main/CONTRIBUTING.md#git-commit-messages   
https://www.conventionalcommits.org/en/v1.0.0/#summary  
https://git-scm.com/docs/git-commit#_discussion  

