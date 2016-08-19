#!/bin/bash
set -e

pushd ~/dotfiles
git submodule update --init --recursive

stow -vv mjolnir
stow -vv slate
stow -vv tmux
stow -vv vim --ignore=.vim
test ! -e ~/.vim && cp -a vim/.vim ~/

popd
