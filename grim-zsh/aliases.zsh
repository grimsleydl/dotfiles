unalias fd
# alias anigrate="pipenv run anigrate"
alias anigrate="pew in anigrate-MTFg9EvQ anigrate"

alias als='alias | grep -i --'

alias -- -='cd -'

alias _='sudo'

alias dfh='df -h'
alias dc-start="sudo docker-compose start"
alias dc-stop="sudo docker-compose stop"

alias eg='eg --squeeze'

alias -g Gi="| grep -i"

alias imount="mount | grep -E --color=never  '^(/|[[:alnum:]\.-]*:/)'"
alias imt="imount | column -t"
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
alias rival='sudo rival'
alias scu='systemctl --user'
alias xx='patool extract'     #size,show type,human readable

alias Y="| yank"
alias yaa="yadm add"
alias yac="yadm commit"
alias yaf="yadm fetch"
alias yap="yadm pull"
alias yaP="yadm push"
alias yas="yadm status"
alias yaca="yadm commit -a -m"

# zypper
alias zyp='zypper'
unalias zse
zse() {
    zypper se -s "$1" | grep -v "| i586   |" # search, filter x86 pacages
}

alias zinfo='zypper info'

# get keyboard devnode
alias getkeyboard="grep -E  'Handlers|EV=' /proc/bus/input/devices | grep -B1 'EV=120013' | grep -Eo 'event[0-9]+'"

alias weather="bash -c \"curl wttr.in/?0\""
