#!/bin/bash
set -ue

ignores=("my" "coq.vim" "happy.vim" "alex.vim" "kappa.vim" "vim-ssh-annex")
for i in *; do
  if [[ ! -d $i ]]; then
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
