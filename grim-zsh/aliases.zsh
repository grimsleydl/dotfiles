alias xx='patool extract'     #size,show type,human readable
alias killit='kill -9 %%'

if (( $+commands[exa] )) ; then
    alias ls=exa
    alias lss='exa -ghHl --git'
    alias la='exa -la'
fi
