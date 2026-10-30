# -- navigation
alias b='cd ..'
alias b2='cd ../..'
alias b3='cd ../../..'
alias b4='cd ../../../..'
alias b5='cd ../../../../..'

# -- common shell shortcuts
alias c='clear'
alias h='history'
alias j='jobs -l'
alias q='exit'
alias df='df -kTh'
alias du='du -h'
alias mkdir='mkdir -pv'
alias ping='ping -c 4'
alias wget='wget -c'
# Expand an alias after sudo, e.g. sudo ll (when sudo is installed).
alias sudo='sudo '

# -- grep: keep legacy short names without using deprecated egrep/fgrep binaries
alias grep='grep --color=auto'
alias egrep='grep -E --color=auto'
alias fgrep='grep -F --color=auto'

# -- ls: automatically disable color in pipes and redirected output
alias ls='ls --color=auto --group-directories-first -h'
alias l.='ls -d .*'
alias ll='ls -lh'
alias lla='ls -lah'
alias la='ls -A'
alias lx='ll -XB'
alias lk='ll -Sr'
alias lt='ll -tr'

# -- list aliases using Bash's own quoting (no parsing of arbitrary values)
alias lal='alias -p'
listAliasCommand() {
    alias -p
}

# -- readable colon-delimited environment variables
path() {
    printf '%s\n' "${PATH//:/$'\n'}"
}

libpath() {
    [[ -n ${LD_LIBRARY_PATH:-} ]] || return 0
    printf '%s\n' "${LD_LIBRARY_PATH//:/$'\n'}"
}

# -- case-insensitive name search (pass glob characters as a quoted pattern)
nfind() {
    if (( $# != 1 )); then
        printf 'Usage: nfind NAME_PATTERN\n' >&2
        return 2
    fi
    find . -iname "$1"
}

# -- find processes by matching their full command line
psgrep() {
    if (( $# == 0 )); then
        printf 'Usage: psgrep SEARCH_TEXT\n' >&2
        return 2
    fi
    pgrep -afi -- "$*"
}

# -- get public IP over HTTPS; fail promptly if the network is unavailable
pubip() {
    curl --fail --silent --show-error --connect-timeout 3 --max-time 8 \
        https://api.ipify.org && printf '\n'
}

# -- show listening TCP/UDP ports (process details may require privileges)
alias ports='ss -tulnp'

# -- show the 20 largest entries under the current directory (can be slow)
alias dus='du -ah | sort -rh | head -20'

# -- time and date
alias nowt='date +"%T"'
alias nowd='date +"%d-%m-%Y"'
alias now='date +"%d-%m-%Y %T"'

# -- system monitors
alias wcpu='watch -n1 "grep MHz /proc/cpuinfo"'
alias wmem='watch -n1 free'
