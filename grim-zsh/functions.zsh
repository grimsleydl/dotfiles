# fkill - kill process
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
