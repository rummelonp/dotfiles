#
# Executes commands at the start of an interactive session
#

### Load modules ###
module_names=(
    # Basic
    environment
    editor
    history
    directory
    utility
    completion
    prompt
    # Extensions
    ssh
    fzf
    migemo
    # Environment dependent
    darwin
)
for module_name in $module_names; do
    source $HOME/.zsh/modules/$module_name.zsh
done
unset module_name{s,}

### Local configuration ###
source $HOME/.zshrc.local
