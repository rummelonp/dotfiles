### Percol

if ! which percol > /dev/null; then
    return
fi

## Key bind
function percol-select-history() {
    typeset tac
    if which tac > /dev/null; then
        tac=tac
    else
        tac='tail -r'
    fi
    BUFFER=$(fc -l -n 1 | eval $tac | percol --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle -R -c
}
zle -N percol-select-history

bindkey '^r' percol-select-history

## Functions
# ppgrep -- find or signal processes by name
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

# ppkill -- terminate or signal a process
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

# plocate -- find filenames
# plocate [pattern ...]
function plocate() {
    if (( $# > 0 )); then
        SELECTED_FILE=($(locate $@ | percol | sed 's/ /\\ /g'))
        if (( $#SELECTED_FILE > 0 )); then
            echo $SELECTED_FILE
        fi
    else
        echo 'Usage: plocate [pattern ...]'
    fi
}

# pdoc -- find document
# pdoc [path ...]
function pdoc() {
    if (( $#DOCUMENT_DIR == 0 )); then
        if [ -d $HOME/Documents ]; then
            DOCUMENT_DIR=($HOME/Documents)
        fi
        if [ -d $HOME/Dropbox ]; then
            DOCUMENT_DIR=($HOME/Dropbox $DOCUMENT_DIR[*])
        fi
    fi
    typeset -a paths
    if (( $# > 0 )); then
        paths=($@)
    else
        paths=($DOCUMENT_DIR)
    fi
    SELECTED_FILE=($(find $paths | grep -E '\.(txt|md|pdf|numbers|key|pages|docx?|xlsx?|pptx?)$' | percol | sed 's/ /\\ /g'))
    if (( $#SELECTED_FILE > 0 )); then
        echo $SELECTED_FILE
    fi
}

## Aliases
alias -g P='| percol'
