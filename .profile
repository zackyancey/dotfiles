if [ -z ${__PROFILE+x} ]; then
  export __PROFILE=1
  export EDITOR=/usr/bin/vim

  # Setting this to 1 helps some apps scale better for high-DPI
  export QT_AUTO_SCREEN_SCALE_FACTOR=1

  export QT_QPA_PLATFORMTHEME="qt5ct"
  export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

  echo $PATH | grep -q "$HOME/\.bin" || export PATH="$PATH:$HOME/.bin"
  echo $PATH | grep -q "$HOME/\.local/bin" || export PATH="$PATH:$HOME/.local/bin"
  [[ -f $HOME/.dotfiles/local/profile ]] && source $HOME/.dotfiles/local/profile
fi
