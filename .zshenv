export EDITOR="emacsclient"
export ALTERNATIVE_EDITOR="vim"
export BROWSER="vivaldi"
export TERMINAL="urxvt-256color"
eval "$(pyenv init -)"

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
# Virtualenvwrapper things
# export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"
# export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/repos
if [ -n "$DISPLAY" ]; then
    xset b off
fi
