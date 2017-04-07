#!/bin/bash
#

function copied()
{
 echo "- Copied:  ${1}"
}

function not_copied()
{
 echo "- Skipped: ${1}"
}

function copy_one_file()
{
 local source="${1}"
 shift
 local target="${1}"
 shift
 local mode="${1}"
 shift
 #
 local dest_dir="`dirname "$target"`"
 local dest_file="`basename "$target"`"
 # echo "<$source -> $dest_dir/$dest_file>"
 test -e "$target" && diff -q "$source" "$target" >/dev/null 2>&1 && not_copied "$target" && return
 local do_sudo
 test "$mode" && do_sudo="sudo"
 $do_sudo cp -a "$source" "$target" && copied "$target"
}

function copy_one_dir()
{
 local -a sources
 local source="$1"
 shift
 cd "$source"
 sources=(*)
 local target="$1"
 shift
 mkdir -p "$target"
 local size=${#sources[*]}
 for ((i=0; i<$size; i++)); do
    local name="${sources[$i]}"
    copy_files "$name" "$target/$name" "${@}"
 done
}

# Copy the files only if they differ
# ${1}: source dir or file
# ${2}: destination dir
function copy_files()
{
 if test -d "${1}"; then
    (copy_one_dir "${@}")
 else
    copy_one_file "${@}"
 fi
}

copy_files bin $HOME/bin
copy_files bin-vim $HOME/bin/vim
copy_files plugin $HOME/.vim/plugin
copy_files autoload $HOME/.vim/autoload
copy_files doc $HOME/.vim/doc
copy_files vimrc $HOME/.vimrc
copy_files gvimrc $HOME/.gvimrc
copy_files omni $HOME/.vim
copy_files colors $HOME/.vim/colors
