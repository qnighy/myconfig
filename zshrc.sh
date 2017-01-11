#!/usr/bin/env zsh

# these functions are autoloaded at the first call.
autoload -Uz add-zsh-hook
autoload -Uz compinit
autoload -Uz predict-on
autoload -Uz history-search-end
autoload -Uz vcs_info
autoload -Uz zed

# Vim-like keybind
bindkey -v

# Substitute variables in prompt strings.
setopt prompt_subst
# PS1: usual prompt string
# %B ... %b = boldface
# %F{color} ... %f = color
# %n = username
# %M = full host name
# %~ = cwd, with home replaced with ~
# %(1j. (%j jobs%).) = show the number of jobs when there are
# %(2L. (shlvl %L%).) = show the depth in nested zsh
# %(?.. (status %?%)) = show status number when nonzero
# %(?..%S%F{red}) ... %(?..%f%s) = make the prompt char red and standout when nonzero status
# %# = # for root and % for non-root
PS1='%B%F{blue}%n@%M:%b%f%~${vcs_info_msg_0_}%(1j. (%j jobs%).)%(2L. (shlvl %L%).)%(?.. (status %?%))
%(?..%S%F{red})%#%(?..%f%s) '
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
  PS1='%n@%M:%~${vcs_info_msg_0_}%(1j. (%j jobs%).)%(2L. (shlvl %L%).)%(?.. (status %?%))
%(?..[!])%# '
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

# complement setting
compinit
# predict complement setting
# predict-on
# history search
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
# zed

# ::keybind
bindkey "^[OH" beginning-of-line
bindkey "^[[1;5D" beginning-of-line
bindkey "^[[1~" beginning-of-line
bindkey "^[OF" end-of-line
bindkey "^[[1;5C" end-of-line
bindkey "^[[4~" end-of-line
bindkey "^P" history-beginning-search-backward-end
bindkey "^[[5~" history-beginning-search-backward-end
bindkey "^[[1;5A" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
bindkey "^[[6~" history-beginning-search-forward-end
bindkey "^[[1;5B" history-beginning-search-forward-end

# ::terminal title
case "${TERM}" in
kterm*|xterm|rxvt|cygwin)
    precmd_terminal_title() {
        #echo -ne "\e]0;${USER}@${HOST%%.*}:${PWD}\a"
        wdhome=$(pwd|awk "{sub(\"^${HOME}\",\"~\",\$1);print \$1}")
        echo -ne "\e]0;Z>${wdhome}(${USER}@${HOST%%.*})\a"
    }
    add-zsh-hook precmd precmd_terminal_title
    ;;
esac

# ::set options
setopt extended_glob
setopt extended_history
setopt hist_ignore_space
setopt hist_ignore_dups
setopt hist_no_store
setopt share_history
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
unsetopt correct
setopt list_packed
setopt nolistbeep
setopt nobeep
setopt multios

# ::aliases
alias RELOAD="source ~/.zshrc"
alias where="whence -ca"
if [ "$TERM" = "dumb" ]; then
  alias ls="ls -F"
else
  eval "`dircolors -b`"
  alias ls="ls -h --color=auto"
  alias sudols="sudo ls -h --color=auto"
  alias sudoldir="sudo ls --color=auto -aplh"
  alias la="ls -ha"
  alias lf="ls -hF"
  alias ll="ls -hl"
  alias ldir="ls -aplh --color=auto"
fi
alias du="du -h"
alias df="LANG=C df -h"
alias su="su -l"
alias cd..="cd .."

# ::history setting
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=10000000000

zstyle ':completion:*' list-colors ''

# ::set default editor
for edt in vim vi
do
    if which $edt 1>/dev/null 2>/dev/null
    then
        export EDITOR=$edt
        break
    fi
done

if [ -d ~/.zsh_fun ]
then
    function rcomp() {
        local f
        f=(~/.zsh_fun/*(:t))
        unfunction $f:t 2> /dev/null
        autoload -U $f:t
    }

    fpath=(~/.zsh_fun $fpath)
    autoload -U ~/.zsh_fun/*(:t)
fi

if [[ -f /etc/zsh_command_not_found ]]; then
  . /etc/zsh_command_not_found || true
fi
