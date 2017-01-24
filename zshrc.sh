#!/usr/bin/env zsh

# locate the directory where itself resides.
MYCONFIG_DIR="$0:A:h"

# these functions are autoloaded at the first call.
autoload -Uz add-zsh-hook
autoload -Uz compinit
autoload -Uz predict-on
autoload -Uz history-search-end
autoload -Uz vcs_info
autoload -Uz zed

# Function to remove duplicates from $PATH.
remove_path_duplicates() {
  local PATHENTRIES NEWPATHENTRIES
  PATHENTRIES=("${(@s/:/)PATH}")
  NEWPATHENTRIES=()
  for p in "${PATHENTRIES[@]}"; do
    if [[ -z "${NEWPATHENTRIES[(r)$p]}" ]]; then
      NEWPATHENTRIES+="$p"
    fi
  done
  export PATH="${(j/:/)NEWPATHENTRIES}"
}

# Define normal shlvl + 1 in terms of $TMUX.
ZSH_SHLVL_THRESHOLD=2
if [[ -n ${TMUX-} ]]; then
  ZSH_SHLVL_THRESHOLD=3
fi

# Substitute variables in prompt strings.
setopt prompt_subst
# PS1: usual prompt string
# %B ... %b = boldface
# %F{color} ... %f = color
# ${ZSH_HOST_EMBLEM:green} = variable $ZSH_HOST_EMBLEM, defaults to green
# %n = username
# %M = full host name
# %~ = cwd, with home replaced with ~
# ${rbenv_info_msg_0_} = rbenv information provided by precmd_rbenv_info
# ${pyenv_info_msg_0_} = pyenv information provided by precmd_pyenv_info
# ${vcs_info_msg_0_} = VCS information provided by vcs_info
# %(1j. (%j jobs%).) = show the number of jobs when there are
# %(2L. (shlvl %L%).) = show the depth in nested zsh
# %(?.. (status %?%)) = show status number when nonzero
# %(?..%S%F{red}) ... %(?..%f%s) = make the prompt char red and standout when nonzero status
# %# = # for root and % for non-root
PS1="%B%F{${ZSH_HOST_EMBLEM-green}}%n@%M:%b%f%~\${rbenv_info_msg_0_}\${pyenv_info_msg_0_}\${vcs_info_msg_0_}%(1j. (%j jobs%).)%(${ZSH_SHLVL_THRESHOLD}L. (shlvl %L%).)%(?.. (status %?%))
%(?..%S%F{red})%#%(?..%f%s) "
# RPS1: right-hand-side counterpart of PS1
# %F{color} ... %f = color
# %D{...} = current date time
# %! = current history number
# %y = current tty filename with the prefix /dev/ omitted
RPS1='%F{red}%D{%Y/%m/%d %H:%M:%S}%f %!/%y'
# PS2: prompt in command continuation (like in `if' and `for')
# %_ = the status of the parser (e.g. if for if)
PS2='%_> '
# RPS2: right-hand-side counterpart of PS2
RPS2=''
# PS3: prompt in select statement
PS3='?# '
# PS4: prompt used when 'set -x' set in a script
# %N = the name of the script
# %i = the line number in the script
PS4='+%N:%i>'
# vcs_info formats: default format vcs_info
# %b = branch information
# %c = information about staged changes
# %u = information about unstaged changes
zstyle ':vcs_info:*' formats ' %F{green}%c%u[%b]%f'
# vcs_info actionformats: format used when some action is needed
# %a = action needed
zstyle ':vcs_info:*' actionformats ' %F{red}%c%u[%b|%a]%f'
# vcs_info check-for-changes: dig into repositories for changes (maybe it costs)
zstyle ':vcs_info:*' check-for-changes true
# vcs_info stagedstr: format for staged changes
zstyle ':vcs_info:*' stagedstr '%F{yellow}!'
# vcs_info unstagedstr: format for unstaged changes
zstyle ':vcs_info:*' unstagedstr '%F{red}+'
if [[ $TERM = dumb ]]; then
  # Use simplified version in dumb terminal.
  PS1="%n@%M:%~\${rbenv_info_msg_0_}\${pyenv_info_msg_0_}\${vcs_info_msg_0_}%(1j. (%j jobs%).)%(${ZSH_SHLVL_THRESHOLD}L. (shlvl %L%).)%(?.. (status %?%))
