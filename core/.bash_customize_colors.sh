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
# -- less colors --------------------------------------------------------------
#
LESS_BLACK=$'\E[01;30m'
LESS_RED=$'\E[01;31m'
LESS_GREEN=$'\E[01;32m'
LESS_YELLOW=$'\E[01;33m'
LESS_BLUE=$'\E[01;34m'
LESS_PURPLE=$'\E[01;35m'
LESS_CYAN=$'\E[01;36m'
LESS_WHITE=$'\E[01;37m'

lESS_NC=$'\E[0m'               # Color Reset
