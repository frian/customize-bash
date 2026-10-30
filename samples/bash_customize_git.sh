# shellcheck shell=bash
# -- optional Git aliases
alias gita='git add .'
alias gitc='gitCommit'
alias gitd='git diff'
alias giti='git init'
alias gitl='git log --decorate --all --oneline --graph'
alias gitp='git push'
alias gits='git status'

gitCommit() {
    if (( $# == 0 )); then
        printf 'Usage: gitc COMMIT MESSAGE\n' >&2
        return 2
    fi
    git commit -m "$*"
}
