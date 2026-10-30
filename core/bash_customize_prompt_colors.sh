#
# -- set prompt color ---------------------------------------------------------
#
#    local:  blue
#    ssh:    green
#    root:   red
#
# based on http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x865.html
#

# -- detect SSH sessions without `who` or other external commands
if [[ -n ${SSH_CONNECTION:-} || -n ${SSH_CLIENT:-} || -n ${SSH_TTY:-} ]]; then
    CONN=ssh
else
    CONN=lcl
fi

# -- root takes priority over the connection type
if (( EUID == 0 )); then
    USR=priv
else
    USR=nopriv
fi


# -- set colors
if [ $USR = priv ] ; then
    COLOR=$ROOT_COLOR
    DARK_COLOR=$ROOT_DARK_COLOR
    BOLD_COLOR=$ROOT_BOLD_COLOR
elif [ $CONN = lcl -a $USR = nopriv ] ; then
    COLOR=$LOCAL_COLOR
    DARK_COLOR=$LOCAL_DARK_COLOR
    BOLD_COLOR=$LOCAL_BOLD_COLOR
elif [ $CONN = ssh -a $USR = nopriv ] ; then
    COLOR=$SSH_COLOR
    DARK_COLOR=$SSH_DARK_COLOR
    BOLD_COLOR=$SSH_BOLD_COLOR
fi

# -- set prompt
PS1="${debian_chroot:+($debian_chroot)}\[$BOLD_COLOR\]$PROMPT_USER\[$NC\]\[$DARK_COLOR\]@\[$NC\]\[$BOLD_COLOR\]$PROMPT_HOST\[$NC\]\[$DARK_COLOR\]:\[$COLOR\]\w\[$DARK_COLOR\]\$ \[\033[00m\]"


# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}$PROMPT_USER@$PROMPT_HOST: \w\a\]$PS1"
    ;;
*)
    ;;
esac


# -- export prompt
export PS1
