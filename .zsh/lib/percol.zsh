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
    BUFFER=$(history -n 1 | \
        eval $tac | \
        percol --match-method regex --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N percol-select-history

# Search
function percol-search-document() {
    if [ $# -ge 1 ]; then
        DOCUMENT_DIR=$*
    else
        DOCUMENT_DIR=($HOME/Dropbox)
        if [ -d $HOME/Documents ]; then
            DOCUMENT_DIR=($HOME/Documents $DOCUMENT_DIR)
        fi
    fi
    SELECTED_FILE=$(echo $DOCUMENT_DIR | \
        xargs find | \
        grep -E "\.(txt|md|pdf|key|numbers|pages|doc|xls|ppt)$" | \
        percol --match-method migemo)
    if [ $? -eq 0 ]; then
        echo $SELECTED_FILE | sed 's/ /\\ /g'
    fi
}

function percol-search-locate() {
    if [ $# -ge 1 ]; then
        SELECTED_FILE=$(locate $* | percol --match-method regex)
        if [ $? -eq 0 ]; then
            echo $SELECTED_FILE | sed 's/ /\\ /g'
        fi
    else
        bultin locate
    fi
}

bindkey '^[c' percol-insert-file
bindkey '^r' percol-select-history

alias pd='percol-search-document'
alias pl='percol-search-locate'

alias -g P="| percol --match-method migemo"
