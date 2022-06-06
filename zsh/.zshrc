#
# Executes commands at the start of an interactive session
#

### Load modules ###
module_names=(
    core-environment
    core-editor
    core-history
    core-directory
    core-utility
    core-completion
    ui-prompt
    tools-ssh
    tools-fzf
    tools-migemo
    lang-ruby
    lang-python
    lang-android
    os-darwin
)
for module_name in $module_names; do
    source $HOME/.zsh/modules/$module_name.zsh
done
unset module_name{s,}

### Local configuration ###
source $HOME/.zshrc.local
