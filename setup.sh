#!/usr/bin/env bash
set -ue

basedir="$(dirname "$(realpath $0)")"
basedir_relative="~/$(realpath --relative-to="$HOME" "$basedir")"

# Ensure submodules
git -C $basedir submodule update --init --recursive

# Configure shell profiles
if [ ! -e ~/.zshrc ]; then
  cat >~/.zshrc <<ZSHRC
# ZSH_HOST_EMBLEM=blue
# ZSH_LOCAL_TITLE=yes
# source $basedir_relative/zshrc-runtmux.sh
source $basedir_relative/zshrc.sh

# Use this after eval "\$(pyenv virtualenv-init - zsh)"
# pyenv-virtualenv-fast-init

# Remove path duplicates
typeset -U PATH
ZSHRC
fi

if [ ! -e ~/.zprofile ]; then
  cat >~/.zprofile <<ZPROFILE
. ~/.profile
ZPROFILE
fi

# Configure vimrc
if [ ! -e ~/.zshrc ]; then
  cat >~/.vimrc <<ZSHRC
source $basedir_relative/vimrc.vim
ZSHRC
fi

# Configure EDITOR
if ! grep EDITOR ~/.profile >/dev/null; then
  if which vim >/dev/null; then
    cat >>~/.profile <<PROFILE
export EDITOR=vim
PROFILE
  fi
fi

# Configure VS Code
if which code >/dev/null; then
  code --install-extension vscodevim.vim
  code --install-extension GitHub.vscode-pull-request-github
  code --install-extension MS-CEINTL.vscode-language-pack-ja
  code --install-extension EditorConfig.EditorConfig

  # Rust
  code --install-extension rust-lang.rust-analyzer
  code --install-extension bungcip.better-toml

  # JavaScript
  code --install-extension dbaeumer.vscode-eslint
  code --install-extension esbenp.prettier-vscode
fi
