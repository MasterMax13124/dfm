#!/bin/sh
#     _ ___       
#   _| |  _|_____ 
#  | . |  _|     |
#  |___|_| |_|_|_|
#  dotfile manager

sources=~/.dfmrc

. $sources

prompt(){
  while true; do
		printf "File already exists, do you want to overwrite it? (y/n): "
    read -r confirm
    confirm=$(echo "$confirm" | tr '[:upper:]' '[:lower:]')

    if [ "$confirm" = 'y' ]; then
      return 0
    elif [ "$confirm" = 'n' ]; then
      return 1
    else
      printf "Choose either yes or no\n"
    fi
  done
}

if [ "$1" = "c" ] || [ "$1" = "collect" ]; then
	printf "Destination: $targetdir\n"
	echo "$configloc" | tr ' ' '\n' | while read -r f; do
		printf "Copying $f from .config\n"
		cp -r "$HOME/.config/$f" "$targetdir/"
	done

	echo "$configloc" | tr ' ' '\n' | while read -r f; do
		printf "Copying $g from home\n"
		cp -r "$HOME/$g" "$targetdir/"
	done

elif [ "$1" = "d" ] || [ "$1" = "distribute" ]; then
	printf "Source: $targetdir\n"
	for f in "${configloc[@]}"; do
		printf "Copying $f to .config\n"
		if [ -e "$HOME/.config/$f" ]; then
			if prompt; then
				printf "File was overwritten\n\n"
			else
				printf "File was not overwritten\n\n"
				continue
			fi
		fi
		cp -r "$targetdir/$f" "$HOME/.config/"
	done

	for g in "${homeloc[@]}"; do
		printf "Copying $g to home\n"
		if [ -e "$HOME/$g" ]; then
			if prompt; then
				printf "File was overwritten\n\n"
			else
				printf "File was not overwritten\n\n"
				continue
			fi
		fi
		cp -r "$targetdir/$g" "$HOME/"
	done

elif [ "$1" = "s" ] || [ "$1" = "source" ]; then
	$EDITOR $sources

elif [ "$1" = "i" ] || [ "$1" = "info" ]; then
	printf "Source directory: ${sources}\n"
	printf "Selected files/folders in .config:\n${configloc[*]}\n\n"
	printf "Selected files/folders in home:\n${homeloc[*]}\n"

elif [ -z "$1" ]; then
	printf "Usage:\n c : collect dotfiles\n d : distribute dotfiles\n s : open configuration file\n i : print info about sources\n"

else
	printf "Command not recognized: $1\nRun dfm without arguments for usage info\n"
fi
