# In some environments calls to git or sbp can be really slow (ie Cygwin on
# Windows with corporate antivirus...). In those environments this prompt
# covers the basics.

function exit_code {
  RETVAL=$?
  [ $RETVAL -ne 0 -a $RETVAL -ne 130 ] && echo "$RETVAL "
}

export PS1='\n\[\e[32m\]\u@\h\[\e[0m\] \[\e[36m\]\w\[\e[0m\]\n \[\e[31;1m\]`exit_code`\[\e[0m\]\[\e[90m\]λ\[\e[0m\] '
export PROMPT_COMMAND=""
