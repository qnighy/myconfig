if [[ ! -n "${TMUX-}" ]]; then
  if tmux has-session; then
    tmux attach-session || exit $?
    exit 0
  else
    tmux || exit $?
    exit 0
  fi
fi
