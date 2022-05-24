#
# Darwin
#

if ! [[ $OSTYPE =~ darwin ]]; then
    return
fi

### Key bindings ###
function _copy-line-as-kill() {
    zle kill-line
    print -rn $CUTBUFFER | pbcopy
}

function _paste-as-yank() {
    pbpaste
}

function _open-emacs() {
    echo 'tell application "Emacs" to activate window' | osascript
}

zle -N _copy-line-as-kill
zle -N _paste-as-yank
zle -N _open-emacs

bindkey '^k' _copy-line-as-kill
bindkey '^y' _paste-as-yank
bindkey '^x^e' _open-emacs

### Functions ###

function man-preview() {
    man -t $@ | open -f -a Preview
}
compdef _man man-preview

alias notifier='terminal-notifier -sound default -activate com.apple.Terminal'
alias -g N="&& notifier -message '（╹ω╹）' || notifier -message '（☓ω☓）'"
