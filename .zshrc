if test -r ~/.profile; then . ~/.profile; fi

source "$HOME/.zplugin/bin/zplugin.zsh"

##########
# PROMPT #
##########
export GEOMETRY_PROMPT_PLUGINS=(virtualenv exec_time jobs git)
zplugin load "geometry-zsh/geometry"
# zplugin load "desyncr/geometry-dir-info-prompt"

zplugin load "RobSis/zsh-completion-generator"

##########
# PREZTO #
##########
zplugin snippet "PZT::modules/environment/init.zsh"
zplugin snippet "PZT::modules/history/init.zsh"
zplugin snippet "PZT::modules/directory/init.zsh"
# zplugin ice svn; zplugin snippet "PZT::modules/utility"
# zplugin snippet "PZT::modules/completion/init.zsh"
# zplugin snippet "PZT::modules/fasd/init.zsh"
zplugin snippet "PZT::modules/editor/init.zsh"
# zplugin ice svn; zplugin snippet PZT::modules/python
# zplugin snippet "PZT::modules/python/init.zsh"

#############
# OH-MY-ZSH #
#############
# zplugin snippet "OMZ::lib/git.zsh"
zplugin snippet "OMZ::lib/completion.zsh"
# zplugin snippet "OMZ::lib/correction.zsh"
zplugin snippet "OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh"
zplugin snippet "OMZ::plugins/common-aliases/common-aliases.plugin.zsh"
zplugin snippet "OMZ::plugins/cp/cp.plugin.zsh"
zplugin snippet "OMZ::plugins/docker-compose/docker-compose.plugin.zsh"
# zplugin snippet "OMZ::plugins/dotenv/dotenv.plugin.zsh"
zplugin snippet "OMZ::plugins/extract/extract.plugin.zsh"
zplugin snippet "OMZ::plugins/systemadmin/systemadmin.plugin.zsh"
zplugin snippet "OMZ::plugins/fancy-ctrl-z/fancy-ctrl-z.plugin.zsh"
zplugin snippet "OMZ::plugins/sudo/sudo.plugin.zsh"
# zplugin snippet "OMZ::plugins/globalias/globalias.plugin.zsh"
zplugin snippet "OMZ::plugins/npm/npm.plugin.zsh"
zplugin snippet "OMZ::plugins/perms/perms.plugin.zsh"
zplugin snippet "OMZ::plugins/systemd/systemd.plugin.zsh"
# zplugin snippet "OMZ::plugins/wd/wd.plugin.zsh"
zplugin snippet "OMZ::plugins/ubuntu/ubuntu.plugin.zsh"
zplugin snippet "OMZ::plugins/suse/suse.plugin.zsh"
zplugin snippet "OMZ::plugins/yum/yum.plugin.zsh"

zplugin load "cswl/zsh-rbenv"

#############
# ZSH-USERS #
#############
zplugin light "zsh-users/zsh-completions"
# zplugin ice wait'1' atload'_zsh_autosuggest_start';
zplugin load "zsh-users/zsh-autosuggestions"
zplugin light "zsh-users/zsh-history-substring-search"
zplugin load "zsh-users/zaw"
# zplugin load "ajsalminen/zaw-src-apt"

###########
# ZDHARMA #
###########
zplugin ice wait'[[ -n ${ZLAST_COMMANDS[(r)cras*]} ]]'; zplugin light zdharma/zplugin-crasis
zplugin light zdharma/zui
zplugin load "zdharma/history-search-multi-word"
zstyle ":plugin:history-search-multi-word" clear-on-cancel "yes"

zplugin load "psprint/zsh-editing-workbench"
zplugin load "psprint/zsh-navigation-tools"
# zplugin load "psprint/zzcomplete"

########
# MISC #
########
export ENHANCD_COMMAND=ecd
zplugin load "b4b4r07/enhancd"
zplugin load "b4b4r07/ssh-keyreg"
# zplugin load "b4b4r07/auto-fu.zsh"
zplugin load "supercrabtree/k"
# zplugin load "mollifier/anyframe"

zplugin ice as"command" pick"fasd"; zplugin light "whjvenyl/fasd"
zplugin light "unixorn/warhol.plugin.zsh"
zplugin ice atclone"dircolors -b LS_COLORS > c.zsh" atpull'%atclone' pick"c.zsh"; zplugin light trapd00r/LS_COLORS

# zplugin load "robertzk/send.zsh"
zplugin light "peterhurford/git-it-on.zsh"
zplugin light "seletskiy/zsh-git-smart-commands"
# Binary release in archive, from Github-releases page; after automatic unpacking it provides command "fzf"
zplugin ice from"gh-r" as"command"; zplugin light junegunn/fzf-bin

