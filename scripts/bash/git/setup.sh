#!/bin/bash

GIT=$(which git)

if [ -z "${GIT}" ]; then
  echo "git not found. Check installation"
  exit 1
fi

git config --global user.name "Nishchint Raina"
git config --global user.email "nishchint@protonmail.ch"
git config --global core.editor "vim"
