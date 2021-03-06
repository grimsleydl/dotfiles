source ~/.env
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>|'
# OpenSUSE stuff
export MAN_POSIXLY_CORRECT=1
export ALSA_CONFIG_PATH=/etc/alsa-pulse.conf

export PROMPT_GEOMETRY_EXEC_TIME="true"
export GEOMETRY_SYMBOL_RPROMPT="⊢"
export GEOMETRY_COLOR_VIRTUALENV=green

export FZF_DEFAULT_OPTS="--reverse --inline-info"
export FZF_DEFAULT_COMMAND="fd --type f --no-ignore --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--exit-0 --preview '(cat {} || exa -TL2 {}) 2> /dev/null | head -20'"
# export FZF_ALT_C_OPTS="--exit-0 --preview 'exa -TL1 {} | head -20'"
# export FZF_ALT_C_OPTS="--exit-0"
export FZF_ALT_C_OPTS="--exit-0 --preview '(cat {} || exa -TL2 {}) 2> /dev/null | head -20'"
export FZF_ALT_C_COMMAND="fd --type d --no-ignore --hidden --follow --exclude .git"
export ZSH_AUTOSUGGEST_USE_ASYNC="t"
export PURE_GIT_PULL=0

export SSH_KEY_PATH="~/.ssh/id_rsa"
export SSH_AUTH_SOCK DEFAULT="${XDG_RUNTIME_DIR}/ssh-agent.socket"

export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).

export PATH=$PATH:$HOME/bin/handy

export DOCKER_HOST=tcp://0.0.0.0:2375

autoload -Uz zmv
autoload -Uz zargs
