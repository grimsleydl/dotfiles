bindkey '^_' undo
# bindkey '^t' _marker_get
bindkey ';x' _marker_get
bindkey ';;' zaw
bindkey "^R" history-search-multi-word

zle -N beginning-of-somewhere beginning-or-end-of-somewhere
zle -N end-of-somewhere beginning-or-end-of-somewhere

if [[ -n "$key_info" ]]; then
    # Emacs
    bindkey -M emacs "$key_info[Control]P" history-substring-search-up
    bindkey -M emacs "$key_info[Control]N" history-substring-search-down

    # Vi
    bindkey -M vicmd "k" history-substring-search-up
    bindkey -M vicmd "j" history-substring-search-down

    # Emacs and Vi
    for keymap in 'emacs' 'viins'; do
        bindkey -M "$keymap" "$key_info[Up]" history-substring-search-up
        bindkey -M "$keymap" "$key_info[Down]" history-substring-search-down
    done

    unset keymap
fi
