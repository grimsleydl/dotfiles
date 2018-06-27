export EDITOR="emacsclient"
export ALTERNATIVE_EDITOR="vim"
export BROWSER="vivaldi"
export TERMINAL="urxvt-256color"

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
export PROJECT_HOME=$HOME/repos
if [ -n "$DISPLAY" ]; then
    xset b off
fi
