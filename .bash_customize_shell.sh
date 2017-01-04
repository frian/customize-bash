alias aaaaaaaaaaaaaaaaaaaaa=cd

# -- back : go to parent dir
alias b='cd ..'
alias b2='cd ../..'
alias b3='cd ../../..'


# -- clear : clear screen
alias c='clear'


# -- fast find : find in current with case-insensitive name
alias ffind="find . -iname "


# -- color output
alias grep='grep --color=auto'


# -- history
alias h='history'


# -- jobs
alias j='jobs -l'


# -- list hidden files and folders
alias l.='ls -d .*'
# -- long format
alias ll='ls -l'
# -- list all minus . and ..
alias la='ls -A'

alias ls='ls --color=auto'


# -- create parent div
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


# -- ping 4 times
alias ping='ping -c 4'


# -- quit : exit
alias q='exit'

if [[ ! ":$PATH:" == *":$HOME/scripts:"* ]]; then
    export PATH=$PATH:$HOME/scripts
fi
