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
cp .vimrc ~/.vimrc
cp .vimrc.bundles ~/.vimrc.bundles

# Install ternjs for vim
if [ "$(is_installed npm)" == "1" ]; then
  echo "Install ternjs for autocomplete javascript in vim/nvim"
  npm install -g tern
fi

if [[ $OSTYPE == darwin* ]]; then
  if [ "$(is_installed brew)" == "1" ]; then
    echo "Install brew formula reattach-to-user-namespace for copying in vim with
    tmux"
    brew install reattach-to-user-namespace
  fi
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
