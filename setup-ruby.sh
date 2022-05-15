#!/usr/bin/env bash
set -ue

if which brew >/dev/null; then
  brew install rbenv ruby-build
else
  if [ -e ~/.rbenv ]; then
    git -C ~/.rbenv pull
  else
    git clone https://github.com/rbenv/rbenv.git ~/.rbenv
  fi

  if [ -e ~/.rbenv/plugins/ruby-build ]; then
    git -C ~/.rbenv/plugins/ruby-build pull
  else
    git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
  fi

  if ! which rbenv >/dev/null; then
    if ! grep rbenv ~/.profile >/dev/null; then
      echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.profile
    fi
  fi
fi

if ! grep rbenv ~/.bashrc >/dev/null; then
  echo '# Ruby' >> ~/.bashrc
  echo 'eval "$(rbenv init - bash)"' >> ~/.bashrc
fi
# if ! grep rbenv ~/.zshrc >/dev/null; then
#   echo '# Ruby' >> ~/.zshrc
#   echo 'eval "$(rbenv init - zsh)"' >> ~/.zshrc
# fi

if which apt-get >/dev/null;then
  packages=(build-essential libssl-dev libreadline-dev zlib1g-dev)
  needs_apt=no
  for package in "${packages[@]}"; do
    if ! dpkg -l | grep "$package" >/dev/null; then
      needs_apt=yes
    fi
  done
  if [ "$needs_apt" = yes ]; then
    echo "Installing following packages: ${packages[*]}" >&2
    sudo apt-get install -y "${packages[@]}"
  fi
fi

echo "Installing latest stable Ruby versions" >&2
for version in $($HOME/.rbenv/bin/rbenv install -l | grep '^[23]'); do
  $HOME/.rbenv/bin/rbenv install -s $version
done
