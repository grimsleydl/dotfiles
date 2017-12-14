zdiff() {
    diff <($1) <($2)
}

yacp() {
    yadm add . && yadm commit -m "$1" && yadm push
}
