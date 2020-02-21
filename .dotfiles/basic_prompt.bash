# In some environments calls to git or sbp can be really slow (ie Cygwin on
# Windows with corporate antivirus...). In those environments this prompt
# covers the basics.

function nonzero_return() {
  RETVAL=$?
  [ $RETVAL -ne 0 ] && echo "$RETVAL "
}

export PS1='\n\[\e[32m\]\u@\h\[\e[0m\] \[\e[36m\]\w\[\e[0m\]\n \[\e[31;1m\]`nonzero_return`\[\e[0m\]\[\e[90m\]λ\[\e[0m\] '
export PROMPT_COMMAND=""
