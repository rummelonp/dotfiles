## OSX

if [[ $OSTYPE =~ "darwin" ]]; then
else
    return
fi

# Growl
local command=""
local command_time=""
precmd() {
    if [ "$command_time" -ne "0" ] ; then
        local d=`date +%s`
        d=`expr $d - $command_time`
        if [ "$d" -ge "30" ] ; then
            command="$command "
            notification "$command" -t "${${(s: :)command}[1]}"
        fi
    fi
    command="0"
    command_time="0"
}
preexec() {
    command="${1}"
    command_time=`date +%s`
}

# Function
function man-preview() {
    man -t "$@" | open -f -a Preview
}
compdef _man man-preview

function free-memory() {
    diskutil repairPermissions /
    purge
    du -sx / >& /dev/null & sleep 5 && kill $!
}

function notification() {
    local title
    local subtitle
    local text=""
    while [ "$1" != "" ]; do
        case "$1" in
            -t)
                shift
                title="$1"
                ;;
            -s)
                shift
                subtitle="$1"
                ;;
            *)
                text+=" $1"
        esac
        shift
    done
    local command="display notification \"$text\""
    if [ -n "$title" ]; then
        command+=" with title \"$title\""
        if [ -n "$subtitle" ]; then
            command+=" subtitle \"$subtitle\""
        fi
    fi
    echo "$command" | osascript
}

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
bindkey "^y" _paste-as-yank
