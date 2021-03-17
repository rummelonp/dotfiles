#!/usr/bin/env bash

DOTFILES_HOME=$(cd $(dirname $0) && pwd)

function link_file() {
    local src=$DOTFILES_HOME/$1 dest=$HOME/$2
    ln -fsv $src $dest
}

function link_dir() {
    local src=$DOTFILES_HOME/$1 dest=$HOME/$2
    if [ -L $dest ]; then rm $dest; fi
    ln -sv $src $dest
}

# homebrew
link_file homebrew/.Brewfile .Brewfile

# zsh
link_dir  zsh/.zsh      .zsh
link_file zsh/.zshenv   .zshenv
link_file zsh/.zprofile .zprofile
link_file zsh/.zshrc    .zshrc

touch $HOME/.zshrc.local

# emacs
link_dir emacs .emacs.d

# vim
link_file vim/.vimrc .vimrc

# git
link_file git/.gitconfig .gitconfig
link_file git/.gitignore .gitignore

# tmux
link_dir  tmux/.tmux      .tmux
link_file tmux/.tmux.conf .tmux.conf

if [[ $OSTYPE =~ darwin ]]; then
    link_file tmux/.tmux/darwin.conf .tmux.local.conf
else
    link_file tmux/.tmux/linux.conf  .tmux.local.conf
fi

# ruby
link_file ruby/.gemrc   .gemrc
link_file ruby/.pryrc   .pryrc
link_file ruby/.railsrc .railsrc

# percol
link_dir percol .percol.d

# bin
link_dir bin .bin
