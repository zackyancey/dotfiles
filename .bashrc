# Don't do anything if not running interactively
[[ $- != *i* ]] && return

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Change the window title of X terminals
case ${TERM} in
	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
		;;
	screen*)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
		;;
esac

xhost +local:root > /dev/null 2>&1

complete -cf sudo

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

shopt -s expand_aliases

# Enable history appending instead of overwriting.  #139609
shopt -s histappend

#######################################
# Prompt
#######################################

sbp_path=$HOME/.dotfiles/sbp
if [[ $USE_BASIC_PROMPT =~ "1" || ! -f "$sbp_path"/sbp.bash ]]; then
  # Enable basic prompt
  source $HOME/.dotfiles/basic_prompt.bash $USE_BASIC_PROMPT
  unset sbp_path
else
  # Enable fancy prompt
  source $HOME/.dotfiles/sbp/sbp.bash
fi


#######################################
# Other files
#######################################

if [ -f $HOME/.dotfiles/local/bashrc ]; then
  source $HOME/.dotfiles/local/bashrc
fi

source $HOME/.dotfiles/shellrc.sh
