#!/bin/bash
THISDIR=$(dirname "$0")
source ${THISDIR}/../utils/common.shlib

cp ${THISDIR}/.vimrc ~

mkdir -p ~/.vim/bundle
mkdir -p ~/.vim/autoload

if [ ! -d ~/.vim/bundle/vim-airline ]; then
  git clone https://github.com/vim-airline/vim-airline.git ~/.vim/bundle/vim-airline
fi

if [ ! -d ~/.vim/bundle/vim-airline-themes ]; then
  git clone https://github.com/vim-airline/vim-airline-themes.git ~/.vim/bundle/vim-airline-themes
fi

curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
