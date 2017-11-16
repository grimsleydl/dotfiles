export FZF_DEFAULT_OPTS="--reverse --inline-info --preview 'file {}'"
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--select-1 --exit-0"
export FZF_ALT_C_OPTS="--select-1 --exit-0 --preview 'exa -TL2 {} | head -20'"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"


export SSH_KEY_PATH="~/.ssh/id_rsa"
