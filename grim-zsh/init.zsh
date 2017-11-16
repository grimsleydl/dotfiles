export PATH="$HOME/.local/bin/:$PATH"


export GREP_COLOR='1;33'

# ENHANCD_COMMAND=ecd; export ENHANCD_COMMAND

unalias fd

setopt no_hist_verify
setopt menu_complete

unsetopt beep
_fzf_compgen_path() {
    fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
    fd --type d --hidden --follow --exclude ".git" . "$1"
}

# adds the arguments from the last commadn to the autocomplete list
# I wasn't able to get this to work standalone and still print out both regular
# completion plus the last args, but this works well enough.
_complete_plus_last_command_args() {
    last_command=$history[$[HISTCMD-1]]
    last_command_array=("${(s/ /)last_command}")
    _sep_parts last_command_array
    _complete
}


_force_rehash() {
    (( CURRENT == 1 )) && rehash
    return 1  # Because we didn't really complete anything
}

zstyle ':completion:::::' completer _force_rehash _complete_plus_last_command_args _approximate
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
# unset GREP_OPTIONS


# https://github.com/junegunn/fzf/wiki/examples
# ALT-I - Paste the selected entry from locate output into the command line
# fzf-locate-widget() {
#     local selected
#     if selected=$(locate / | fzf -q "$LBUFFER"); then
#         LBUFFER=$selected
#     fi
#     zle redisplay
# }
# zle     -N    fzf-locate-widget
# bindkey '\ei' fzf-locate-widget