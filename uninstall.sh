#!/usr/bin/env bash

function unlink_file() {
    local dest="${HOME}/${1}"
    if [ -L "${dest}" ]; then rm -v "${dest}"; fi
}

unlink_file .Brewfile
unlink_file .zsh
unlink_file .zshenv
unlink_file .zprofile
unlink_file .zshrc
unlink_file .emacs.d
unlink_file .vimrc
unlink_file .gitconfig
unlink_file .gitignore
unlink_file .tmux
unlink_file .tmux.conf
unlink_file .tmux.local.conf
unlink_file .gemrc
unlink_file .pryrc
unlink_file .railsrc
unlink_file .percol.d
unlink_file .bin
