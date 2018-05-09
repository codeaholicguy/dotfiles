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

function install_macos {
  if [[ $OSTYPE != darwin* ]]; then
    return
  fi
  echo "MacOS detected"
  xcode-select --install

  if [ "$(is_installed brew)" == "0" ]; then
    echo "Installing Homebrew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  if [ $TERM_PROGRAM != "iTerm.app" ]; then
    echo "Installing iTerm2"
    brew tap caskroom/cask
    brew cask install iterm2
  fi

  if [ "$(is_installed zsh)" == "0" ]; then
    echo "Installing zsh"
    brew install zsh zsh-completions
    echo "Installing oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  fi

  if [ "$(is_installed ag)" == "0" ]; then
    echo "Installing The silver searcher"
    brew install the_silver_searcher
  fi

  if [ "$(is_installed fzf)" == "0" ]; then
    echo "Installing fzf"
    brew install fzf
  fi

  if [ "$(is_installed tmux)" == "0" ]; then
    echo "Installing tmux"
    brew install tmux
    echo "Installing reattach-to-user-namespace"
    brew install reattach-to-user-namespace
    echo "Installing tmux-plugin-manager"
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  fi

  if [ "$(is_installed git)" == "0" ]; then
    echo "Installing Git"
    brew install git
  fi

  if [ "$(is_installed node)" == "0" ]; then
    echo "Installing Node"
    brew install node

    echo "Installing Yarn"
    brew install yarn
  fi

  if [ "$(is_installed python3)" == "0" ]; then
    echo "Installing python3"
    brew install python3
  fi

  if [ "$(is_installed nvim)" == "0" ]; then
    echo "Install neovim"
    brew install neovim
    if [ "$(is_installed pip3)" == "1" ]; then
      pip3 install neovim --upgrade
    fi
  fi

  if [ "$(is_installed tmuxinator)" == "0" ]; then
    echo "Install tmuxinator"
    gem install tmuxinator
  fi
}

function backup {
  echo "Backing up dotfiles"
  local current_date=$(date +%s)
  local backup_dir=dotfiles_$current_date

  mkdir ~/$backup_dir

  mv ~/.zshrc ~/$backup_dir/.zshrc
  mv ~/.tmux.conf ~/$backup_dir/.tmux.conf
  mv ~/.vim ~/$backup_dir/.vim
  mv ~/.vimrc ~/$backup_dir/.vimrc
  mv ~/.vimrc.bundles ~/$backup_dir/.vimrc.bundles
}

function link_dotfiles {
  echo "Linking dotfiles"

  ln -s $(pwd)/zshrc ~/.zshrc
  ln -s $(pwd)/tmux.conf ~/.tmux.conf
  ln -s $(pwd)/vim ~/.vim
  ln -s $(pwd)/vimrc ~/.vimrc
  ln -s $(pwd)/vimrc.bundles ~/.vimrc.bundles

  if [ "$(is_installed nvim)" == "1" ]; then
    rm -rf $HOME/.config/nvim/init.vim
    rm -rf $HOME/.config/nvim
    mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
    ln -s $(pwd)/vim $XDG_CONFIG_HOME/nvim
    ln -s $(pwd)/vimrc $XDG_CONFIG_HOME/nvim/init.vim
  fi

  if [ ! -d "$ZSH/custom/plugins/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions"
    git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH/custom/plugins/zsh-autosuggestions
  fi

  if [ "$(is_installed npm)" == "1" ]; then
    echo "Installing ternjs for autocomplete javascript in vim/nvim"
    npm install -g tern

    echo "Installing prettier"
    npm install -g prettier
  fi

  zsh
  source ~/.zshrc
}

while test $# -gt 0; do 
  case "$1" in
    --help)
      echo "Help"
      exit
      ;;
    --macos)
      install_macos
      sleep 10
      backup
      sleep 10
      link_dotfiles
      sleep 10
      install_macos
      sleep 10
      backup
      sleep 10
      link_dotfiles
      exit
      ;;
    --backup)
      backup
      exit
      ;;
    --dotfiles)
      link_dotfiles
      exit
      ;;
  esac

  shift
done
