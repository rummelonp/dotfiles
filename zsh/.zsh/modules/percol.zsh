#
# Percol
#

if ! which percol > /dev/null; then
    return
fi

### Key bindings ###
function percol-select-history() {
    typeset tac
    if which tac > /dev/null; then
        tac=tac
    else
        tac='tail -r'
    fi
    BUFFER=$(history -n 1 | eval $tac | percol --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle -R -c
}

function percol-cd-ghq() {
    BUFFER=$(ghq list | percol --query "$LBUFFER" |
                 sed -e "s|^|${GHQ_ROOT}/|g" -e "s|${HOME}|~|g" -e 's| |\\ |g')
    zle accept-line
    zle -R -c
}

zle -N percol-select-history
zle -N percol-cd-ghq

bindkey '^r' percol-select-history
bindkey '^s' percol-cd-ghq

### Functions ###

# ppgrep -- find processes by name
# ppgrep [query ...]
function ppgrep() {
    typeset percol
    if (( $# > 0 )); then
        percol="percol --query '$@'"
    else
        percol='percol'
    fi
    SELECTED_PID=($(ps aux | eval $percol | awk '{ print $2 }'))
    if (( $#SELECTED_PID > 0 )); then
        echo $SELECTED_PID
    fi
}

# ppkill -- signal processes by name
# ppkill [-s signal_name] [query ...]
function ppkill() {
    typeset query
    typeset signal
    while [ $1 ]; do
        case $1 in
            -s)
                signal="-s $2"
                shift
                ;;
            *)
                query="$query $1"
                ;;
        esac
        shift
    done
    eval "ppgrep $query | xargs kill $signal"
}

# pdoc -- find documents
# pdoc [path ...]
function pdoc() {
    typeset -aU document_dir
    [ -d $HOME/Documents ] && document_dir=($HOME/Documents $document_dir[*])
    [ -d $HOME/Dropbox   ] && document_dir=($HOME/Dropbox   $document_dir[*])
    typeset -aU paths
    if (( $# > 0 )); then
        paths=($@)
    else
        paths=($document_dir)
    fi
    SELECTED_FILE=(
        $(fd '.+\.(md|pdf|key|numbers|pages|pptx?|xlsx?|docx?)$' $paths |
              sed -e "s|${HOME}|~|" |
              sort |
              percol --match-method=migemo |
              sed 's| |\\ |g'
        )
    )
    if (( $#SELECTED_FILE > 0 )); then
        echo $SELECTED_FILE
    fi
}

### Aliases ###
alias -g P='| percol'
