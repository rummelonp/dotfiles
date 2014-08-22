#!/usr/bin/env bash

function execute() {
    echo $@
    eval $@
}

function create_symlink() {
    if [ -e $2 ]; then
        echo $2: File exists
    else
        execute ln -s $1 $2
    fi
}

typeset dotfiles_dir dotfile_name rsense_dir
typeset -a dotfiles

dotfiles_dir=$(cd $(dirname $0) && pwd)
dotfiles=(
    bin
    .zshenv
    .zshrc
    .zsh
    .emacs.d
    .gitconfig
    .gitignore
    .screenrc
    .screen
    .tmux.conf
    .tmux
    .gemrc
    .pryrc
    .railsrc
    .percol.d
)

for dotfile_name in ${dotfiles[@]}; do
    create_symlink $dotfiles_dir/$dotfile_name $HOME/$dotfile_name
done

if [[ $OSTYPE =~ darwin ]]; then
    create_symlink $HOME/.tmux/osx.conf $HOME/.tmux.local
    create_symlink $HOME/.screen/osx.conf $HOME/.screenrc.local
else
    create_symlink $HOME/.tmux/linux.conf $HOME/.tmux.local
    create_symlink $HOME/.screen/linux.conf $HOME/.screenrc.local
fi

execute touch $HOME/.zshrc.local

if which ruby > /dev/null; then
    rsense_dir=$dotfiles_dir/.emacs.d/el-get/rsense
    if [ -f $rsense_dir/etc/config.rb ]; then
        execute "ruby $rsense_dir/etc/config.rb > ~/.rsense"
    fi
fi

unset dotfiles_dir dotfiles dotfile_name rsense_dir
