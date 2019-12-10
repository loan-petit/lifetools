# Contributing

First off, thanks for taking the time to contribute!

When contributing to this repository, please first discuss the change you wish
to make via issue, email, or any other method with the owners and/or masters of
this repository before making a change.

Please note we have a code of conduct, please follow it in all your interactions
with the project.

## Submitting a Merge Request (MR)

Before you submit your Merge Request (MR) consider the following guidelines:

- Create a feature branch based on `develop`.
- Code your changes.
- Run unit tests if they are present. Otherwise, create some.
- Document any major feature implementations and architecture changes.
- Follow the [commit messages guidelines](#commit-messages-guidelines).
- If you have multiple commits, combine them into a few logically organized
commits by squashing them, but do not change the commit history if you're
working on shared branches though.
- Push the commit(s) to your working branch.
- Submit a merge request (MR) to the `develop` branch in the main GitHub project.
- Your merge request needs at least 1 approval, but feel free to require more.
- The MR title should describe the change you want to make.
- The MR description should give a reason for your change.
- If the your merge request solves an issue, mention it using the `Solves #XXX` or
`Closes #XXX` syntax to auto-close the issue(s) once the merge request is merged.
- If your merge request adds one or more migrations, make sure to execute all
migrations on a fresh database before the MR is reviewed. If the review leads
to large changes in the MR, execute the migrations again once the review is complete.


### Keep it simple

*Live by smaller iterations.* Please keep the amount of changes in a single MR
**as small as possible**. If you want to contribute a large feature, think very
carefully about what the minimum viable change is. Can you split the functionality
into two smaller MRs? Can you submit only the backend/API code? Can you start
with a very simple UI? Can you do just a part of the refactor?

Small MRs which are more easily reviewed, lead to higher code quality which is
more important to GitHub than having a minimal commit log. The smaller an MR is,
the more likely it will be merged quickly. After that you can send more MRs to
enhance and expand the feature.

### After your pull request is merged

After your pull request is merged, you can safely delete your branch and pull
the changes from the main (upstream) repository:

* Delete the remote branch on GitHub either through the GitHub web UI or your
local shell as follows:

    ```shell
    git push origin --delete my-fix-branch
    ```

* Check out the master branch:

    ```shell
    git checkout master -f
    ```

* Delete the local branch:

    ```shell
    git branch -D my-fix-branch
    ```

* Update your master with the latest upstream version:

    ```shell
    git pull --ff upstream master
    ```

## Commit Messages Guidelines

We have very precise rules over how our git commit messages can be formatted.
This leads to **more readable messages** that are easy to follow when looking
through the **project history**.

### Commit Message Format
Each commit message consists of a **header**, a **body** and a **footer**. The
header has a special format that includes a **type**, a **scope** and a **subject**:

```
<type>(<scope>): <subject>
<BLANK LINE>
<body>
<BLANK LINE>
<footer>
```

The **header** is mandatory and the **scope** of the header is optional.

Any line of the commit message cannot be longer 100 characters! This allows the
message to be easier to read on GitHub as well as in various git tools.

The **footer** is required to close issues. It must contains the closing reference
to the issues it solves.

```
feature(flutter): Add environment specific configuration for dev and prod.
```
```
feature(prisma): Setup authentication endpoints

Create the User model.
Create signup and signin endpoints.
```

### Revert
If the commit reverts a previous commit, it should begin with `revert: `, followed
by the header of the reverted commit. In the body it should say:
`This reverts commit <hash>.`, where the hash is the SHA of the commit being reverted.

### Type
Must be one of the following:

* **build**: Changes that affect the build system or external dependencies.
* **ci**: Changes to our CI configuration files and scripts.
* **docs**: Documentation only changes.
* **feature**: A new feature.
* **fix**: A bug fix.
* **perf**: A code change that improves performance.
* **refactor**: A code change that neither fixes a bug nor adds a feature.
* **style**: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc).
* **test**: Adding missing tests or correcting existing tests.

### Scope
The scope should be the name of the npm package affected (as perceived by the person reading the changelog generated from commit messages.

The following is the list of supported scopes:

* **docker**
* **nginx**
* **prisma**
* **flutter**
* **certbot**

### Subject
The subject contains a succinct description of the change:

* use the imperative, present tense: "change" not "changed" nor "changes"
* don't capitalize the first letter
* no dot (.) at the end

### Body
Just as in the **subject**, use the imperative, present tense: "change" not "changed" nor "changes".
The body should include the motivation for the change and contrast this with previous behavior.

### Footer
The footer should contain any information about **Breaking Changes** and is also
the place to reference GitHub issues that this commit **Closes**.

**Breaking Changes** should start with the word `BREAKING CHANGE:` with a space
or two newlines. The rest of the commit message is then used for this.
