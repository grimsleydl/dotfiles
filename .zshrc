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
# zplugin ice svn; zplugin snippet "PZT::modules/utility"
# zplugin snippet "PZT::modules/completion/init.zsh"
zplugin snippet "PZT::modules/fasd/init.zsh"
zplugin snippet "PZT::modules/editor/init.zsh"
zplugin light "djui/alias-tips"
export ENHANCD_COMMAND=ecd
zplugin load "b4b4r07/enhancd"
zplugin load "b4b4r07/ssh-keyreg"
# zplugin load "b4b4r07/auto-fu.zsh"
zplugin load "supercrabtree/k"
# zplugin load "psprint/zzcomplete"
# zplugin load "mollifier/anyframe"

zplugin snippet "OMZ::lib/completion.zsh"
zplugin snippet "OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh"
zplugin snippet "OMZ::plugins/common-aliases/common-aliases.plugin.zsh"
zplugin snippet "OMZ::plugins/cp/cp.plugin.zsh"
# zplugin snippet "OMZ::plugins/dotenv/dotenv.plugin.zsh"
zplugin snippet "OMZ::plugins/extract/extract.plugin.zsh"
zplugin snippet "OMZ::plugins/systemadmin/systemadmin.plugin.zsh"
zplugin snippet "OMZ::plugins/fancy-ctrl-z/fancy-ctrl-z.plugin.zsh"
zplugin snippet "OMZ::plugins/sudo/sudo.plugin.zsh"
# zplugin snippet "OMZ::plugins/globalias/globalias.plugin.zsh"
zplugin snippet "OMZ::plugins/npm/npm.plugin.zsh"
zplugin snippet "OMZ::plugins/perms/perms.plugin.zsh"
# zplugin load "mafredri/zsh-async"
# zplugin ice wait'!1'; zplugin load "sindresorhus/pure"
zplugin load "geometry-zsh/geometry"
zplugin load "desyncr/geometry-dir-info-prompt"
zplugin light "unixorn/warhol.plugin.zsh"

zplugin light zdharma/zui
zplugin ice wait'[[ -n ${ZLAST_COMMANDS[(r)cras*]} ]]'
zplugin light zdharma/zplugin-crasis

zplugin light "zsh-users/zsh-completions"

zplugin ice wait'1' atload'_zsh_autosuggest_start'; zplugin load "zsh-users/zsh-autosuggestions"
zplugin light "zsh-users/zsh-history-substring-search"
zplugin load "zsh-users/zaw"
zplugin load "ajsalminen/zaw-src-apt"
# zplugin snippet "PZT::modules/history-substring-search/init.zsh"
zplugin load "zdharma/history-search-multi-word"

zplugin load "robertzk/send.zsh"
zplugin light "peterhurford/git-it-on.zsh"
zplugin light "seletskiy/zsh-git-smart-commands"
# Binary release in archive, from Github-releases page; after automatic unpacking it provides command "fzf"
zplugin ice from"gh-r" as"command"; zplugin light junegunn/fzf-bin

# One other binary release, it needs renaming from `docker-compose-Linux-x86_64`.
# Used also `bpick' which selects Linux packages  in this case not needed, Zplugin
# automatically narrows down the releases by grepping uname etc.
# zplugin ice from"gh-r" bpick"*linux*" as"command" mv"docker* -> docker-compose"; zplugin load docker/compose

zplugin light "webyneter/docker-aliases"
zplugin light "asuran/zsh-docker-machine"
zplugin light "rawkode/zsh-docker-run"
# zplugin ice from"gh-r" bpick"*linux*amd64*" as"command"; zplugin load "tmrts/boilr"
zplugin ice atclone"dircolors -b LS_COLORS > c.zsh" atpull'%atclone' pick"c.zsh"; zplugin light trapd00r/LS_COLORS

# zplugin ice mv"autocompletion.zsh -> _tldr"; zplugin load "tldr-pages/tldr-node-client"

zplugin ice as"command" pick"bin/git-submodule-rewrite"; zplugin light "jeremysears/scripts"
zplugin ice as"command"; zplugin light "TheLocehiliosan/yadm"
zplugin ice as"command"; zplugin light "skx/sysadmin-util"
zplugin ice atclone"./install.py atpull./install.py"; zplugin light "pindexis/marker"
zplugin snippet "/home/$(whoami)/.local/share/marker/marker.sh"

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
zplugin load "psprint/zsh-editing-workbench"

zplugin load "GuilleDF/zsh-ubuntualiases"
zplugin ice pick"dotfiles/zsh/upr.zsh"; zplugin load "io-monad/dotfiles"
zpl ice pick"manydots-magic" wait'3'; zpl load "knu/zsh-manydots-magic"

for zlocal in ~/grim-zsh/**/*.zsh
do
    zplugin snippet -f "$zlocal"
done

# zplugin load "psprint/zsh-cmd-architect"

function zplugin_end(){
    zplugin cdreplay -q # -q is for quiet
    autoload -Uz _zplugin
    (( ${+_comps} )) && _comps[zplugin]=_zplugin
    zcompile ${ZDOTDIR:-$HOME}/.zplugin/bin/zplugin.zsh
}

zplugin load "zdharma/fast-syntax-highlighting"
#if whence -f zplugin; then zplugin_end; else zplug_end; fi
zplugin_end

if [ $(lsb_release -is) = "Ubuntu" ]; then
   sudo mount -a
fi
