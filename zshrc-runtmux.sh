#!/usr/bin/env zsh

# If $SSH_CONNECTION is defined but $TMUX not yet defined, launch tmux.
if [[ -z "${TMUX-}" && -n "${SSH_CONNECTION-}" ]]; then
  # Try to find existing session
  if tmux has-session; then
    # If there are, use the session.
    tmux attach-session || exit $?
    exit 0
  else
    # If there isn't, create one.
    tmux || exit $?
    exit 0
  fi
fi
