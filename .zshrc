## Path to zsh
ZSH=$HOME/.zsh

## Add completions path
for completions in /usr/local/share/zsh-completions $ZSH/completions; do
    if [[ -n ${fpath[(re)$completions]} ]]; then
    else
        fpath=($completions $fpath)
    fi
done
unset completions

## Load all configuration
for file in $ZSH/lib/*.zsh; do
    source $file
done
unset file

## Include local configuration
if [ -f $HOME/.zshrc.local ]; then
    source $HOME/.zshrc.local
fi
