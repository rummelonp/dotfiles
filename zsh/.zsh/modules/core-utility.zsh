#
# Defines general aliases and functions
#

### Correction ###
setopt CORRECT

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

alias grep='grep --color=auto --exclude-dir=.git'
alias less='less --raw-control-chars'

alias du='du -h'
alias dur='dust'
alias dui='ncdu'

alias df='df -h'
alias dfr='duf'

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
alias v='view'
alias b='bat'
alias d='diff'
alias e='emacsclient --no-wait'
alias i='studio'
alias c='code'
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
        ;;
esac

alias -g G='| grep'
alias -g L='| less'
alias -g B='| bat'
