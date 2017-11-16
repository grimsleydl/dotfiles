export FZF_DEFAULT_OPTS="--reverse --inline-info"
export FZF_DEFAULT_COMMAND="fd --type f --no-ignore --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--exit-0"
# export FZF_ALT_C_OPTS="--exit-0 --preview 'exa -TL1 {} | head -20'"
export FZF_ALT_C_OPTS="--exit-0"
export FZF_ALT_C_COMMAND="fd --type d --no-ignore --hidden --follow --exclude .git"


export SSH_KEY_PATH="~/.ssh/id_rsa"

export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).
