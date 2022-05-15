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
unlink_file .irbrc
unlink_file .pryrc
unlink_file .railsrc
unlink_file .percol.d
unlink_file .bin
unlink_file .config/karabiner
unlink_file "Library/Application Support/Code/User/settings.json"
unlink_file "Library/Application Support/Code/User/keybindings.json"
unlink_file "Library/Application Support/Google/AndroidStudio2021.2/colors"
unlink_file "Library/Application Support/Google/AndroidStudio2021.2/keymaps"
