### Darwin

if ! [[ $OSTYPE =~ darwin ]]; then
    return
fi

## Notification
autoload -Uz add-zsh-hook

typeset command=''
typeset command_time=0

function _precmd-notification() {
    if (( $command_time > 0 )); then
        typeset d=$(date +%s)
        (( d = $d - $command_time ))
        if (( $d >= 30 )); then
            notification "$command " -t "${${(s: :)command}[1]}"
        fi
    fi
    command=''
    command_time=0
}

function _preexec-notification() {
    command=$1
    command_time=$(date +%s)
}

add-zsh-hook precmd _precmd-notification
add-zsh-hook preexec _preexec-notification

## Key bind
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

## Function
function man-preview() {
    man -t $@ | open -f -a Preview
}
compdef _man man-preview

function free-memory() {
    diskutil repairPermissions /
    purge
    du -sx / >& /dev/null & sleep 5 && kill $!
}

function notification() {
    typeset title
    typeset subtitle
    typeset text=''
    while [ "$1" != '' ]; do
        case $1 in
            -t)
                shift
                title=$1
                ;;
            -s)
                shift
                subtitle=$1
                ;;
            *)
                text+=" $1"
        esac
        shift
    done
    typeset command="display notification \"$text\""
    if [ -n $title ]; then
        command+=" with title \"$title\""
        if [ -n $subtitle ]; then
            command+=" subtitle \"$subtitle\""
        fi
    fi
    echo $command | osascript
}
