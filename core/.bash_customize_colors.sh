#
# -- shell colors -------------------------------------------------------------
#

# Normal Colors
Black=$(tput setaf 0)      # Black
Red=$(tput setaf 9)        # Red
Green=$(tput setaf 10)     # Green
Yellow=$(tput setaf 11)    # Yellow
Blue=$(tput setaf 12)      # Blue
Purple=$(tput setaf 13)    # Purple
Cyan=$(tput setaf 14)      # Cyan
White=$(tput setaf 15)     # White

# Dark Colors
DBlack=$(tput setaf 16)     # Black
DRed=$(tput setaf 1)        # Red
DGreen=$(tput setaf 2)      # Green
DYellow=$(tput setaf 3)     # Yellow
DBlue=$(tput setaf 4)       # Blue
DPurple=$(tput setaf 5)     # Purple
DCyan=$(tput setaf 6)       # Cyan
DWhite=$(tput setaf 7)      # White

# Bold
BBlack=$(tput bold; tput setaf 0)      # Black
BRed=$(tput bold; tput setaf 9)        # Red
BGreen=$(tput bold; tput setaf 10)     # Green
BYellow=$(tput bold; tput setaf 11)    # Yellow
BBlue=$(tput bold; tput setaf 12)      # Blue
BPurple=$(tput bold; tput setaf 13)    # Purple
BCyan=$(tput bold; tput setaf 14)      # Cyan
BWhite=$(tput bold; tput setaf 15)     # White

# Background
On_Black=$(tput setab 0)      # Black
On_Red=$(tput setab 9)        # Red
On_Green=$(tput setab 10)     # Green
On_Yellow=$(tput setab 11)    # Yellow
On_Blue=$(tput setab 12)      # Blue
On_Purple=$(tput setab 13)    # Purple
On_Cyan=$(tput setab 14)      # Cyan
On_White=$(tput setab 15)     # White

# Dark BaOn_Dckground
On_DBlack=$(tput setaf 16)     # Black
On_DRed=$(tput setaf 1)        # Red
On_DGreen=$(tput setaf 2)      # Green
On_DYellow=$(tput setaf 3)     # Yellow
On_DBlue=$(tput setaf 4)       # Blue
On_DPurple=$(tput setaf 5)     # Purple
On_DCyan=$(tput setaf 6)       # Cyan
On_DWhite=$(tput setaf 7)      # White


NC=$(tput sgr0)               # Color Reset


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
