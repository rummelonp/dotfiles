### Initialize

## Home
ZSH=$HOME/.zsh

## Completions
typeset -U fpath
fpath=($ZSH/completions $fpath)

## Load library
for file in $ZSH/lib/*.zsh; do
    source $file
done
unset file

## Local configuration
source $HOME/.zshrc.local
