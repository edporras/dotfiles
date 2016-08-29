#!/bin/bash
############################
# .make.sh
#
# Based on
# http://blog.smalleycreative.com/tutorials/using-git-and-github-to-manage-your-dotfiles/
#
# This script creates symlinks from the home directory to any desired
# dotfiles in the repo
############################

# old dotfiles backup directory
olddir=~/.dotfiles_old

if [ -e "$olddir" ]
then
    echo "File backups already exist. Exiting."
    exit 1
fi


# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
echo "...done"

# change to the dotfiles directory
dir=$(dirname $(dirname $0))
echo "Changing to the $dir directory"
cd $dir
echo "...done"

echo "Symlinking config files from $dir to $HOME"
for file in "$dir/"*
do
    if [ -d "$file" ]; then
        continue
    fi

    name=$(basename $file)
    if [ "$name" != "README.md" ]
    then
        dotfile="$HOME/.$name"
        bufile="$olddir/$name"

        if [ -h "$dotfile" ]; then
            echo "$dotfile is already linked. Skipping."
            continue
        fi

        if [ -e "$dotfile" ]
        then
            if [ ! -e "$bufile" ]; then
                mv "$dotfile" "$bufile"
            else
                echo "Warning: file already backed up. Will not overwrite backup"
                rm "$dotfile"
            fi
        fi

        ln -sv "${PWD}/$file" "$dotfile"
    fi
done

exit 0
