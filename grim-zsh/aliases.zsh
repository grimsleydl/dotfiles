alias _='sudo'
alias xx='patool extract'     #size,show type,human readable
alias killit='kill -9 %%'

alias als='alias | grep -i --'
alias logs="journalctl -f -u"

# zypper
alias zyp='zypper'
unalias zse
zse() {
    zypper se -s "$1" | grep -v "| i586   |" # search, filter x86 pacages
}

alias Gi="| grep -i"
alias psa="ps aux"
alias psg="ps aux | grep"

alias Y="| yank"

alias ka9='killall -9'
alias k9='kill -9'

alias scu='systemctl --user'

alias rival='sudo rival'
# if exa is installed
if (( $+commands[exa] )) ; then
    # alias ls=exa
    alias lss='exa -ghHl --git'
    alias la='exa -la'
    alias ll='exa -alF'
    alias lh='exa -alh'

fi

# get keyboard devnode
alias getkeyboard="grep -E  'Handlers|EV=' /proc/bus/input/devices | grep -B1 'EV=120013' | grep -Eo 'event[0-9]+'"

