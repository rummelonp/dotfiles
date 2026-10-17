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
    tools-direnv
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

### Claude Code ###
# Claude Code writes commands for stock zsh, so drop option tweaks such as NO_CLOBBER and EXTENDED_GLOB.
if [[ -n $CLAUDECODE ]]; then
    emulate -R zsh
fi
