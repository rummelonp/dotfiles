typeset zsh_home zsh_completions_home zsh_file zsh_local_file

# Home
zsh_home=$HOME/.zsh

# Completion
zsh_completions_home=$zsh_home/completions
if ! [[ -n $fpath[(re)$zsh_completions_home] ]]; then
    fpath=($zsh_completions_home $fpath)
fi

# Library
for zsh_file in $zsh_home/lib/*.zsh; do
    source $zsh_file
done

# Local configuration
zsh_local_file=$HOME/.zshrc.local
if [ -f $zsh_local_file ]; then
    source $zsh_local_file
fi

unset zsh_home zsh_completions_home zsh_file zsh_local_file
