#
# -- set prompt color ---------------------------------------------------------
#
#    local:  blue
#    ssh:    green
#    telnet: purple
#    root:   red
#
# based on http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x865.html
#

# -- get tty user
THIS_TTY=`ps aux | grep $$ | grep bash | awk '{ print $7 }'`

SESS_SRC=`who | grep $THIS_TTY | awk '{ print $1 }'`

# -- check if ssh
SSH_FLAG=0

SSH_IP=`echo $SSH_CLIENT | awk '{ print $1 }'`

if [ $SSH_IP ] ; then
  SSH_FLAG=1
fi

SSH2_IP=`echo $SSH2_CLIENT | awk '{ print $1 }'`

if [ $SSH2_IP ] ; then
  SSH_FLAG=1
fi

# -- set connection type
if [ $SSH_FLAG -eq 1 ] ; then
  CONN=ssh
elif [ -z $SESS_SRC ] ; then
  CONN=lcl
elif [ $SESS_SRC = "(:0.0)" -o $SESS_SRC = "" ] ; then
  CONN=lcl
else
  CONN=tel
fi

# Okay...Now who we be?
if [ `/usr/bin/whoami` = "root" ] ; then
  USR=priv
else
  USR=nopriv
fi

# -- define colors
LOCAL_COLOR=${Cyan}
LOCAL_DARK_COLOR=${DCyan}
LOCAL_BOLD_COLOR=${BCyan}

SSH_COLOR=${Green}
SSH_DARK_COLOR=${DGreen}
SSH_BOLD_COLOR=${BGreen}

TELNET_COLOR=${Purple}
TELNET_DARK_COLOR=${DPurple}
TELNET_BOLD_COLOR=${BPurple}

ROOT_COLOR=${Red}
ROOT_DARK_COLOR=${DRed}
ROOT_BOLD_COLOR=${BRed}


# -- set colors
if [ $USR = priv ] ; then
    COLOR=$ROOT_COLOR
    DARK_COLOR=$ROOT_DARK_COLOR
    BOLD_COLOR=$ROOT_BOLD_COLOR
elif [ $CONN = lcl -a $USR = nopriv ] ; then
    COLOR=$LOCAL_COLOR
    DARK_COLOR=$LOCAL_DARK_COLOR
    BOLD_COLOR=$LOCAL_BOLD_COLOR
elif [ $CONN = tel -a $USR = nopriv ] ; then
    COLOR=$TELNET_COLOR
    DARK_COLOR=$TELNET_DARK_COLOR
    BOLD_COLOR=$TELNET_BOLD_COLOR
elif [ $CONN = ssh -a $USR = nopriv ] ; then
    COLOR=$SSH_COLOR
    DARK_COLOR=$SSH_DARK_COLOR
    BOLD_COLOR=$SSH_BOLD_COLOR
fi

PROMPT_USER='\u'
PROMPT_HOST='\h'

# -- set prompt
PS1="${debian_chroot:+($debian_chroot)}\[$BOLD_COLOR\]$PROMPT_USER\[$NC\]\[$DARK_COLOR\]@\[$NC\]\[$BOLD_COLOR\]$PROMPT_HOST\[$NC\]\[$DARK_COLOR\]:\[$COLOR\]\w\[$DARK_COLOR\]\$ \[\033[00m\]"


# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac


# -- export prompt
export PS1
