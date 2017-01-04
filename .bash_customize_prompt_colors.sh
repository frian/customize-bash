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
LOCAL_COLOR=36m  # blue
SSH_COLOR=92m    # green
TELNET_COLOR=35m # purple
ROOT_COLOR=31m   # red

COLOR=blue

# -- set colors
if [ $USR = priv ] ; then
    COLOR=$ROOT_COLOR
elif [ $CONN = lcl -a $USR = nopriv ] ; then
    COLOR=$LOCAL_COLOR
elif [ $CONN = tel -a $USR = nopriv ] ; then
    COLOR=$TELNET_COLOR
elif [ $CONN = ssh -a $USR = nopriv ] ; then
    COLOR=$SSH_COLOR
fi

PROMPT_USER='\u'
PROMPT_HOST='\h'

# -- set prompt
PS1="${debian_chroot:+($debian_chroot)}\[\033[1;$COLOR\]$PROMPT_USER@$PROMPT_HOST\[\033[0;$COLOR\]:\[\033[1;$COLOR\]\w\[\033[0;$COLOR\]\$ \[\033[00m\]"

# -- export prompt
export PS1