%(?..[!])%# "
  RPS1=''
  PS2='%_> '
  RPS2=''
  PS3='?# '
  PS4='+%N:%i>'
  zstyle ':vcs_info:*' formats ' %c%u[%b]'
  zstyle ':vcs_info:*' actionformats ' %c%u[%b|%a]'
  zstyle ':vcs_info:*' check-for-changes true
  zstyle ':vcs_info:*' stagedstr '!'
  zstyle ':vcs_info:*' unstagedstr '+'
elif [[ -n "${MC_SID-}" ]]; then
  # Use one-line version in midnight commander.
  PS1='%~:%(?..[!])%# '
  RPS1=''
  PS2='%_> '
  RPS2=''
  PS3='?# '
  PS4='+%N:%i>'
  zstyle ':vcs_info:*' check-for-changes false
fi

# register precmd to show VCS information on the prompt
precmd_vcs_info() {
  vcs_info
}
add-zsh-hook precmd precmd_vcs_info

# register precmd to show pyenv information on the prompt.
precmd_pyenv_info() {
  if type pyenv >/dev/null; then
    if [[ $(pyenv version-origin) = $HOME/.pyenv/version ]]; then
      pyenv_info_msg_0_=""
    else
      pyenv_info_msg_0_=" (py:$(pyenv version-name))"
    fi
  fi
}
add-zsh-hook precmd precmd_pyenv_info
# ...and disable the similar functionality.
export PYENV_VIRTUALENV_DISABLE_PROMPT="disable"

# register precmd to show rbenv information on the prompt.
precmd_rbenv_info() {
  if type rbenv >/dev/null; then
    if [[ $(rbenv version-origin) = $HOME/.rbenv/version ]]; then
      rbenv_info_msg_0_=""
    else
      rbenv_info_msg_0_=" (rb:$(rbenv version-name))"
    fi
  fi
}
add-zsh-hook precmd precmd_rbenv_info

# Enable zsh-completions.
fpath=("$MYCONFIG_DIR/zsh-completions/src" $fpath)

# Initialize completion.
if [[ -n ${ZSH_NO_COMPAUDIT-} ]]; then
  # if $ZSH_NO_COMPAUDIT is specified, skip compaudit (-u).
  compinit -u
else
  # use zstat to retrieve the file owner of a file.
  zmodload -F zsh/stat b:zstat
  if [[ $(zstat +uid "$MYCONFIG_DIR/zshrc.sh") = $UID ]]; then
    # if owner(zshrc.sh) == uid, do compaudit.
    compinit
  else
    # if not, skip compaudit.
    compinit -u
  fi
fi

# define widgets which invoke the function 'history-search-end'.
# These are similar to history-beginning-search-{back,for}ward, but they move the cursor to the end of the line.
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

# Vim-like keybind
bindkey -v

# See http://invisible-island.net/xterm/ctlseqs/ctlseqs.html for xterm escape sequences.
# SS3 H = Home
bindkey "^[OH" beginning-of-line
# CSI 1 ~ = Home
bindkey "^[[1~" beginning-of-line
# CSI 1 5 D = Ctrl+Left
bindkey "^[[1;5D" beginning-of-line
# SS3 F = End
bindkey "^[OF" end-of-line
# CSI 4 ~ = End
bindkey "^[[4~" end-of-line
# CSI 1 5 C = Ctrl+Right
bindkey "^[[1;5C" end-of-line
# Just Ctrl-P
bindkey "^P" history-beginning-search-backward-end
# CSI 5 ~ = PageUp
bindkey "^[[5~" history-beginning-search-backward-end
# CSI 1 5 A = Ctrl+Up
bindkey "^[[1;5A" history-beginning-search-backward-end
# Just Ctrl-N
bindkey "^N" history-beginning-search-forward-end
# CSI 6 ~ = PageDown
bindkey "^[[6~" history-beginning-search-forward-end
# CSI 1 5 B = Ctrl+Down
bindkey "^[[1;5B" history-beginning-search-forward-end

