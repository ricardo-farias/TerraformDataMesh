# Programming collaboration workflow

## Issues to resolve

### a: The build takes too much time

why:

- are Terraform changes to the shared AWS resource taking too long to apply?

### b: Merging code into develop overwrites features in prior commits

why:

### c: The uncertainty of the final directory structure results in files shifting

## Principles

- it should be easy to determine if upstream changes will conflict with local code
- it is better to resolve code conflicts in a feature branch than in the develop branch
- it should be easy for all developers to identify commits that contain unstable code

## git workflow

### branches

- `feature_branch` contains the commits for a single feature under development
- `develop` contains all the features under development. (the current develop branch is called  `master`. It will be renamed when the repo moves)
- `release_ecs` contains stable snapshots of the `develop` (aka `master`) branch
- `release_eks` contains stable snapshots of the `develop` (aka `master`) branch

![Git Flow Branching Model](git-flow-model.png)

### it should be easy to determine if upstream changes will conflict with local code

workflow to diff upstream develop branch with local feature branch

```shell
git fetch origin --prune
git checkout feature_branch -B wip_compare_upstream          # setup
git add -u                                                   # only add tracked files
git reset --soft `git merge-base --fork-point master head`   # squash the local branch into one commit. put that commit in STAGED INDEX
git difftool --cached origin/master                          # compare the STAGED INDEX to upstream develop
git reset --soft feature_branch; git checkout feature_branch # bring edited files into feature branch
git branch -d wip_compare_upstream                           # cleanup
```

### it is better to resolve code conflicts in a feature branch than in the develop branch

three options for bringing in upstream changes:

- merge. when local has changed more than upstream. ![merge diagram](dia-merge.svg)
- rebase. when upstream has changed more than local. ![rebase diagram](dia-rebase.svg)
- cherry-pick. when there are serious merge conflicts requiring a long refactor

### it should be easy for all developers to identify commits that contain unstable code

- Submit feature branches via Pull Requests
- Delete local branches develop, main

  ```shell
  git branch -d master
  ```

- Use upstream develop as the start point of feature branches.

  ```shell
  git checkout origin/master -b feature_branch
  ```

## References

- [Merging vs. Rebasing](https://www.atlassian.com/git/tutorials/merging-vs-rebasing)
- [git CLI - Scott Chacon](http://schacon.github.io/git/git.html)
- [git SCM](https://git-scm.com/)
- [Pro Git book by Scott Chacon and Ben Straub](https://git-scm.com/book/en/v2)
- [Advanced Workflows](http://schacon.github.io/git/gitworkflows.html)