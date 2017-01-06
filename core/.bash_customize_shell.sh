
# -- go to parent dir
alias b='cd ..'
alias b2='cd ../..'
alias b3='cd ../../..'
alias b5='cd ../../../..'
alias b5='cd ../../../../..'


# -- clear screen
alias c='clear'


# -- find in current with case-insensitive name
alias ffind="find . -iname "


# -- add colors to grep
alias grep='grep --color=auto'


# -- history
alias h='history'


# -- list jobs
alias j='jobs -l'

# -- list aliases
alias lal=listAliasCommand

# -- custom alias output
listAliasCommand () {
    alias | awk -v COLOR=${BYellow} -v NC=${NC} -F"='" '{ printf "%s %-12s %s %s\n", COLOR ,$1, NC, $2 }' | sed 's/ //' | sed 's/alias//g'  | sed 's/ //' | tr -d "'"
}


# -- add colors and directory grouping to ls
alias ls='ls --color=auto --group-directories-first'

# -- list hidden files and folders
alias l.='ls -d .*'

# -- long format
alias ll='ls -lh'

# -- list all minus . and ..
alias la='ls -A'


# -- add create parent to mkdir
alias mkdir='mkdir -pv'


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
