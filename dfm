#!/bin/sh
#     _ ___       
#   _| |  _|_____ 
#  | . |  _|     |
#  |___|_| |_|_|_|
#  dotfile manager

# TO-DO:
# integrate git commands
# use case instead of the weird double test statements
# add man page

sources=~/.dfmrc

. $sources

prompt(){
	printf "File already exists, do you want to overwrite it? (y/n): "
  read -r confirm
  confirm=$(echo "$confirm" | tr '[:upper:]' '[:lower:]')

  if [ "$confirm" = 'y' ] || "$confirm" = 'yes' ]; then
    return 0
	else
		return 1
  fi
}

if [ "$1" = "c" ] || [ "$1" = "collect" ]; then
	printf "Destination: $targetdir\n"

	echo "$configloc" | tr ' ' '\n' | while read -r f; do
		printf "Copying $f from .config\n"
		cp -r "$HOME/.config/$f" "$targetdir/"
	done

	echo "$homeloc" | tr ' ' '\n' | while read -r g; do
		printf "Copying $g from home\n"
		cp -r "$HOME/$g" "$targetdir/"
	done

elif [ "$1" = "d" ] || [ "$1" = "distribute" ]; then
	printf "Source: $targetdir\n"

	echo "$configloc" | tr ' ' '\n' | while read -r f; do
		printf "Copying $f to .config\n"
		if [ -e "$HOME/.config/$f" ]; then
			if true; then
				printf "File was overwritten\n\n"
			else
				printf "File was not overwritten\n\n"
				continue
			fi
		fi
		cp -r "$targetdir/$f" "$HOME/.config/"
	done

	echo "$homeloc" | tr ' ' '\n' | while read -r g; do
		printf "Copying $g to home\n"
		if [ -e "$HOME/$g" ]; then
			if true; then
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
	printf "Selected files/folders in .config:\n$configloc\n\n"
	printf "Selected files/folders in home:\n$homeloc\n"

elif [ -z "$1" ]; then
	printf "Usage:\n c : collect dotfiles\n d : distribute dotfiles\n s : open configuration file\n i : print info about sources\n"

else
	printf "Command not recognized: $1\nRun dfm without arguments for usage info\n"
fi
