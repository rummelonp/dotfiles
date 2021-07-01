#
# Defines general aliases and functions
#

### Correction ###
setopt correct

alias cp='nocorrect cp'
alias exec='nocorrect exec'
alias git='nocorrect git'
alias man='nocorrect man'
alias mkdir='nocorrect mkdir'
alias mv='nocorrect mv'
alias which='nocorrect which'

### Aliases ###

# LS color
export LSCOLORS='gxfxcxdxbxegedabagacad'
export LS_COLORS='di=36:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

# With options
case $OSTYPE in
    darwin*)
        alias ls='ls -G'
        ;;
    linux*)
        alias ls='ls --color'
        ;;
esac

alias grep='grep --color=auto --exclude-dir=.git --exclude-dir=.svn'
alias less='less --raw-control-chars'
alias du='du -h'
alias df='df -h'

# Shorthand
alias ..='cd ..'
alias ...='cd ../..'

alias l='ls -1'
alias la='ls -1A'
alias ll='ls -1alF'

alias gr='grep --line-number'
alias gri='grep --line-number --ignore-case'
alias grl='grep --files-without-match'
alias gril='grep --ignore-case --files-without-match'
alias grli='grep --ignore-case --files-without-match'

alias diff='colordiff'

alias g='git'
alias t='tmux'
alias d='diff'
alias h='history'
alias v='view'
alias e='emacsclient --no-wait'
alias i='studio'
alias o='open'

alias netstat-all='lsof -nP -iTCP'
alias netstat-listen='lsof -nP -iTCP -sTCP:LISTEN'

### Global ###
case $OSTYPE in
    darwin*)
        alias -g emacsclient='/Applications/Emacs.app/Contents/MacOS/bin/emacsclient'
        alias -g E='| xargs emacsclient --no-wait'
        alias -g I='| xargs -n10 studio'
        alias -g O='| xargs open'
        alias -g C='| pbcopy'
        alias -g S='| gsed'
        ;;
    *)
        alias -g S='| sed'
        ;;
esac

alias -g G='| grep'
alias -g L='| less'
alias -g H='| head'
alias -g T='| tail'

### Ruby ###
alias bi='bundle install'
alias bu='bundle update'
alias be='bundle exec'

### Python ###
alias saba='python -m http.server > /dev/null 2>&1 &'
alias shimesaba='pkill -f "python -m http.server"'

### Functions ###
function take() {
    mkdir -p $1
    cd $1
}
