# Enable color on some commands
alias ls='ls --color=auto'
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'

# other bhavoir changes for bash utilities
alias cp="cp -i"  # confirm before overwriting something
alias df='df -h'  # human-readable sizes


# Shortened names
alias g=git
alias gl="git log"
alias gs="git status"
alias v=vim
alias gv=gvim

# Open the current directory in the file manager
if [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" ]]; then
  alias e.="explorer .;:"
else
  alias e.="xdg-open ."
fi

# 'config' for dotfile revision control
export CONFIG_HOME=$HOME
if uname -s | grep -qi "cygwin"; then
  # If running on cygwin, we might be using the windows version of git (because
  # cygwin's git performance with antivirus is often terrible). If we are, we
  # need to use a different path.
  if git --version | grep -qi "windows"; then
    export CONFIG_HOME="$(cygpath -am $HOME)"
  fi
fi

alias config="git --git-dir \"$CONFIG_HOME/..dotfiles\" --work-tree $CONFIG_HOME"

# Make aliases work with sudo
# Normally, only the first word of a command is checked for an alias. However,
# if the first word is an alias and the expansion ends with a space, the second
# word will be checked as well.
alias sudo="sudo "


###############################################################################
# Functions
###############################################################################
ex () {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}


colors() {
	local fgc bgc vals seq0

	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

	# foreground colors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black

			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}

			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}
