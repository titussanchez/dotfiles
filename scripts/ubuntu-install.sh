#!/bin/bash
set -e

pushd ~/dotfiles
stow -vv i3
stow -vv config
stow -vv vim --ignore=.vim
test ! -e ~/.vim && cp -a vim/.vim ~/
popd
