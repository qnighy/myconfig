#::::zsh setting file::::
#I think it would not work well in zsh version 4.3.2


# ::set key bind
bindkey -v

# ::prompt setting
case "${TERM}" in
  dumb)
    PROMPT='%n@%m:%~
%(?..[!])%# '
    PROMPT2='%_>%(?..[!])%# '
    PROMPT3='?#'
    PROMPT4='+%N:%i>'
    ;;
  *)
    PROMPT='%B%F{blue}%n@%m:%b%f%~
%(?.%f.%S%F{red})%#%f%s '
    PROMPT2='%_>%(?.%f.%S%F{red})%#%f%s '
    PROMPT3='?#'
    PROMPT4='+%N:%i>'
    RPROMPT='%F{red}%D{%Y/%m/%d %H:%M:%S}%f %!/%y'
    #RPROMPT2='%F{red}%D{%Y/%m/%d %H:%M:%S}%f %!/%y'
    ;;
esac

# ::autoload
# complement setting
autoload -U compinit;compinit
# predict complement setting
#autoload -U predict-on;predict-on
# history search
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
# zed
autoload zed

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
    precmd() {
        #echo -ne "\e]0;${USER}@${HOST%%.*}:${PWD}\a"
        wdhome=$(pwd|awk "{sub(\"^${HOME}\",\"~\",\$1);print \$1}")
        echo -ne "\e]0;Z>${wdhome}(${USER}@${HOST%%.*})\a"
    }
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
alias j="jobs -l"
alias gp="ps ax|grep"
alias :q="exit"
alias :q!="exit"
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
