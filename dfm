#!/bin/sh
#     _ ___       
#   _| |  _|_____ 
#  | . |  _|     |
#  |___|_| |_|_|_|
#  dotfile manager

sources=~/.dfmrc

. $sources

if [[ $1 == "c" || $1 == "collect" ]]; then
	printf "Destination: $targetdir\n"
	for f in "${configloc[@]}"; do
		printf "Copying $f from .config\n"
		cp -r ~/.config/$f $targetdir
	done

	for g in "${homeloc[@]}"; do
		printf "Copying $g from home\n"
		cp -r ~/$g $targetdir
	done

elif [[ $1 == "d" || $1 == "distribute" ]]; then
	printf "Source: $targetdir\n"
	for f in "${configloc[@]}"; do
		printf "Copying $f to .config\n"
		cp -r $targetdir/$f ~/.config/
	done

	for g in "${homeloc[@]}"; do
		printf "Copying $g to home\n"
		cp -r $targetdir/$g ~/
	done

elif [[ $1 == "s" || $1 == "source" ]]; then
	$EDITOR $sources

elif [[ $1 == "i" || $1 == "info" ]]; then
	printf "Selected files/folders in .config:\n${configloc[*]}\n\n"
	printf "Selected files/folders in home:\n${homeloc[*]}\n"

elif [[ -z $1 ]]; then
	printf "Usage:\n c : collect dotfiles\n d : distribute dotfiles\n s : open configuration file\n i : print info about sources\n"

else
	printf "Command not recognized: $1\nRun dfm without arguments for usage info\n"
fi
