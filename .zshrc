if test -r ~/.profile; then . ~/.profile; fi
# function zzplugin(){
#     [[ -d ${ZDOTDIR:-$HOME}/.zplugin ]] || {
#         ZPLG_HOME="${ZDOTDIR:-$HOME}/.zplugin"

#         if ! test -d "$ZPLG_HOME"; then
#             mkdir "$ZPLG_HOME"
#             chmod g-rwX "$ZPLG_HOME"
#         fi

#         if test -d "$ZPLG_HOME/bin/.git"; then
#             cd "$ZPLG_HOME/bin"
#             git pull origin master
#         else
#             cd "$ZPLG_HOME"
#             git clone https://github.com/psprint/zplugin.git bin
#         fi
#     }
#     source ${ZDOTDIR:-$HOME}/.zplugin/bin/zplugin.zsh
# function zpload(){
#     zplugin load "$@"
# }
# function zpsnip(){
#     zplugin snippet "$@"
# }
# }
# zzplugin

source "$HOME/.zplugin/bin/zplugin.zsh"

zplugin load "RobSis/zsh-completion-generator"
autoload -Uz compinit && compinit -i
zplugin snippet "OMZ::lib/git.zsh"

# autoload -Uz _zplugin
# (( ${+_comps} )) && _comps[zplugin]=_zplugin
### Added by Zplugin's installer

zplugin snippet "PZT::modules/environment/init.zsh"
zplugin snippet "PZT::modules/history/init.zsh"
zplugin snippet "PZT::modules/directory/init.zsh"
# zplugin snippet "PZT::modules/completion/init.zsh"
zplugin snippet "PZT::modules/fasd/init.zsh"
zplugin snippet "PZT::modules/editor/init.zsh"
# zplugin ice svn; zplugin snippet "PZT::modules/utility"
zplugin load "djui/alias-tips"
export ENHANCD_COMMAND=ecd
zplugin load "b4b4r07/enhancd"
zplugin load "supercrabtree/k"
# zplugin load "psprint/zzcomplete"
# zplugin load "mollifier/anyframe"

zplugin snippet "OMZ::plugins/common-aliases/common-aliases.plugin.zsh"
zplugin snippet "OMZ::plugins/cp/cp.plugin.zsh"
zplugin snippet "OMZ::plugins/dotenv/dotenv.plugin.zsh"
zplugin snippet "OMZ::plugins/extract/extract.plugin.zsh"
zplugin snippet "OMZ::plugins/systemadmin/systemadmin.plugin.zsh"
zplugin snippet "OMZ::plugins/fancy-ctrl-z/fancy-ctrl-z.plugin.zsh"
zplugin snippet "OMZ::plugins/sudo/sudo.plugin.zsh"
# zplugin snippet "OMZ::plugins/globalias/globalias.plugin.zsh"
zplugin snippet "OMZ::plugins/npm/npm.plugin.zsh"
zplugin snippet "OMZ::plugins/perms/perms.plugin.zsh"

zplugin light zdharma/zui
zplugin light zdharma/zplugin-crasis

zplugin load "zsh-users/zsh-completions"
zplugin load "zsh-users/zsh-autosuggestions"
zplugin load "zsh-users/zsh-history-substring-search"
# zplugin snippet "PZT::modules/history-substring-search/init.zsh"
zplugin load "zdharma/history-search-multi-word"

zplugin load "robertzk/send.zsh"
zplugin load "peterhurford/git-it-on.zsh"

# Binary release in archive, from Github-releases page; after automatic unpacking it provides command "fzf"
zplugin ice from"gh-r" as"command"; zplugin load junegunn/fzf-bin

# One other binary release, it needs renaming from `docker-compose-Linux-x86_64`.
# Used also `bpick' which selects Linux packages  in this case not needed, Zplugin
# automatically narrows down the releases by grepping uname etc.
zplugin ice from"gh-r" bpick"*linux*" as"command" mv"docker* -> docker-compose"; zplugin load docker/compose

zplugin ice as"command"; zplugin load "TheLocehiliosan/yadm"
zplugin ice as"command"; zplugin load "skx/sysadmin-util"
zplugin ice atclone"./install.py atpull./install.py"; zplugin load "pindexis/marker"
zplugin snippet "/home/$(whoami)/.local/share/marker/marker.sh"
zplugin ice pick"shell/key-bindings.zsh"; zplugin load "junegunn/fzf"
zplugin ice pick"shell/completion.zsh"; zplugin load "junegunn/fzf"
export FZF_COMPLETION_TRIGGER=',,'

for zlocal (~/grim-zsh/**/*.zsh); zplugin snippet -f "$zlocal"

zplugin load "psprint/zsh-editing-workbench"
# zplugin load "psprint/zsh-cmd-architect"
zplugin load "zdharma/fast-syntax-highlighting"


function zplugin_end(){
    zplugin cdreplay -q # -q is for quiet
    autoload -Uz _zplugin
    (( ${+_comps} )) && _comps[zplugin]=_zplugin
    zcompile ${ZDOTDIR:-$HOME}/.zplugin/bin/zplugin.zsh
}

#if whence -f zplugin; then zplugin_end; else zplug_end; fi
zplugin_end
