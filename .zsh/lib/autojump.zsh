## Autojump

if [ -f /usr/share/autojump/autojump.zsh ]; then
    source /usr/share/autojump/autojump.zsh
elif [ $commands[brew] -a -f $(brew --prefix)/etc/autojump.zsh ]; then
    source $(brew --prefix)/etc/autojump.zsh
fi
