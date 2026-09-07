#
# Fuzzy finder
#

if (( ! $+commands[fzf] )); then
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
    --bind ctrl-d:preview-page-down
    --bind ctrl-u:preview-page-up
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

function _fzf-gitmoji() {
    local emoji=$(gitmoji -l | fzf | cut -d' ' -f1)
    echo -n "$emoji" | pbcopy
    LBUFFER="${LBUFFER}${emoji}"
    zle reset-prompt
}

zle -N _fzf-history
zle -N _fzf-ghq
zle -N _fzf-cd
zle -N _fzf-file
zle -N _fzf-gitmoji

bindkey '^r'   _fzf-history
bindkey '^x^a' _fzf-ghq
bindkey '^x^b' _fzf-cd
bindkey '^x^f' _fzf-file
bindkey '^x^g' _fzf-gitmoji

### Functions ###
function fzf-dir() {
    local -a args
    local root is_git
    _fzf-fd-setup "$@"

    local -a cmd=(fd --strip-cwd-prefix --follow --type directory --base-directory "$root")
    local -a finder=(fzf --sort --preview "cd ${(q)root} && ls --color {}" --query "$LBUFFER")

    local dir
    if (( $is_git == 0 )); then
        cmd+=(--hidden --exclude=.git "${args[@]}")
        dir=$("${cmd[@]}" | sort | "${finder[@]}")
    else
        cmd+=(--exclude=Library "${args[@]}")
        dir=$("${cmd[@]}" | "${finder[@]}")
    fi
    [[ -z "$dir" ]] && return 0

    dir=$(_fzf-normalize-path "$root" "$dir")
    print -r -- "$dir"
}

function fzf-file() {
    local -a args
    local root is_git
    _fzf-fd-setup "$@"

    local -a cmd=(fd --strip-cwd-prefix --follow --type file --type symlink --base-directory "$root")
    local -a finder=(fzf --multi --sort --preview "cd ${(q)root} && bat --style=plain --color=always {}")

    local file
    if (( $is_git == 0 )); then
        cmd+=(--hidden --exclude=.git "${args[@]}")
        "${cmd[@]}" | sort | "${finder[@]}"
    else
        cmd+=(--exclude=Library "${args[@]}")
        "${cmd[@]}" | "${finder[@]}"
    fi | while IFS= read -r file; do
        file=$(_fzf-normalize-path "$root" "$file")
        print -rn -- "$file "
    done
    print
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
                args+=("$1")
                ;;
        esac
        shift
    done

    root=$(realpath -- "${root:-.}")

    (cd "$root" && git rev-parse --is-inside-work-tree > /dev/null 2>&1)
    is_git=$?
}

# The result is appended to LBUFFER, so it has to survive being re-parsed by the
# shell. Only the ~ that stands in for $HOME is left unquoted, and it is
# prepended after quoting so a path that merely contains ~ stays literal.
function _fzf-normalize-path() {
    if (( $is_git == 0 )); then
        print -r -- "${(q)2}"
        return
    fi

    local full="$1/$2"
    if [[ "$full" != "$HOME" && "$full" != "$HOME"/* ]]; then
        print -r -- "${(q)full}"
        return
    fi

    local rest="${full#"$HOME"}"
    rest="${rest#/}"
    print -r -- "~${rest:+/${(q)rest}}"
}

### Aliases ###
alias -g F='| fzf'
