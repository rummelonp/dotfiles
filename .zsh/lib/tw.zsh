## Twitter

if which tw > /dev/null; then
else
    return
fi

function tw-tweet() {
    local file=${TMPDIR}tw-tweet
    echo > $file
    emacsclient $file
    local text="`cat $file`"
    if [ $#text -eq 0 ]; then
        return
    fi
    if [ $# -ge 1 ]; then
        cat $file | tw --pipe --user=$1
    else
        cat $file | tw --pipe
    fi
}

alias tweet="tw-tweet"

__tw_user_list() {
    _tw_user_list=($(tw --user:list | grep -v -E '\(\d+ users\)' | sed 's/\*//g'))
    _describe -t tw_user_list "user" _tw_user_list
}

_tw_tweet() {
    _arguments ":user:__tw_user_list"
}

compdef _tw_tweet tw-tweet
