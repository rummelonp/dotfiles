### Aliases

## General
case $OSTYPE in
    darwin*)
        alias ls='ls -G'
        ;;
    linux*)
        alias ls='ls --color'
        ;;
esac

# With options
alias grep='grep --color=auto --exclude-dir=.git --exclude-dir=.svn'
alias less='less --raw-control-chars'
alias du='du -h'
alias df='df -h'

# Shorthand
alias l='ls -1'
alias la='ls -1A'
alias ll='ls -1alF'

alias gr='grep --line-number'
alias gri='grep --line-number --ignore-case'
alias grl='grep --files-without-match'
alias gril='grep --ignore-case --files-without-match'
alias grli='grep --ignore-case --files-without-match'

alias diff=colordiff

alias g=git
alias t=tmux
alias h=history
alias e='emacsclient --no-wait'

alias netstat-all='lsof -nP -iTCP'
alias netstat-listen='lsof -nP -iTCP -sTCP:LISTEN'

## Global
case $OSTYPE in
    darwin*)
        alias -g emacsclient='/Applications/Emacs.app/Contents/MacOS/bin/emacsclient'
        alias -g E='| xargs emacsclient --no-wait'
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

## Ruby
alias irb=pry

alias b=b
alias bi='bundle install'
alias bu='bundle update'
alias be='bundle exec'

## Python
alias saba='python -m SimpleHTTPServer > /dev/null 2>&1 &'
alias shimesaba='pkill -f "python -m SimpleHTTPServer"'
