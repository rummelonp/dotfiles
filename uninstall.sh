#!/usr/bin/env bash

DOTFILES_HOME=$(cd "$(dirname "${0}")" && pwd)

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
unlink_file .bin
unlink_file .config/bat
unlink_file .config/karabiner
unlink_file .npmrc
unlink_file .yarnrc.yml
unlink_file "Library/Preferences/pnpm/rc"
unlink_file "Library/Application Support/Code/User/settings.json"
unlink_file "Library/Application Support/Code/User/keybindings.json"
for dir in "${HOME}"/Library/Application\ Support/Google/AndroidStudio*/; do
    [ -d "${dir}" ] || continue
    unlink_file "${dir#${HOME}/}colors"
    unlink_file "${dir#${HOME}/}keymaps"
done

unlink_file .claude/CLAUDE.md
unlink_file .claude/settings.json
unlink_file .codex/AGENTS.md

for dir in "${DOTFILES_HOME}"/skills/*/; do
    name=$(basename "${dir}")
    unlink_file ".claude/skills/${name}"
    unlink_file ".agents/skills/${name}"
done

for dir in "${DOTFILES_HOME}"/claude/skills/*/; do
    unlink_file ".claude/skills/$(basename "${dir}")"
done

for dir in "${DOTFILES_HOME}"/codex/skills/*/; do
    unlink_file ".agents/skills/$(basename "${dir}")"
done