# Redefine some inconvenient vi keybinds
# vicmd ^H := backward-char (previous: vi-backward-char)
bindkey -a "^H" backward-char
# vicmd h := backward-char (previous: vi-backward-char)
bindkey -a "h" backward-char
# vicmd ^? := backward-char (previous: vi-backward-char)
bindkey -a "^?" backward-char
# viins CSI D = Left := backward-char (previous: vi-backward-char)
bindkey -v "^[[D" backward-char
# viins ^H = backspace := backward-delete-char (previous: vi-backward-delete-char)
bindkey -v "^H" backward-delete-char
# viins ^? = backspace := backward-delete-char (previous: vi-backward-delete-char)
bindkey -v "^?" backward-delete-char
# viins ^W := backward-kill-word (previous: vi-backward-kill-word)
bindkey -v "^W" backward-kill-word

case "${TERM}" in
  kterm*|xterm*|rxvt*|cygwin*|screen*|tmux*)
    precmd_terminal_title() {
      # %n = username
      # %m = host name
      # %3~ = cwd, with home replaced with ~, rightmost 3 elements
      # %# = # for root and % for non-root
      if [[ -n ${ZSH_LOCAL_TITLE-} ]]; then
        print -nP "\e]0;%3~%#\a"
      else
        print -nP "\e]0;%m:%3~%#\a"
      fi
    }
    add-zsh-hook precmd precmd_terminal_title
    preexec_terminal_title() {
      # $1 = command line executed (including arguments)
      # %m = host name
      if [[ -n ${ZSH_LOCAL_TITLE-} ]]; then
        print -nP "\e]0;\$1\a"
      else
        print -nP "\e]0;\$1 (@%m)\a"
      fi
    }
    add-zsh-hook preexec preexec_terminal_title
    ;;
esac

# Enable comments in interactive shell.
setopt interactive_comments
# Enable negation (^x), subtraction (x^y), repetition (x#, x##) in file expantion.
setopt extended_glob
# Record timestamp in zsh_history.
setopt extended_history
# Do not record space-prefixed commands into zsh_history.
setopt hist_ignore_space
# Squash consecutive repeated commands in zsh_history.
setopt hist_ignore_dups
# Do not record history command itself.
setopt hist_no_store
# Share history among instances.
setopt share_history
# Show completion with varying widths.
setopt list_packed
# Do not beep
unsetopt beep

# ::aliases
if [[ $TERM = dumb ]]; then
  # Indicate filetypes using symbols.
  alias ls="ls -h -F"
  zstyle ':completion:*' list-colors ''
else
  if ls --color -d / >/dev/null 2>&1; then
    # Indicate filetypes using colors. (for GNU utils)
    eval "$(dircolors -b 2>/dev/null)"
    alias ls="ls -h --color=auto"
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
  elif ls -G -d / >/dev/null 2>&1; then
    # Indicate filetypes using colors. (for BSD utils)
    alias ls="ls -h -G"
    zstyle ':completion:*' list-colors ''
  else
    # Indicate filetypes using symbols.
    alias ls="ls -h -F"
    zstyle ':completion:*' list-colors ''
  fi
fi
# human-readable outputs for du and dh
alias du="du -h"
alias df="df -h"

# record history in ~/.zsh_history
HISTFILE=~/.zsh_history
# Number of history entries loaded into memory
HISTSIZE=1000
# Number of history entries recorded in ~/.zsh_history
SAVEHIST=10000000000

# set default editor
for edt in vim vim.tiny vi
do
    if type "$edt" >/dev/null; then
        export EDITOR="$edt"
        break
    fi
done

# Load "command-not-found" functionality, if it exists.
if [[ -f /etc/zsh_command_not_found ]]; then
  . /etc/zsh_command_not_found || true
fi

# Script to autogenerate LaTeX directory from template

beginprogress() {
  set -ue
  cp -r "$MYCONFIG_DIR/latex-templates/$1" "$2"
}

_beginprogress() {
  local templates

  templates=$(cd "$MYCONFIG_DIR/latex-templates"; ls)

  _arguments \
      ":Template name:_values template $templates" \
      ':Directory to create:_path_files -/'
}

compdef _beginprogress beginprogress
