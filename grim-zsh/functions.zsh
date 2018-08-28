auth() {
    ~/bin/authnet.sh -d "$@" -l -u davi2570 -v
}
sanic() {
    echo "
                 ▄▄▄▄▄
        ▀▀▀██████▄▄▄   
      ▄▄▄▄▄  █████████▄
     ▀▀▀▀█████▌ ▀▐▄ ▀▐█
   ▀▀█████▄▄ ▀██████▄██
   ▀▄▄▄▄▄  ▀▀█▄▀█════█▀
        ▀▀▀▄  ▀▀███ ▀       ▄▄
     ▄███▀▀██▄████████▄ ▄▀▀▀▀▀▀█▌
   ██▀▄▄▄██▀▄███▀ ▀▀████      ▄██
▄▀▀▀▄██▄▀▀▌████▒▒▒▒▒▒███     ▌▄▄▀
▌    ▐▀████▐███▒▒▒▒▒▐██▌
▀▄▄▄▄▀   ▀▀████▒▒▒▒▄██▀
          ▀▀█████████▀
        ▄▄██▀██████▀█
      ▄██▀     ▀▀▀  █
     ▄█             ▐▌
 ▄▄▄▄█▌              ▀█▄▄▄▄▀▀▄
▌     ▐                ▀▀▄▄▄▀
 ▀▀▄▄▀
"}

curlt() {
    curl_format='
 time_namelookup:    %{time_namelookup}
 time_connect:       %{time_connect}
 time_appconnect:    %{time_appconnect}
 time_pretransfer:   %{time_pretransfer}
 time_redirect:      %{time_redirect}
 time_starttransfer: %{time_starttransfer}
 time_total:         %{time_total}'
curl -w "$curl_format" -o /dev/null -s "$@"
}

supernova() {
    pew in supernova supernova "$@"
}

anigrate() {
    pew in anigrate-MTFg9EvQ anigrate "$@"
}

trendy() {
    pew in trendy-gmsr9_zE ~/dev/trendy/trendy.py "$@"
}

ro() {
    ip ro | awk '
{   i = 1; h = " ip"
    hdr[h] = 1
    col[h,NR] = $i
    for(i=2;i<=NF;){
        if($i=="linkdown"){extra[NR] = $i; i++; continue}
        hdr[$i] = 1
        col[$i,NR] = $(i+1)
        i += 2
    }
}
END{     #PROCINFO[sorted_in] = "@ind_str_asc"
    n = asorti(hdr,x)
    for(i=1;i<=n;i++){ h = x[i]; max[h] = length(h) }
    for(j = 1;j<=NR;j++){
        for(i=1;i<=n;i++){
            h = x[i]
            l = length(col[h,j])
            if(l>max[h])max[h] = l
        }
    }
    for(i=1;i<=n;i++){ h = x[i]; printf "%-*s ",max[h],h }
    printf "\n"
    for(j = 1;j<=NR;j++){
        for(i=1;i<=n;i++){ h = x[i]; printf "%-*s ",max[h],col[h,j] }
        printf "%s\n",extra[j]
    }
}'
}

pyenv-exec() {
    $(pyenv shell "$1" && shift && pyenv exec "$@")
}
reboot-checks() {
    mkdir -p "$HOME/work/tickets/$1"
    # cd "$HOME/work/$1"
    ~/bin/reboot-checks "$1"
    mv ~/patchingscript.log "$HOME/work/$1/patchingscript-$(date -u +"%Y-%m-%dT%H:%M:%SZ").log"
}
pipsi-upgrade() {
    pipsi upgrade pipsi
    for package in $(pipsi list | sed -ne 's/^.*Package "\(.*\)".*/\1/p' | grep -v pipsi); do
        echo pipsi upgrade "$package"
        pipsi upgrade "$package"
    done
    if [[ "$1" == "--all" ]]; then
        for venv in $PIPSI_HOME/*; do
            echo Upgrading pip in $venv
            . $venv/bin/activate && pip install --upgrade pip && deactivate
        done
    fi
}

fkill() {
    local pid
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

    if [ "x$pid" != "x" ]
    then
        echo $pid | xargs kill -${1:-9}
    fi
}

pingtil() {
    until ping -c1 "$1" &>/dev/null; do :; done
}

psg() {
    ps aux | { head -1; grep "$1"; }
}


zdiff() {
    diff <($1) <($2)
}

yacp() {
    yadm add . && yadm commit -m "$1" && yadm push
}

############################
# https://p.teknik.io/2349 #
############################
dot_progress() {
    # Fancy progress function from Landley's Aboriginal Linux.
    # Useful for long rm, tar and such.
    # Usage:
    #     rm -rfv /foo | dot_progress
    local i='0'
    local line=''z

    while read line; do
        i="$((i+1))"
        if [ "${i}" = '25' ]; then
            printf '.'
            i='0'
        fi
    done
    printf '\n'
}

 rmssay()
 {
     length=${#1}

     printf "┌─"; for ((c=1; c<=$length; c++)); do printf "─"; done; printf "─┐\n"
     printf "│ $1 │\n"
     printf "└─"; for ((c=1; c<=$length; c++)); do printf "─"; done; printf "─┘\n"
     printf "      \\ \n"
     printf "       \\ \n"
     printf "        \\ \n"
     printf "          @@@@@@ @
    @@@@     @@
    @@@@ =   =  @@
    @@@ @ _   _   @@
    @@@ @($)|($)  @@
    @@@@   ~ | ~   @@
    @@@ @  (o1o)    @@
    @@@    #######    @
    @@@   ##{+++}##   @@
    @@@@@ ## ##### ## @@@@
    @@@@@#############@@@@
    @@@@@@@###########@@@@@@
    @@@@@@@#############@@@@@
    @@@@@@@### ## ### ###@@@@
    @ @  @              @  @
    @                    @
"
 }
