#!/usr/bin/bash

# -- copy files to $HOME remove file extension
echo "  copy files to \$HOME"
for file in .*.sh; do
    cp "$file" "$HOME/`basename "$file" .sh`"
done

echo "  cd to \$HOME"
cd $HOME

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
