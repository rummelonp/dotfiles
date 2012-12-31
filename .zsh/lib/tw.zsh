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
