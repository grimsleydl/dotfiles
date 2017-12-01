alias _='sudo'
alias xx='patool extract'     #size,show type,human readable
alias killit='kill -9 %%'

alias als='alias | grep -i --'


# if exa is installed
if (( $+commands[exa] )) ; then
    alias ls=exa
    alias lss='exa -ghHl --git'
    alias la='exa -la'
    alias ll='exa -alF'
    alias lh='exa -alh'

fi
