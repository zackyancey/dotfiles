export EDITOR=/usr/bin/vim

# Setting this to 1 helps some apps scale better for high-DPI
export QT_AUTO_SCREEN_SCALE_FACTOR=1

export QT_QPA_PLATFORMTHEME="qt5ct"
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

if [[ -f $HOME/.dotfiles/local/profile ]]; then
  source $HOME/.dotfiles/local/profile
fi
