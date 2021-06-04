#     _ ___       
#   _| |  _|_____ 
#  | . |  _|     |
#  |___|_| |_|_|_|
#  dotfile manager

#!/bin/sh
sources=~/.dfmrc

source $sources

if [[ $1 == "c" || $1 == "collect" ]]; then
	for f in "${configloc[@]}"; do
		echo Copying $f from .config
		cp -r ~/.config/$f $targetdir
	done

	for g in "${homeloc[@]}"; do
		echo Copying $g from home
		cp -r ~/$g $targetdir
	done

elif [[ $1 == "d" || $1 == "distribute" ]]; then
	:

elif [[ $1 == "s" || $1 == "source" ]]; then
	$EDITOR $sources

elif [[ $1 == "i" || $1 == "info" ]]; then
	echo "Selected files/folders in .config: \n ${configloc[@]}"
	echo ""
	echo "Selected files/folders in home: \n ${homeloc[@]}"

elif [[ -z $1 ]]; then
	echo "Usage:\n c : collect dotfiles\n d : distribute dotfiles\n s : open configuration file"

else
	echo "Command not recognized: $1\nRun dfm without arguments for usage info"
fi
