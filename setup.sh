#!/usr/bin/env bash
set -ue

if which code >/dev/null; then
  code --install-extension vscodevim.vim
  code --install-extension GitHub.vscode-pull-request-github
  code --install-extension MS-CEINTL.vscode-language-pack-ja

  # Rust
  code --install-extension rust-lang.rust-analyzer
  code --install-extension bungcip.better-toml

  # JavaScript
  code --install-extension dbaeumer.vscode-eslint
  code --install-extension esbenp.prettier-vscode
fi
