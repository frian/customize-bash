#!/usr/bin/bash

# -- default profile
PROFILE=default

# -- startup files list
STARTUPFILES=(  .zshrc .bash_profile .bash_login .profile .bashrc)

# -- default startup file
STARTUPFILE=.bashrc


# -- output colors
error=$(tput setaf 9)    # -- red
warning=$(tput setaf 10) # -- green
info=$(tput setaf 11)    # -- yellow
reset=$(tput sgr0)


# -- check if script is sourced
if [[ $0 == $BASH_SOURCE ]]; then

    echo -e "\n  ${warning}WARNING${reset} : please source the script\n"

    echo -e "  ${info}source $0 $@ ${reset} or ${info}. $0 $@ ${reset} \n"

    exit
fi


#
# -- get and cd in script dir
#

# -- absolute path to this script
SCRIPT=${BASH_SOURCE[0]}

# -- absolute path to script dir
SCRIPTPATH=$(dirname "${SCRIPT}")

# -- cd to script dir
cd $SCRIPTPATH


# -- enable getopts in sourced script
OPTIND=1

# -- handle options
while getopts ":f:h" opt; do
    case $opt in
        f)
            # -- check if file is startup file
            if [[ ! " ${STARTUPFILES[@]} " =~ " ${OPTARG} " ]];then

                echo -e "\n  ${error}ERROR${reset} : the provided file name ${info}$OPTARG${reset} is not a bash startup file !\n"

                echo -e "  select one of : \n"
                for i in "${STARTUPFILES[@]}"
                do
                   echo "    $i"
                done
                echo

                return
            fi

            # -- store file name
            STARTUPFILE=$OPTARG
        ;;
        h)
            echo -e "\n  usage : source $SCRIPT [ -f startup_file ] [ profile ] \n"

            echo -n "    startup_file : "

            id="${STARTUPFILES[@]}"
            echo -e ${id// /, }'(default)' "\n"

            return
        ;;
        \?)
            # -- invalid option
            echo "  invalid option: -$OPTARG" >&2
            return 1
        ;;
        :)
            # -- missing argument
            echo "  option -$OPTARG requires an argument." >&2
            return 1
        ;;
    esac
done


# -- get next argument
shift $(expr $OPTIND - 1 )


#
# -- set profile
#
if [[ $1 ]]; then
    if [[ -d profiles/$1 ]]; then
        PROFILE=$1
    else
        echo -e "\n  ${error}ERROR${reset} : profile ${info}$1${reset} not found !\n"
        return
    fi
fi


#
# -- create install dir if not exists
#
INSTALLPATH=~/.customize-bash

if [[ ! -d $INSTALLPATH ]]; then
    mkdir $INSTALLPATH
else
    # rm -rf $INSTALLPATH/*
    rm -rf $INSTALLPATH/.* $INSTALLPATH/* 2>/dev/null
fi

#
# -- generate core/bash_customize.sh
#
CONFIG_FILE=profiles/$PROFILE/bash_customize.sh
CONFIG_TMP_FILE=profiles/$PROFILE/bash_customize.sh.tmp


# -- delete existing config file
if [[ -e $CONFIG_FILE ]]; then
    rm $CONFIG_FILE
fi


# -- add install path
echo INSTALLPATH=$HOME/.customize-bash >> $CONFIG_TMP_FILE


#
# -- add files to source. Order is important !
#

# -- 1 add colors definition
echo . $INSTALLPATH/.bash_customize_colors >> $CONFIG_TMP_FILE

# -- 2 add user profile
echo . $INSTALLPATH/.bash_customize_profile >> $CONFIG_TMP_FILE

# -- 3 add prompt colors
echo . $INSTALLPATH/.bash_customize_prompt_colors >> $CONFIG_TMP_FILE

# -- 4 add shell definition
echo . $INSTALLPATH/.bash_customize_shell >> $CONFIG_TMP_FILE


# -- add profile files
for file in profiles/$PROFILE/*.sh; do
    # -- skip previously added file
    if [[ $file =~ 'bash_customize_profile.sh' ]]; then
        continue
    fi
    echo . "$INSTALLPATH/.`basename "$file" .sh`" >> $CONFIG_TMP_FILE
done


# -- remove bogus line if personal is empty
sed -i '/.*\.\*$/d' $CONFIG_TMP_FILE 1>/dev/null


mv $CONFIG_TMP_FILE $CONFIG_FILE


#
# -- copy core files to $HOME/.customize-bash remove file extension
#
echo "  copy core files to \$HOME"
for file in core/*.sh; do
    cp "$file" "$INSTALLPATH/.`basename "$file" .sh`"
done


#
# -- copy personal files to $HOME/.customize-bash remove file extension
#
echo "  copy personal files to \$HOME"
for file in profiles/$PROFILE/*.sh; do
    cp "$file" "$INSTALLPATH/.`basename "$file" .sh`" 2>/dev/null
done


#
# -- add . ~/.bash_customize to STARTUPFILE
#
echo "  add .bash_customize sourcing to $STARTUPFILE if not present"
if [[ -f ~/$STARTUPFILE ]] && ! grep -q ". $INSTALLPATH/.bash_customize" ~/$STARTUPFILE || [[ ! -f ~/$STARTUPFILE ]]; then
    # -- add source the file to bashrc
    echo >> ~/$STARTUPFILE
    echo "# -- shell customization" >> ~/$STARTUPFILE
    echo ". $INSTALLPATH/.bash_customize" >> ~/$STARTUPFILE
fi


# -- load bashrc
echo "  reloading config"
. ~/$STARTUPFILE

# return to calling dir
cd - 1>/dev/null
