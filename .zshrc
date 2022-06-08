# Don't do anything if not running interactively
[[ $- != *i* ]] && return

source $HOME/.dotfiles/shellrc.sh

fpath+=~/.zsh

#######################################
# Shell options
#######################################
# See [http://zsh.sourceforge.net/Intro/intro_16.html]
setopt autocd               # Go to directories just by typing the name without cd
setopt ignoreeof            # ctrl+D doesn't kill the shell
setopt interactivecomments  # Allow comments in the shell
setopt rcquotes             # '' -> ' in single-quote strings.
setopt hist_ignore_dups     # Ignore consecutive duplicates in history
setopt hist_ignore_all_dups # Ignore all duplicates in history
bindkey -v                  # Enable vim mode
#######################################
# Prompt
#######################################

# Setup prompt [https://github.com/agkozak/agkozak-zsh-prompt]
AGKOZAK_MULTILINE=0
AGKOZAK_LEFT_PROMPT_ONLY=$AGKOZAK_MULTILINE
AGKOZAK_CUSTOM_SYMBOLS=( '↕' '↓' '↑' '+' 'x' '!' '>' '?' '$')
AGKOZAK_PROMPT_CHAR=( '%F{magenta}❯%f' '%F{red}❯%f' '%F{magenta}❮%f' )
source $HOME/.zsh/agkozak-zsh-prompt/agkozak-zsh-prompt.plugin.zsh


#######################################
# Completions
#######################################


# enable menu-style completion
zstyle ':completion:*' menu select

# complete hard drives in msys2 [https://github.com/msys2/MSYS2-packages/issues/38]
drives=$(mount | sed -rn 's#^[A-Z]: on /([a-z]).*#\1#p' | tr '\n' ' ')
zstyle ':completion:*' fake-files /: "/:$drives"
unset drives

# case insensitive completion [https://superuser.com/a/1092328]
# zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

# Fuzzy completion [https://superuser.com/a/815317]
zstyle ':completion:*' matcher-list '' \
  'r:|?=** m:{a-z\-}={A-Z\_}'

# Colored completions [https://unix.stackexchange.com/a/447002]
zstyle ':completion:*' list-colors

autoload -Uz compinit
compinit

autoload -Uz zmv

#######################################
# Other files
#######################################

if [ -f $HOME/.dotfiles/local/zshrc ]; then
  source $HOME/.dotfiles/local/zshrc
fi