# zplugin ice from"gh-r" bpick"*linux*amd64*" as"command"; zplugin load "tmrts/boilr"
# zplugin ice from"gh-r" bpick"*linux*" as"command" mv"docker* -> docker-compose"; zplugin load docker/compose
zplugin light "webyneter/docker-aliases"
zplugin light "asuran/zsh-docker-machine"
zplugin light "rawkode/zsh-docker-run"

# zplugin ice mv"autocompletion.zsh -> _tldr"; zplugin load "tldr-pages/tldr-node-client"
zplugin ice as"command" pick"tldr"; zplugin light "pepa65/tldr-bash-client"

zplugin ice atclone"./install.py atpull./install.py"; zplugin light "pindexis/marker"
zplugin snippet "/home/$(whoami)/.local/share/marker/marker.sh"

############
# COMMANDS #
############
zplugin ice as"command" pick"yank" make; zplugin light mptre/yank
zplugin ice as"command" pick"bin/git-submodule-rewrite"; zplugin light "jeremysears/scripts"
zplugin ice as"command"; zplugin light "TheLocehiliosan/yadm"
zplugin ice as"command"; zplugin light "skx/sysadmin-util"
zplugin ice as"command" pick"bin/tat"; zplugin light "thoughtbot/dotfiles"

zplugin ice pick"shell/key-bindings.zsh"; zplugin light "junegunn/fzf"
zplugin ice pick"shell/completion.zsh"; zplugin light "junegunn/fzf"
export FZF_COMPLETION_TRIGGER=',,'
zplugin load "ytet5uy4/fzf-widgets"
zplugin load "wfxr/forgit"
zplugin ice as"command"; zplugin light "DanielFGray/fzf-scripts"
export FZF_MARKER_CONF_DIR=$HOME/.zplugin/plugins/pindexis---marker/tldr
# export FZF_MARKER_COMMAND_COLOR='\x1b[38;5;255m'
# export FZF_MARKER_COMMENT_COLOR='\x1b[38;5;8m'
export FZF_MARKER_MAIN_KEY='\C-@'
export FZF_MARKER_PLACEHOLDER_KEY='\C-v'
zplugin load "liangguohuan/fzf-marker"
zplugin ice as"command" pick"fpp"; zplugin light "facebook/PathPicker"

# zplugin load "changyuheng/zsh-interactive-cd"

zplugin load "GuilleDF/zsh-ubuntualiases"
zplugin ice pick"dotfiles/zsh/upr.zsh"; zplugin load "io-monad/dotfiles"
zpl ice pick"manydots-magic" wait'3'; zpl load "knu/zsh-manydots-magic"

# zplugin light "djui/alias-tips"
zplugin light "MichaelAquilina/zsh-you-should-use"

for zlocal in ~/grim-zsh/**/*.zsh
do
    zplugin snippet -f "$zlocal"
done

function zplugin_end(){
    autoload -Uz compinit && compinit -i
    zplugin cdreplay -q # -q is for quiet
    # autoload -Uz _zplugin
    # (( ${+_comps} )) && _comps[zplugin]=_zplugin
    zcompile ${ZDOTDIR:-$HOME}/.zplugin/bin/zplugin.zsh
}

zplugin load "zdharma/fast-syntax-highlighting"
#if whence -f zplugin; then zplugin_end; else zplug_end; fi
zplugin_end

if [ $(lsb_release -is) = "Ubuntu" ]; then
   sudo mount -a
fi

if [[ -z "$TMUX" ]] && [ "$SSH_CONNECTION" != "" ]; then
    tmux attach-session -t "$USER" || tmux new-session -s "$USER"
fi
AUTOSUGGESTION_HIGHLIGHT_COLOR="fg=8"

# The following lines were added by compinstall

# zstyle ':completion:*' completer _expand _complete _ignored _match _correct _approximate
# zstyle ':completion:*' expand prefix
# zstyle ':completion:*' group-name ''
# zstyle ':completion:*' ignore-parents parent pwd directory
# zstyle ':completion:*' insert-unambiguous true
# zstyle ':completion:*' max-errors 1
# zstyle ':completion:*' menu select=1
# zstyle ':completion:*' original true
# zstyle ':completion:*' preserve-prefix '//[^/]##/'
# zstyle ':completion:*' prompt '%F{green}-- %d (errors: %e) --%f'
# zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
# zstyle :compinstall filename '/home/gromzly/.zshrc'

# autoload -Uz compinit
# compinit
# End of lines added by compinstall
eval "$(pyenv init -)"
pyenv virtualenvwrapper_lazy
# source .pyenv/shims/virtualenvwrapper.sh
