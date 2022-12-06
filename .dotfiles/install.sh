function finish() {
  echo "Installation failed"
  popd > /dev/null
  exit $1
}

pushd $HOME > /dev/null

# Get the dotfiles repo
if [[ ! -d ..dotfiles ]]; then
  echo "Cloning dotfiles repo..."
  git clone --bare https://github.com/zackyancey/dotfiles.git $HOME/..dotfiles

  if [[ $? -ne 0 ]]; then
    echo "ERROR: Couldn't clone repository."
    finish 1
  fi
fi

# Get the `config` command
shopt -s expand_aliases
# The MSYS2_ARG_CONV_EXCL variable keeps msys from converting the path argument
# to a windows path, which would make git not recognize it.
eval "`MSYS2_ARG_CONV_EXCL="HEAD" git --git-dir ..dotfiles/ show HEAD:.dotfiles/alias.sh`"

# Set up branches to fetch
config config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
config fetch

# Switch remote to ssh for any future pushes.
config remote set-url origin git@github.com:zackyancey/dotfiles.git

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
  config diff --name-only --diff-filter=d | xargs -I{} sh -c 'mkdir -p config-backup/$(dirname {})' || (echo "Backing up a file failed)"; finish 1)
  config diff --name-only --diff-filter=d | xargs -I{} mv {} config-backup/{} || (echo "Backing up a file failed)"; finish 1)
fi

# Check out the dotfiles
config checkout -f
config submodule init
config submodule update

# Set the local repository to use the gitignore file in .dotfiles
config config --local core.excludesfile .dotfiles/home.gitignore
# Include git config from the repo in the global config file
git config --global include.path .dotfiles/include.gitconfig

# Make sure that our version-controlled config file is inculded in the SSH config
[[ -f "$HOME"/.ssh/config ]] || echo > "$HOME"/.ssh/config
grep -qxF 'Include ~/.ssh/base_config' "$HOME"/.ssh/config || sed -i '1s;^;Include ~/.ssh/base_config\n;' "$HOME"/.ssh/config

# Install zsh prompt
mkdir -p $HOME/.zsh
[[ -d "$HOME"/.zsh/agkozak-zsh-prompt ]] || git clone https://github.com/agkozak/agkozak-zsh-prompt.git $HOME/.zsh/agkozak-zsh-prompt

# Download fzf completions
mkdir -p $HOME/.zsh/fzf
curl 'https://raw.githubusercontent.com/junegunn/fzf/master/shell/completion.zsh' -o $HOME/.zsh/fzf/completion.zsh
curl 'https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.zsh' -o $HOME/.zsh/fzf/key-bindings.zsh

popd > /dev/null
echo "Installation complete. Note that files like .profile, .bashrc, etc, may not take effect until you log in again or source them manually."
