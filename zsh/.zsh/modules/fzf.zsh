#
# Fuzzy finder
#

if ! which fzf > /dev/null; then
    return
fi

### Default options ###
export FZF_DEFAULT_OPTS="
    --no-height
    --layout=reverse
    --marker='*'
    --exact
    --no-sort
    --color hl:magenta
    --color hl+:cyan
    --color bg+:black
    --color info:cyan
    --color prompt:cyan
    --color pointer:cyan
    --color marker:magenta
    --bind ctrl-alt-f:forward-word
    --bind ctrl-alt-b:backward-word
    --bind ctrl-k:kill-line
    --bind ctrl-u:clear-query
    --bind ctrl-space:select+down
    --bind ctrl-alt-a:select-all
    --bind ctrl-alt-e:deselect-all
    --bind ctrl-g:clear-selection
    --bind ctrl-v:page-down
    --bind alt-v:page-up
    --bind ctrl-alt-v:page-up
    --bind right:page-down
    --bind left:page-up
    --bind home:first
    --bind end:last
    --bind ctrl-r:toggle-sort
    --bind ?:toggle-preview
    --bind ctrl-z:ignore
"

### Key bindings ###
function _fzf-history() {
    local cmd=$(history -n 1 | fzf --tac --query "$LBUFFER" | sed 's|\\n|\n|g')
    [[ -z "$cmd" ]] && return 0
    BUFFER="$cmd"
    CURSOR=$#BUFFER
    zle reset-prompt
}

function _fzf-ghq() {
    local dir=$(ghq list \
                    | fzf --sort \
                          --preview 'cd $(ghq root)/{} && ([[ -f README.md ]] && bat --color=always README.md) || ls --color' \
                          --query "$LBUFFER" \
                    | sed -e "s|^|$(ghq root)/|g" -e "s|$HOME|~|g")
    [[ -z "$dir" ]] && return 0
    BUFFER="cd $dir"
    zle accept-line
    zle reset-prompt
}

function _fzf-cd() {
    local dir=$(fzf-dir --base-directory=.)
    [[ -z "$dir" ]] && return 0
    BUFFER="cd $dir"
    zle accept-line
    zle reset-prompt
}

function _fzf-file() {
    LBUFFER="${LBUFFER}$(fzf-file --base-directory=.)"
    zle reset-prompt
}

zle -N _fzf-history
zle -N _fzf-ghq
zle -N _fzf-cd
zle -N _fzf-file

bindkey '^r'   _fzf-history
bindkey '^x^a' _fzf-ghq
bindkey '^x^b' _fzf-cd
bindkey '^x^f' _fzf-file

### Functions ###
function fzf-dir() {
    local -a args
    local root is_git
    _fzf-fd-setup "$@"

    local cmd="fd --strip-cwd-prefix --follow --type directory --base-directory='$root'"
    if (( $is_git == 0 )); then
        cmd+=" --hidden --exclude=.git $args | sort"
    else
        cmd+=" --exclude=Library $args"
    fi

    local dir=$(eval "$cmd" | fzf --sort --preview "cd \"$root\" && ls --color {}" --query "$LBUFFER")
    [[ -z "$dir" ]] && return 0

    dir=$(_fzf-normalize-path "$root" "$dir")
    echo "$dir"
}

function fzf-file() {
    local -a args
    local root is_git
    _fzf-fd-setup "$@"

    local cmd="fd --strip-cwd-prefix --follow --type file --type symlink --base-directory='$root'"
    if (( $is_git == 0 )); then
        cmd+=" --hidden --exclude=.git $args | sort"
    else
        cmd+=" --exclude=Library $args"
    fi
    local filter="fzf --multi --sort --preview 'cd \"$root\" && bat --style=plain --color=always {}'"

    local file
    eval "$cmd | $filter" | while read file; do
        file=$(_fzf-normalize-path "$root" "$file")
        echo -n "$file "
    done
    echo
}

function fzf-doc() {
    fzf-file --exclude="$(basename "$(ghq root)")" \
             -e md -e pdf \
             -e numbers -e xlsx -e xls \
             -e key -e pptx -e ppt \
             -e pages -e docx -e doc \
             "$@"
}

function fdir()  { fzf-dir  "$@"; }
function ffile() { fzf-file "$@"; }
function fdoc()  { fzf-doc  "$@"; }

compdef _fd fzf-dir fzf-file fzf-doc fdir ffile fdoc

### Helper functions ###
function _fzf-fd-setup() {
    while (( $# > 0 )); do
        case "$1" in
            --base-directory)
                root="$2"
                shift
                ;;
            --base-directory=*)
                root="${1/--base-directory=}"
                ;;
            *)
                args=($args $1)
                ;;
        esac
        shift
    done

    root=$(eval "realpath $(_fzf-escape-path "${root:-.}")")

    (cd "$root" && git rev-parse --is-inside-work-tree > /dev/null 2>&1)
    is_git=$?
}

function _fzf-escape-path() {
    echo "$@" | sed 's| |\\ |g'
}

function _fzf-normalize-path() {
    if (( $is_git == 0 )); then
        _fzf-escape-path "$2"
    else
        _fzf-escape-path $(echo "$1/$2" | sed "s|$HOME|~|g")
    fi
}

### Aliases ###
alias -g F='| fzf'
