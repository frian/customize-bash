#!/usr/bin/bash

#
# -- get and cd in script dir
#

# -- Absolute path to this script
SCRIPT=${BASH_SOURCE[0]}

# -- Absolute path to script dir
SCRIPTPATH=$(dirname "${SCRIPT}")

# -- cd to script dir for config sourcing
cd $SCRIPTPATH


#
# -- create install dir if not exists
#
INSTALLPATH=~/.customize-bash

if [[ ! -d $INSTALLPATH ]]; then
    mkdir $INSTALLPATH
fi


#
# -- copy core files to $HOME/.customize-bash remove file extension
#
echo "  copy core files to \$HOME"
for file in core/.*.sh; do
    cp "$file" "$INSTALLPATH/`basename "$file" .sh`"
done


#
# -- copy personal files to $HOME/.customize-bash remove file extension
#
echo "  copy personal files to \$HOME"
for file in personal/.*.sh; do
    cp "$file" "$INSTALLPATH/`basename "$file" .sh`" 2>/dev/null
done


#
# -- add . ~/.bash_customize to .bshrc
#
echo "  add .bash_customize sourcing to bash if not present"
if ! grep -q ". $INSTALLPATH/.bash_customize" ~/.bashrc; then
    # -- add source the file to bashrc
    echo >> ~/.bashrc
    echo "# -- shell customization" >> ~/.bashrc
    echo ". $INSTALLPATH/.bash_customize" >> ~/.bashrc
fi


# -- load bashrc
echo "  reloading config"
. ~/.bashrc


cd - 1>/dev/null
