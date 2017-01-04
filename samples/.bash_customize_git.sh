alias gita='git add .'
alias gitc=gitCommit
alias gitd='git diff'
alias giti='git init'
alias gitl='git log --decorate --all --oneline --graph'
alias gitp='git push'
alias gits='git status'

gitCommit() {
    git commit -m "$@"
}
