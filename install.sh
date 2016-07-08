#!/bin/bash

# Utils
function is_installed {
  # set to 1 initially
  local return_=1
  # set to 0 if not found
  type $1 >/dev/null 2>&1 || { local return_=0;  }
  # return
  echo "$return_"
}

# Copy files
echo "Copying dotfiles"
cp .zshrc ~/.zshrc
cp .tmux.conf ~/.tmux.conf
cp -R .vim ~/.vim

# Install ternjs for vim
if [ "$(is_installed npm)" == "1" ]; then
  echo "Install ternjs for autocomplete javascript in vim/nvim"
  eval "npm install -g tern"
fi

# Handle options
while test $# -gt 0; do 
  case "$1" in
    --nvim)
      # Install dotfiles for nvim
      echo "Copying file for neovim"
      mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
      ln -s ~/.vim $XDG_CONFIG_HOME/nvim
      ln -s ~/.vimrc $XDG_CONFIG_HOME/nvim/init.vim
      ;;
  esac

  shift
done
