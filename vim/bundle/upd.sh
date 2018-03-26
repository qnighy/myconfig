#!/bin/bash
set -ue

ignores=("my" "coq.vim" "vim-ssh-annex" "lalrpop.vim" "satysfi.vim")
for i in *; do
  if [[ ! -f $i/.git ]]; then
    continue
  fi
  if [[ " ${ignores[*]} " == *" $i "* ]]; then
    echo "ignoring $i" >&2
    continue
  fi
  echo "updating $i" >&2
  cd $i
  (git checkout master && git pull origin master) || \
    echo "============== failed to update $i ==============" >&2
  cd ..
done
