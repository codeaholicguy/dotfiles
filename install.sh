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

function install_nvm {
  if [ "$(is_installed nvm)" == "0" ] && [ ! -s "$HOME/.nvm/nvm.sh" ]; then
    echo "Installing nvm"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
    echo "Please run 'nvm install --lts' to install the latest LTS version of Node.js"
  fi
}

function install_oh_my_zsh {
  if [[ ! -d ~/.oh-my-zsh ]]; then
    echo "Installing oh-my-zsh"
    unset ZSH
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi

  local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
  if [ ! -d "$zsh_custom/plugins/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions"
    git clone https://github.com/zsh-users/zsh-autosuggestions "$zsh_custom/plugins/zsh-autosuggestions"
  fi
}

function install_macos {
  if [[ $OSTYPE != darwin* ]]; then
    return
  fi
  echo "MacOS detected"
  xcode-select --install

  if [ "$(is_installed brew)" == "0" ]; then
    echo "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  if [ ! -d "/Applications/iTerm.app" ]; then
    echo "Installing iTerm2"
    brew tap homebrew/cask
    brew install iterm2 --cask
  fi

  if [ "$(is_installed zsh)" == "0" ]; then
    echo "Installing zsh"
    brew install zsh zsh-completions
  fi

  install_oh_my_zsh

  if [ "$(is_installed rg)" == "0" ]; then
    echo "Installing ripgrep"
    brew install ripgrep
  fi

  if [ "$(is_installed fzf)" == "0" ]; then
    echo "Installing fzf"
    brew install fzf
    /opt/homebrew/opt/fzf/install
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

  if [ "$(is_installed gh)" == "0" ]; then
    echo "Installing Github CLI"
    brew install gh
  fi

  if [ "$(is_installed nvim)" == "0" ]; then
    echo "Install neovim"
    brew install neovim
    if [ "$(is_installed pip3)" == "1" ]; then
      pip3 install neovim --upgrade
    fi
  fi
}

function install_linux {
  if [[ $OSTYPE != linux* ]]; then
    return
  fi
  echo "Linux detected"

  if [ "$(is_installed apt-get)" != "1" ]; then
    echo "Only apt-based Linux distributions are supported by this installer."
    exit 1
  fi

  local packages=()

  [ "$(is_installed curl)" == "0" ] && packages+=(curl)
  [ "$(is_installed git)" == "0" ] && packages+=(git)
  [ "$(is_installed zsh)" == "0" ] && packages+=(zsh)
  [ "$(is_installed fzf)" == "0" ] && packages+=(fzf)
  [ "$(is_installed tmux)" == "0" ] && packages+=(tmux)
  [ "$(is_installed nvim)" == "0" ] && packages+=(neovim)
  [ "$(is_installed rg)" == "0" ] && packages+=(ripgrep)
  [ "$(is_installed pip3)" == "0" ] && packages+=(python3-pip)

  if [ ${#packages[@]} -gt 0 ]; then
    echo "Installing Linux packages: ${packages[*]}"
    sudo apt-get update
    sudo apt-get install -y "${packages[@]}"
  fi

  install_oh_my_zsh

  if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "Installing tmux-plugin-manager"
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  fi

  if [ "$(is_installed pip3)" == "1" ]; then
    pip3 install --user neovim --upgrade
  fi

  install_nvm
}

function install_dependencies {
  install_macos
  install_linux
}

function backup {
  echo "Backing up dotfiles"
  local current_date=$(date +%s)
  local backup_dir=dotfiles_$current_date

  mkdir ~/$backup_dir

  [ -e ~/.zshrc ] && mv ~/.zshrc ~/$backup_dir/.zshrc
  [ -e ~/.tmux.conf ] && mv ~/.tmux.conf ~/$backup_dir/.tmux.conf
  [ -e ~/.vim ] && mv ~/.vim ~/$backup_dir/.vim
  [ -e ~/.vimrc ] && mv ~/.vimrc ~/$backup_dir/.vimrc
  [ -e ~/.vimrc.bundles ] && mv ~/.vimrc.bundles ~/$backup_dir/.vimrc.bundles
}

function link_dotfiles {
  echo "Removing existing config"
  rm -rf $HOME/.config/nvim/init.vim
  rm -rf $HOME/.config/nvim
  rm -rf $HOME/.vim/bundle/*

  echo "Linking dotfiles"
  ln -sf "$(pwd)/zshrc" ~/.zshrc

  ln -sf "$(pwd)/tmux.conf" ~/.tmux.conf

  echo "Creating vim symlinks"
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  mkdir -p "$HOME/.vim"
  ln -sf "$(pwd)/vim/coc-settings.json" "$HOME/.vim/coc-settings.json"
  ln -sf "$(pwd)/vimrc" "$HOME/.vimrc"
  ln -sf "$(pwd)/vimrc" "$HOME/.vim/init.vim"
  ln -sf "$(pwd)/vimrc.bundles" ~/.vimrc.bundles

  mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}

  ln -sfn "$HOME/.vim" "$XDG_CONFIG_HOME/nvim"

  if [[ ! -f ~/.zshrc.local ]]; then
    echo "Creating .zshrc.local"
    touch ~/.zshrc.local
  fi
}

function install_theme {
  echo "Installing theme"

  mkdir -p "$HOME/.oh-my-zsh/themes"
  ln -sf "$(pwd)/schemes/dracula.zsh-theme" "$HOME/.oh-my-zsh/themes/dracula.zsh-theme"
  echo 'ZSH_THEME="dracula"' > "$HOME/.zshrc.theme"

  mkdir -p "$HOME/.vim"
  ln -sfn "$(pwd)/vim/colors" "$HOME/.vim/colors"
  echo 'colorscheme dracula' > "$HOME/.vimrc.theme"

  if [[ $OSTYPE == darwin* ]]; then
    echo "iTerm2 color scheme is available at $(pwd)/schemes/dracula.itermcolors"
  fi
}

function post_install {
  echo "Post install"
  echo "Installing vim plugins"
  vim +PlugClean +PlugInstall

  echo "Installing coc plugins"
  vim +"CocInstall coc-json coc-tsserver coc-html coc-css coc-yaml coc-python coc-clangd coc-cmake coc-deno coc-docker coc-eslint coc-flutter coc-fzf-preview coc-git coc-go coc-graphql coc-highlight coc-pairs coc-prettier coc-rust-analyzer coc-snippets coc-sql coc-tailwindcss"

  echo "Install nvm"
  install_nvm
}

function usage {
  echo "Usage: ./install.sh [options]"
  echo ""
  echo "Options:"
  echo "  --macos        Install macOS dependencies, dotfiles, and plugins"
  echo "  --linux        Install Ubuntu dependencies and dotfiles"
  echo "  --deps         Install dependencies for the current OS"
  echo "  --dotfiles     Backup existing files and link dotfiles only"
  echo "  --theme        Install Dracula theme links and opt-in config"
  echo "  --backup       Backup existing dotfiles only"
  echo "  --post-install Install vim/coc plugins and nvm"
  echo "  --help         Show this help"
}

while test $# -gt 0; do 
  case "$1" in
    --help)
      usage
      exit
      ;;
    --macos)
      install_macos
      backup
      link_dotfiles
      post_install
      zsh
      source ~/.zshrc
      exit
      ;;
    --linux)
      install_linux
      backup
      link_dotfiles
      zsh
      source ~/.zshrc
      exit
      ;;
    --deps)
      install_dependencies
      exit
      ;;
    --backup)
      backup
      exit
      ;;
    --dotfiles)
      backup
      link_dotfiles
      exit
      ;;
    --theme)
      install_theme
      exit
      ;;
    --post-install)
      post_install
      exit
      ;;
  esac

  shift
done

usage
