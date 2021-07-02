#
# Autojump
#

if [ -f /usr/share/autojump/autojump.zsh ]; then
    source /usr/share/autojump/autojump.zsh
elif (( $+commands[brew] )) && [ -f $(brew --prefix)/etc/profile.d/autojump.sh ]; then
    source $(brew --prefix)/etc/profile.d/autojump.sh
    # Sort fpath
    fpath=(
        $(brew --prefix)/share/zsh/{functions,site-functions}
        $fpath
    )
fi
