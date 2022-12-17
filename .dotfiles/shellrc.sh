# Load the profile if it hasn't been loaded yet
source $HOME/.profile

# Load aliases
source $HOME/.dotfiles/alias.sh

# Enable ssh agent
SSH_ENV="$HOME/.ssh/environment"
function start_agent {
     echo "Initialising new SSH agent..."
     ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
     echo succeeded
     chmod 600 "${SSH_ENV}"
     . "${SSH_ENV}" > /dev/null
}

# Source SSH settings, if applicable
if [ -f "${SSH_ENV}" ]; then
  . "${SSH_ENV}" > /dev/null
  #ps ${SSH_AGENT_PID} doesn't work under cywgin
  ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
    start_agent;
  }
else
  start_agent;
fi

[ -f $HOME/.dotfiles/local/shellrc.sh ] && source $HOME/.dotfiles/local/shellrc.sh

# Print welcome message
source $HOME/.dotfiles/welcome.sh
