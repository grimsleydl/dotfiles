alias _='sudo'
alias als='alias | grep -i --'

alias dfh='df -h'
alias Gi="| grep -i"

alias ka9='killall -9'
alias k9='kill -9'
alias killit='kill -9 %%'

alias logs="journalctl -f -u"

# if exa is installed
if (( $+commands[exa] )) ; then
    # alias ls=exa
    alias lss='exa -ghHl --git'
    alias la='exa -la'
    alias ll='exa -alF'
    alias lh='exa -alh'
fi

alias psa="ps aux"
alias psc='ps xawf -eo pid,user,cgroup,args'
alias psg="ps aux | grep"
alias rival='sudo rival'
alias scu='systemctl --user'
alias xx='patool extract'     #size,show type,human readable

alias Y="| yank"
alias yaa="yadm add"
alias yac="yadm commit"
alias ya="yadm commit -a -m"

# zypper
alias zyp='zypper'
unalias zse
zse() {
    zypper se -s "$1" | grep -v "| i586   |" # search, filter x86 pacages
}

# get keyboard devnode
alias getkeyboard="grep -E  'Handlers|EV=' /proc/bus/input/devices | grep -B1 'EV=120013' | grep -Eo 'event[0-9]+'"

