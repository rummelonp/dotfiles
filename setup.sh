#!/bin/sh

DOTFILES_HOME=$(cd $(dirname $0) && pwd)
DOTFILES=(
    # zsh
    .zsh
    .zshenv
    .zprofile
    .zshrc
    # bin
    bin
    # emacs
    .emacs.d
    # vim
    .vimrc
    # git
    .gitconfig
    .gitignore
    # tmux
    .tmux.conf
    .tmux
    # ruby
    .gemrc
    .pryrc
    .railsrc
    # python
    .percol.d
)

for name in ${DOTFILES[@]}; do
    [ ! -e $HOME/$name ] &&
        ln -sv $DOTFILES_HOME/$name $HOME/$name
done

if [[ $OSTYPE =~ darwin ]]; then
    [ ! -e $HOME/.tmux.local ] &&
        ln -sv $HOME/.tmux/darwin.conf $HOME/.tmux.local
else
    [ ! -e $HOME/.tmux.local ] &&
        ln -sv $HOME/.tmux/linux.conf $HOME/.tmux.local
fi

touch $HOME/.zshrc.local
