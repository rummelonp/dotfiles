## Path to zsh
ZSH=$HOME/.zsh

## Add completions path
local completions=$ZSH/completions
if [[ -n ${fpath[(re)$completions]} ]]; then
else
    fpath=($completions $fpath)
fi
unset completions

## Load all configuration
for file in $ZSH/lib/*.zsh; do
    source $file
done

## Include local configuration
if [ -f $HOME/.zshrc.local ]; then
    source $HOME/.zshrc.local
fi
