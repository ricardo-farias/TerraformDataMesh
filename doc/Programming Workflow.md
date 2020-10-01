# Programming collaboration workflow

## Issues to resolve

### a: The build takes too much time

why:

- are Terraform changes to the shared AWS resource taking too long to apply?

### b: Merging code into develop overwrites features in prior commits

why:

- files are moved on local, and on origin

|       |            |          |            |
|-------|------------|----------|------------|
|       |            | origin   | origin     |
|       |            | changed  | unchanged  |
| local | changed    |          |            |
| local | unchanged  |          |            |

- folders moving. Test:
  - create a data file in develop:start/SOURCE.TXT
  - git checkout origin/develop -b 01_feature

### c: The uncertainty of the final directory structure results in files shifting

## Principles

- it is better to resolve code conflicts in a feature branch than in the develop branch
- it should be easy to determine if upstream changes will conflict with local code
- it should be easy for all developers to identify commits that contain unstable code

## Proposed git workflow

### branches

- `xx_feature_branch` contains the commits for a single feature under development
- `develop` contains all the features under development. (the current develop branch is called  `master`. It will be renamed when the repo moves)
- `release_stable` contains stable snapshots of the `develop` (aka `master`) branch

![Git Flow Branching Model](git-flow-model.png)

### workflow

### it should be easy to determine if upstream changes will conflict with local code

git fetch
gb -a
git difftool origin/refactor_terraform_s3 remotes/origin/master

g diff upstream with current branch

- Submit feature branches via Pull Requests using

  `git checkout feature_branch; git pull; git pull origin/develop; git push`

Pushing for PR,
if there is a serious merge conflict requiring a long refactor, rename your local  branch to refactor_feature_branch. Use cherry-pick of origin/develop to pop in major changes into your branch
Delete local branches develop, main
Use origin/develop as the start point of feature branches. ie: git checkout origin/develop -b feature_branch

## References

- [git CLI - Scott Chacon](http://schacon.github.io/git/git.html)
- [git SCM](https://git-scm.com/)
- [Pro Git book by Scott Chacon and Ben Straub](https://git-scm.com/book/en/v2)
