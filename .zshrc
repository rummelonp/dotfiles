### Initialize

## Load modules
module_names=(
    # Basic
    environment
    editor
    history
    directory
    utility
    completion
    prompt
    # Extension
    autojump
    percol
    # Environment dependent
    darwin
)
for module_name in $module_names; do
    source $HOME/.zsh/modules/$module_name.zsh
done
unset module_names
unset module_name

## Local configuration
source $HOME/.zshrc.local
