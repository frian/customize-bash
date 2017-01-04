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
# -- copy files to $HOME remove file extension
#
echo "  copy files to \$HOME"
for file in .*.sh; do
    cp "$file" "$HOME/`basename "$file" .sh`"
done


echo "  cd to \$HOME"
cd $HOME


#
# -- add . ~/.bash_customize to .bshrc
#
echo "  add .bash_customize sourcing to bash if not present"
if ! grep -q ". ~/.bash_customize" .bashrc; then
    # -- add source the file to bashrc
    echo >> ~/.bashrc
    echo "# -- shell customization" >> .bashrc
    echo ". ~/.bash_customize" >> .bashrc
fi


# -- load bashrc
echo "  reloading config"
. ~/.bashrc
