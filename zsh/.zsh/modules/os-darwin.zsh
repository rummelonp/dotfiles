#
# Darwin
#

if ! [[ $OSTYPE =~ darwin ]]; then
    return
fi

### Key bindings ###
function _open-emacs() {
    echo 'tell application "Emacs" to activate window' | osascript
}
zle -N _open-emacs
bindkey '^x^e' _open-emacs

### Functions ###

function man-preview() {
    man -t $@ | open -f -a Preview
}
compdef _man man-preview

alias notifier='terminal-notifier -sound default -activate com.apple.Terminal'
alias -g N="&& notifier -message '（╹ω╹）' || notifier -message '（☓ω☓）'"
