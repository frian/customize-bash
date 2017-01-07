# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

#
# -- less colors
#
# export LESS_TERMCAP_mb=${LESS_Cyan}
# export LESS_TERMCAP_md=${LESS_Cyan}
# export LESS_TERMCAP_me=$(tput sgr0)
# export LESS_TERMCAP_se=$(tput sgr0)
# export LESS_TERMCAP_so=$'\E[01;41;37m'
# export LESS_TERMCAP_ue=$(tput sgr0)
# export LESS_TERMCAP_us=${LESS_Yellow}

export LESS_TERMCAP_mb=${LESS_CYAN}
export LESS_TERMCAP_md=${LESS_CYAN}
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;41;37m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=${LESS_YELLOW}

#
# -- grep colors --------------------------------------------------------------
#

export GREP_COLORS='ms=01;31:mc=01;32:sl=:cx=:fn=93:ln=01;93:bn=96:se=33'

# GREP_COLORS
#           Specifies the colors and other attributes used to highlight various  parts  of  the
#           output.   Its  value  is  a  colon-separated  list of capabilities that defaults to
#           ms=01;31:mc=01;31:sl=:cx=:fn=35:ln=32:bn=32:se=36  with  the  rv  and  ne   boolean
#           capabilities omitted (i.e., false).  Supported capabilities are as follows.
#
#           sl=    SGR  substring  for  whole  selected lines (i.e., matching lines when the -v
#                  command-line option is omitted, or non-matching lines when -v is specified).
#                  If however the boolean rv capability and the -v command-line option are both
#                  specified, it applies to context matching lines  instead.   The  default  is
#                  empty (i.e., the terminal's default color pair).
#
#           cx=    SGR  substring for whole context lines (i.e., non-matching lines when the -v
#                  command-line option is omitted, or matching lines when -v is specified).  If
#                  however  the  boolean  rv capability and the -v command-line option are both
#                  specified, it applies to selected non-matching lines instead.   The  default
#                  is empty (i.e., the terminal's default color pair).
#
#           rv     Boolean  value  that  reverses  (swaps)  the  meanings  of  the  sl= and cx=
#                  capabilities when the -v command-line option is specified.  The  default  is
#                  false (i.e., the capability is omitted).
#
#           mt=01;31
#                  SGR  substring  for  matching  non-empty  text in any matching line (i.e., a
#                  selected line when the -v command-line option is omitted, or a context  line
#                  when  -v  is specified).  Setting this is equivalent to setting both ms= and
#                  mc= at once to the same value.  The default is a bold  red  text  foreground
#                  over the current line background.
#
#           ms=01;31
#                  SGR substring for matching non-empty text in a selected line.  (This is only
#                  used when the -v command-line option is omitted.)  The effect of the sl= (or
#                  cx=  if  rv) capability remains active when this kicks in.  The default is a
#                  bold red text foreground over the current line background.
#
#           mc=01;31
#                  SGR substring for matching non-empty text in a context line.  (This is  only
#                  used  when  the -v command-line option is specified.)  The effect of the cx=
#                  (or sl= if rv) capability remains active when this kicks in.  The default is
#                  a bold red text foreground over the current line background.
#
#           fn=35  SGR  substring  for file names prefixing any content line.  The default is a
#                  magenta text foreground over the terminal's default background.
#
#           ln=32  SGR substring for line numbers prefixing any content line.  The default is a
#                  green text foreground over the terminal's default background.
#
#           bn=32  SGR substring for byte offsets prefixing any content line.  The default is a
#                  green text foreground over the terminal's default background.
#
#           se=36  SGR substring for separators that are inserted between selected line  fields
#                  (:),  between context line fields, (-), and between groups of adjacent lines
#                  when nonzero context  is  specified  (--).   The  default  is  a  cyan  text
#                  foreground over the terminal's default background.
#
#           ne     Boolean  value that prevents clearing to the end of line using Erase in Line
#                  (EL) to Right (\33[K) each time a colorized item ends.  This  is  needed  on
#                  terminals on which EL is not supported.  It is otherwise useful on terminals
#                  for which the back_color_erase (bce) boolean terminfo  capability  does  not
#                  apply,  when  the  chosen  highlight colors do not affect the background, or
#                  when EL is too slow or causes too much flicker.  The default is false (i.e.,
#                  the capability is omitted).
