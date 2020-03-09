# In some environments calls to git or sbp can be really slow (ie Cygwin on
# Windows with corporate antivirus...). In those environments this prompt
# covers the basics.

function exit_code {
  RETVAL=$?
  [ $RETVAL -ne 0 -a $RETVAL -ne 130 ] && echo "$RETVAL "
}

function git_prompt {
  path=${PWD}
  while [[ $path ]]; do
    if [[ -d "${path}/.git" || -f "${path}/.git" ]]; then
      git_folder="${path}/.git"
      break
    fi
    path=${path%/*}
  done

  git_status=`git status --porcelain --branch 2>/dev/null`
  if [ $? -ne 0 ]; then
    return 0
  fi

  additions=0
  modifications=0
  deletions=0
  untracked=0

  while read -r line; do
    compacted=${line// }
    action=${compacted:0:1}
    case $action in
      A)
        additions_icon=' +'
        additions=$(( additions + 1 ))
        ;;
      M|R)
        modifications_icon=' ~'
        modifications=$(( modifications + 1 ))
        ;;
      D)
        deletions_icon=' -'
        deletions=$(( deletions + 1 ))
        ;;
      \?)
        untracked_icon=' ?'
        untracked=$(( untracked + 1 ))
        ;;
      \#)
        branch_line=${line/\#\# /}
        branch_data=${branch_line/% *}
        branch="${branch_data/...*/}"
        upstream_data="${branch_line#* }"
        upstream_stripped="${upstream_data//[\[|\]]}"
        if [[ "$upstream_data" != "$upstream_stripped" ]]; then
          outgoing_filled="${upstream_stripped/ahead /${outgoing_icon}}"
          upstream_status="${outgoing_filled/behind /${incoming_icon}}"
        fi
    esac
  done <<< "$git_status"

  git_state="${additions_icon}${additions/#0/}${modifications_icon}${modifications/#0/}${deletions_icon}${deletions/#0/}${untracked_icon}${untracked/#0/}"

  # git status does not support detached head
  if [[ "$branch" != 'HEAD' ]]; then
    git_head="$branch"
  else
    git_head=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
  fi

  if [[ $(( ${#git_head} + ${#git_state} )) -gt 10 ]]; then
    git_head="${git_head:0:10}.."
  fi

  segment_value="${git_state} ${git_head} ${upstream_status}"
  segment_value="${segment_value// / }"
  shopt -s extglob
  segment_value="${segment_value##*( )}"  # Trim leading whitespaces
  segment_value="${segment_value%%*( )}"  # Trim trailing whitespaces
  shopt -u extglob
  echo "${segment_value//  / }"
}

if [[ $1 =~ "g" ]]; then
    export PS1='\n\[\e[32m\]\u@\h\[\e[0m\] \[\e[36m\]\w\[\e[0m\] `git_prompt`\n \[\e[31;1m\]`exit_code`\[\e[0m\]\[\e[90m\]λ\[\e[0m\] '
else
    export PS1='\n\[\e[32m\]\u@\h\[\e[0m\] \[\e[36m\]\w\[\e[0m\]\n \[\e[31;1m\]`exit_code`\[\e[0m\]\[\e[90m\]λ\[\e[0m\] '
fi

export PROMPT_COMMAND=""
