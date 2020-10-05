
# -- go to parent dir
alias b='cd ..'
alias b2='cd ../..'
alias b3='cd ../../..'
alias b4='cd ../../../..'
alias b5='cd ../../../../..'


# -- clear screen
alias c='clear'


# -- add better output
alias df='df -kTh'


# -- add better output
alias du='du -h'


#
# -- add colors to greps
#

# -- add colors to egrep
alias egrep='egrep --color=always'

# -- add colors to grep
alias grep='grep --color=always'

# -- add colors to fgrep
alias fgrep='fgrep --color=always'


# -- history
alias h='history'


# -- list jobs
alias j='jobs -l'


# -- list aliases
alias lal=listAliasCommand

# -- show lib path in a readable format
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'

# -- custom alias output
listAliasCommand () {
    alias | awk -v COLOR=${BYellow} -v NC=${NC} -F"='" '{ printf "%s %-12s %s %s\n", COLOR ,$1, NC, $2 }' | sed 's/ //' | sed 's/alias//g'  | sed 's/ //' | tr -d "'"
}


#
# -- ls aliases
#

# -- add colors, directory grouping and human-readable sizes to ls
alias ls='ls --color=always --group-directories-first -h'

# -- list hidden files and folders
alias l.='ls -d .*'

# -- long format
alias ll='ls -l'

# -- list all minus . and ..
alias la='ls -A'

# -- sort by extension.
alias lx='ll -XB'

#  Sort by size, biggest last.
alias lk='ll -Sr'

#  Sort by date, most recent last.
alias lt='ll -tr'


# -- add create parent to mkdir
alias mkdir='mkdir -pv'


# -- find in current dir with case-insensitive name
alias nfind="find . -iname "


# -- show path in a readable format
alias path='echo -e ${PATH//:/\\n}'


# -- grep in processes
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"


# -- get public ip
alias pubip="curl http://ipecho.net/plain; echo"


# -- show time
alias nowt='date +"%T"'

# -- show date
alias nowd='date +"%d-%m-%Y"'

# -- show date and time
alias now='date +"%d-%m-%Y %T"'


# -- show open ports
alias ports='netstat -tulanp'


# -- add 4 requests limit to ping
alias ping='ping -c 4'


# -- quit
alias q='exit'


# -- enable aliases in sudo
alias sudo='sudo '


# -- watch cpu frequency
alias wcpu='watch -n1 "cat /proc/cpuinfo | grep MHz"'

# -- watch memory usage
alias wmem='watch -n1 free'


# -- add resume to wget
alias wget='wget -c'
