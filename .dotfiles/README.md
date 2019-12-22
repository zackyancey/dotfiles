# Dotfiles

This dotfiles repo is set up to be used with the bare git repo method described
[here](https://www.atlassian.com/git/tutorials/dotfiles).

## Setup

To set up on a new machine, first clone the repository:

```bash
# Using https:
git clone --bare https://github.com/zackyancey/dotfiles.git $HOME/..dotfiles
# or, using ssh:
git clone --bare git@github.com:zackyancey/dotfiles.git $HOME/..dotfiles
```

Then, set up the `config` alias and check out the repository:

```bash
source .dotfiles/alias
```

Finally, configure the repository for a non-standard `.gitignore` location.

```bash
git config --local core.excludesfile .dotfiles/home.gitignore
```
