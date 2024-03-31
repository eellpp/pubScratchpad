[Pro Git chapter 1.3](https://git-scm.com/book/en/v2/Getting-Started-What-is-Git%3F)

Commits are the “versions” of a repository. They are `snapshots`, not `deltas`, that means that a commit doesn’t know what has changed. Instead, a commit stores the content of every file. When you run git show, you are not showing the content of a commit, you are showing a patch, the change in relation to its parent. That storage, however, is done in a clever way in order to save space.

Commits have references to their parent commits:
- one parent in a normal commit;
- two parents in a merge commit;
- two or more parents in a octopus merge commit;
- no parents if it’s a initial commit.
- Commits also stores when and who created them!

** Git is more like a mini filesystem ** 
Git thinks of its data more like a set of snapshots of a mini filesystem.
Every time you commit, or save the state of your project in Git, it basically takes a picture of what all your files look like at that moment and stores a reference to that snapshot.
To be efficient, if files have not changed, Git doesn’t store the file again—just a link to the previous identical file it has already stored.  

This is an important distinction between Git and nearly all other VCSs. It makes Git reconsider almost every aspect of version control that most other systems copied from the previous generation. This makes Git more like a mini filesystem with some incredibly powerful tools built on top of it, rather than simply a VCS.

** Hash of files is stored **
Git logically stores each file under its SHA-1 hash value. This means if you have two files with exactly the same content in a repository (or if you rename a file), only one copy is stored.


But this also means that when you modify a small part of a file and commit, another copy of the file is stored. The way Git solves this is using pack files. Once in a while, all the “loose” files (actually, not just files, but objects containing commit and directory information too) from a repository are gathered and compressed into a pack file. The pack file is compressed using zlib. And similar files are also delta-compressed.

The same format is also used when pulling or pushing (at least with some protocols), so those files don't have to be recompressed again.

The result of this is that a Git repository, containing the whole uncompressed working copy, uncompressed recent files and compressed older files is usually relatively small, two times smaller than the size of the working copy. And this means it's smaller than an SVN repository with the same files, even though SVN doesn't store the history locally.


** Branches **
Branches are only references to commits. In fact, a branch is only a file containing a hash of a commit.

** Commit History DAG **
The commit history is not a linear timeline! Actually, it is a DAG, a directed acyclic graph, in other words, it is set of different timelines that may have a common past between them (a fork point) and that may have a state where both timelines join (a merge commit), but without any loops!

** Working Dir **
The working directory is the directory where you files are in you disk. From the perspective of view of who is writing and running code, this may look as the main area of Git (compared to the commit history and the staging area). However, from the perspective of view of Git, this is the least important, as everything here can be modified, deleted, created and Git won’t track it, unless, of course, you explicitly tell Git to do that (using git add, for example).

** Git Path Spec **

A nice way to see the pathspecs in action is using git ls-files. That command lists all the files in the staging area, but if you pass a pathspec as an argument for it, it will list all the files in the staging area that matches the pathspec.

The most trivial pathspec is the path of a file. If you have a file called README.md, then README.md will be a pathspec that represent it, and if it is inside a directory called src, a pathspec for it is src/README.md. Note that, by default, pathspecs are relative to the current directory.

git ls-files '*.c'

Note that '*.c' is between quotation marks, this means that it’s a string, and the shell is not expanding it. Instead, Git is expanding it.

: + magic wordsPermalink

: is a special character in pathspecs, that is followed by a magic word. I’m not going to deep dive into it, but there are two cases of it that I find very useful.

The first one is :/. This means the root of the repository. So, if you are in a subdirectory and want to match something by its absolute path (that is, relative to the repository root), you need to use :/. For example, :/*.c will match all the files that end in .c in the repository, no matter where they are located.

The second one is :!. If we put a :! in the beginning of a pathspec, then the pathspec will match all the files that doesn’t match the rest pathspec. For example:


Session
[Using Git for debug](https://lucasoshiro.github.io/posts-en/2023-02-13-git-debug/)

[ETL steps](https://hevodata.com/learn/data-staging-area/)

