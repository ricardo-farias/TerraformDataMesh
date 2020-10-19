# Programming collaboration workflow

## Issues to resolve

### a: The build takes too much time

why:

- are Terraform changes to the shared AWS resource taking too long to apply?

### b: Merging code into develop overwrites features in prior commits

why:

- developers are merging code without verifying the resulting change set.

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

We have to do 3 things to prevent important changes from being overwritten

1. compare the feature branch to the develop branch
2. merge in code that will be overwritten
3. save adjustments to the feature branch

```shell
# defaults
CURRENT_BRANCH=`git branch | grep '\*' | awk '{print $2}'`
DEVELOP_BRANCH=origin/master
EDITOR=code

# configure
OUR_BRANCH=$CURRENT_BRANCH
THEIR_BRANCH=$DEVELOP_BRANCH

# setup
git fetch origin --prune
git checkout $OUR_BRANCH -B wip_compare_upstream

# 1. compare the feature branch to the develop branch
git add -u                                                                 # only add tracked files
git reset --soft `git merge-base --fork-point $DEVELOP_BRANCH $OUR_BRANCH` # squash the local branch into one commit. put that commit in STAGED INDEX
git difftool --cached $THEIR_BRANCH                                        # compare the STAGED INDEX to THEIR_BRANCH

# 2. fix any code that will be overwritten
#    - by editing the files during compare
git difftool --cached $THEIR_BRANCH

#    - by getting the list of altered files and editing in the IDE
git difftool --cached --name-only | xargs -I% $EDITOR "%"

# 3. save adjustments to the feature branch
git reset --soft $OUR_BRANCH; git checkout $OUR_BRANCH                     # bring edited files into feature branch
git commit -a -m "Adjust $OUR_BRANCH for compatibility with $THEIR_BRANCH"
git push -u origin

# cleanup
git branch -d wip_compare_upstream
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
  git checkout origin/master --no-track -b feature_branch; git push -u origin
  ```

## References

- [Merging vs. Rebasing](https://www.atlassian.com/git/tutorials/merging-vs-rebasing)
- [git CLI - Scott Chacon](http://schacon.github.io/git/git.html)
- [git SCM](https://git-scm.com/)
- [Pro Git book by Scott Chacon and Ben Straub](https://git-scm.com/book/en/v2)
- [Advanced Workflows](http://schacon.github.io/git/gitworkflows.html)

=== to add

origin/fix_remove_s3_folder_leading_empty_space
their_branch=origin/bug_fixes; echo $their_branch

--- update our branch to commits in remote branches

# setup

our_branch_head=4c08e8c # save current head
our_branch=83_resource_name_config
their_branch=origin/fix_remove_s3_folder_leading_empty_space

# update index

git fetch --prune # update remote information
git branch -r

# compare

git difftool $our_branch $their_branch

git cherry-pick --no-commit $their_branch

gaa; gc --amend
gc -a -m "Applied buxfix patch 58a4704"
git rebase origin/master 83_resource_name_config
