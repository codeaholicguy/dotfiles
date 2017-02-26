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

# Handle options
while test $# -gt 0; do 
  case "$1" in
    --help)
      echo "Help"
      exit
      ;;
  esac

  shift
done

# Install brew if any
if [[ $OSTYPE == darwin* ]]; then
  if [ "$(is_installed brew)" == "0" ]; then
    echo "MacOS detected"
    echo "Homebrew is not installed, installing"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
fi

# Install zsh if any
if [[ $OSTYPE == darwin* ]]; then
  if [ "$(is_installed zsh)" == "0" ]; then
    echo "MacOS detected"
    echo "ZSH is not installed, installing"
    if [ "$(is_installed brew)" == "1" ]; then
      brew install zsh zsh-completions
      echo "Installing Oh My Zsh"
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    fi
  fi
fi

# Install the silver searcher if any
if [[ $OSTYPE == darwin* ]]; then
  if [ "$(is_installed ag)" == "0" ]; then
    echo "MacOS detected"
    echo "The silver searcher is not installed, installing"
    if [ "$(is_installed brew)" == "1" ]; then
      brew install the_silver_searcher
    fi
  fi
fi

# Install fzf if any
if [[ $OSTYPE == darwin* ]]; then
  if [ "$(is_installed fzf)" == "0" ]; then
    echo "MacOS detected"
    echo "Fzf is not installed, installing"
    if [ "$(is_installed brew)" == "1" ]; then
      brew install fzf
    fi
  fi
fi

# Install tmux if any
if [[ $OSTYPE == darwin* ]]; then
  if [ "$(is_installed tmux)" == "0" ]; then
    echo "MacOS detected"
    echo "Tmux is not installed, installing"
    if [ "$(is_installed brew)" == "1" ]; then
      brew install tmux
    fi
  fi
fi

# Backup if any
echo "Backing up old dotfiles if any"
mv ~/.zshrc "~/.zshrc.$(date +%s)"
mv ~/.tmux.conf "~/.tmux.conf.$(date +%s)"
mv ~/.vim "~/.vim.$(date +%s)"
mv ~/.vimrc "~/.vimrc.$(date +%s)"
mv ~/.vimrc.bundles "~/.vimrc.bundles.$(date +%s)"

# Copy files
echo "Copying dotfiles"
cp zshrc ~/.zshrc
cp tmux.conf ~/.tmux.conf
mkdir ~/.vim
cp -R vim/* ~/.vim/
cp vimrc ~/.vimrc
cp vimrc.bundles ~/.vimrc.bundles

# Install ternjs for vim
if [ "$(is_installed npm)" == "1" ]; then
  echo "Installing ternjs for autocomplete javascript in vim/nvim"
  npm install -g tern
fi

# Update formular for copying in vim
if [[ $OSTYPE == darwin* ]]; then
  if [ "$(is_installed brew)" == "1" ]; then
    echo "Installing brew formula reattach-to-user-namespace for copying in vim with tmux"
    brew install reattach-to-user-namespace
  fi
fi

# Install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install neovim
if [[ $OSTYPE == darwin* ]]; then
  if [ "$(is_installed nvim)" == "0" ]; then
    echo "MacOS detected"
    echo "Neovim is not installed, installing"
    if [ "$(is_installed brew)" == "1" ]; then
      brew install neovim/neovim/neovim
      # Install dotfiles for nvim
      echo "Copying file for neovim"
      mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
      ln -s ~/.vim $XDG_CONFIG_HOME/nvim
      ln -s ~/.vimrc $XDG_CONFIG_HOME/nvim/init.vim
    fi
  fi
fi

if [ "$(is_installed nvim)" == "1" ]; then
  # Install dotfiles for nvim
  echo "Copying file for neovim"
  mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
  ln -s ~/.vim $XDG_CONFIG_HOME/nvim
  ln -s ~/.vimrc $XDG_CONFIG_HOME/nvim/init.vim
fi
