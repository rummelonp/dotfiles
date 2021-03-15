### Darwin

if ! [[ $OSTYPE =~ darwin ]]; then
    return
fi

## Key bindings
function _copy-line-as-kill() {
    zle kill-line
    print -rn $CUTBUFFER | pbcopy
}
zle -N _copy-line-as-kill

function _paste-as-yank() {
    pbpaste
}
zle -N _paste-as-yank

bindkey '^k' _copy-line-as-kill
bindkey '^y' _paste-as-yank

## Functions
function man-preview() {
    man -t $@ | open -f -a Preview
}
compdef _man man-preview

function free-memory() {
    diskutil repairPermissions /
    purge
    du -sx / >& /dev/null & sleep 5 && kill $!
}
