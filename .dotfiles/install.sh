function finish() {
  echo "Installation failed"
  popd > /dev/null
  exit $1
}

pushd $HOME > /dev/null

# Create the bare repository
if [[ USE_SSH -eq 1 ]]; then
  git clone --bare git@github.com:zackyancey/dotfiles.git $HOME/..dotfiles
else
  git clone --bare https://github.com/zackyancey/dotfiles.git $HOME/..dotfiles
fi

if [[ $? -ne 0 ]]; then
  echo "ERROR: Couldn't clone repository."
  finish 1
fi

# Get the `config` command
shopt -s expand_aliases
alias config=`git --git-dir ..dotfiles/ show HEAD:.dotfiles/alias | sed -n 's/alias config="\(.*\)"$/\1/p'`

# Make sure git isn't doing anything funny with line endings.
config config --local core.autocrlf false

# Sometimes files that didn't exist from the start end up staged, which messes
# up checkout. Make sure no files are staged.
config reset > /dev/null
if [[ -n $(config diff --name-only --diff-filter=d) ]]; then
  # There are files in the worktree that will be overwritten by a checkout.
  # Back them up.
  echo "Existing config files found:"
  config diff --name-only --diff-filter=d
  echo

  echo "Backing up existing config files in ~/config-backup"
  if [[ -d config-backup || -f config-backup ]]; then
    echo "ERROR: I need to backup files to ~/config-backup, but it already exists. Please delete or rename that folder."
    finish 1
  fi
  mkdir -p config-backup
  config diff --name-only --diff-filter=d | xargs -I{} mv {} config-backup/{}
fi

# Check out the dotfiles
config checkout -f
config submodule init
config submodule update

# Set the local repository to use the gitignore file in .dotfiles
config config --local core.excludesfile .dotfiles/home.gitignore
# Include git config from the repo in the global config file
config config --global include.path=.dotfiles/include.gitconfig


popd > /dev/null
echo "Installation complete. Note that files like .profile, .bashrc, etc, may not take effect until you log in again or source them manually."
