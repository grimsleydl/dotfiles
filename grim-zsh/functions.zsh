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
