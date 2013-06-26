#!/bin/sh

## functions
function execute() {
    echo $*
    eval $*
}

function create_symlink() {
    if [ -e $2 ]; then
        echo "$2: File exists"
    else
        execute "ln -s $1 $2"
    fi
}

## dotfiles dir
DOTFILES_DIR=$(cd $(dirname $0) && pwd)

## dotfiles
DOTFILES=(bin .zshenv .zshrc .zsh .emacs.d .gitconfig .gitignore .screenrc .screen .tmux.conf .tmux .gemrc .pryrc .railsrc .percol.d)
for name in ${DOTFILES[@]}
do
    create_symlink $DOTFILES_DIR/$name $HOME/$name
done

## .tmux.local / .screenrc.local
if [[ $OSTYPE =~ "darwin" ]]; then
    create_symlink $HOME/.tmux/osx.conf $HOME/.tmux.local
    create_symlink $HOME/.screen/osx.conf $HOME/.screenrc.local
else
    create_symlink $HOME/.tmux/linux.conf $HOME/.tmux.local
    create_symlink $HOME/.screen/linux.conf $HOME/.screenrc.local
fi

## .zshrc.local
execute "touch $HOME/.zshrc.local"

## .rsense
if which ruby > /dev/null; then
    RSENSE_DIR="$DOTFILES_DIR/.emacs.d/el-get/rsense"
    if [ -f $RSENSE_DIR/etc/config.rb ]; then
        execute "ruby $RSENSE_DIR/etc/config.rb > ~/.rsense"
    fi
fi
