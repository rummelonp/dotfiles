## Percol

if which percol > /dev/null; then
else
    return
fi

function percol-insert-file() {
    LBUFFER=$LBUFFER$(ls -A | \
        percol --match-method regex | \
        sed 's/ /\\ /g' | \
        tr '\n' ' ')
    zle clear-screen
}
zle -N percol-insert-file

# History
function percol-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(builtin history -n 1 | \
        eval $tac | \
        percol --match-method regex --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N percol-select-history

# Search
function percol-search-document() {
    if (( $#DOCUMENT_DIR == 0 )); then
        DOCUMENT_DIR=($HOME/Documents)
        if [ -d $HOME/Dropbox ]; then
            DOCUMENT_DIR=($HOME/Dropbox $DOCUMENT_DIR[*])
        fi
    fi

    typeset -a document_dir
    if (( $# >= 1 )); then
        document_dir=$@
    else
        document_dir=$DOCUMENT_DIR
    fi

    PERCOL_SELECTED_FILE=($(echo $document_dir | \
        xargs find | \
        grep -E "\.(txt|md|pdf|key|numbers|pages|doc|xlsx?|ppt)$" | \
        percol --match-method migemo | \
        sed 's/ /\\ /g'))
    if (( $#PERCOL_SELECTED_FILE > 0 )); then
        echo $PERCOL_SELECTED_FILE
    fi
}

function percol-search-locate() {
    if (( $# > 0 )); then
        PERCOL_SELECTED_FILE=($(locate $@ | \
            percol --match-method regex | \
            sed 's/ /\\ /g'))
        if (( $#PERCOL_SELECTED_FILE > 0 )); then
            echo $PERCOL_SELECTED_FILE
        fi
    else
        locate
    fi
}

bindkey '^[c' percol-insert-file
bindkey '^r' percol-select-history

alias pd='percol-search-document'
alias pl='percol-search-locate'

alias -g P="| percol --match-method migemo"
