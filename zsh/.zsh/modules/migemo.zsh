#
# C/Migemo
#

if ! which cmigemo > /dev/null; then
    return
fi

### Aliases ###
alias migemo='cmigemo -d "$(brew --prefix)"/share/migemo/utf-8/migemo-dict -w'

### Functions ###

# Migemo grep
function mg() {
    if (( $# == 0 )); then
        echo "Usage: $0 <query> <rg options>"
        exit 1
    fi
    local query word=$1
    shift
    query=$(cmigemo -d "$(brew --prefix)"/share/migemo/utf-8/migemo-dict -w "$word")
    rg "$query" "$@"
}

function _mg() {
    local context state line curcontext="$curcontext"
    if (( CURRENT > 2 )); then
        _call_function - _rg
    else
        _guard '^-*' 'query'
    fi
}

compdef _mg mg

# Migemo find
function mf() {
    if (( $# == 0 )); then
        echo "Usage: $0 <query> <fd options>"
        exit 1
    fi
    local query word=$1
    shift
    query=$(cmigemo -d "$(brew --prefix)"/share/migemo/utf-8/migemo-dict -w "$word")
    fd "$query" "$@"
}

function _mf() {
    local context state line curcontext="$curcontext"
    if (( CURRENT > 2 )); then
        _call_function - _fd
    else
        _guard '^-*' 'query'
    fi
}

compdef _mf mf
