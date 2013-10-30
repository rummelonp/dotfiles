## Autojump

if [ -f /usr/share/autojump/autojump.zsh ]; then
    . /usr/share/autojump/autojump.zsh
elif [ $commands[brew] -a -f `brew --prefix`/etc/autojump.zsh ]; then
    . `brew --prefix`/etc/autojump.zsh
fi

# autojump
export AUTOJUMP_DATA_DIR=$HOME/.autojump
