## Alias

# General
case $OSTYPE in
    darwin*)
        alias ls="ls -G"
        alias copy-pwd="pwd | perl -pe 's/\n//' | pbcopy"
        ;;
    linux*)
        alias ls="ls --color"
        ;;
esac

alias l="ls -1"
alias la="ls -1A"
alias ll="ls -1alF"

alias gr="grep"
alias gri="grep -i"
alias grl="grep -l"
export GREP_OPTIONS='--color=auto --exclude=*.git*'

alias rsync-copy="rsync -av --progress -h"
alias rsync-move="rsync -av --progress -h --remove-source-files"
alias rsync-update="rsync -avu --progress -h"
alias rsync-synchronize="rsync -avu --delete --progress -h"

alias du="du -h"
alias df="df -h"

alias h="history"

alias s="screen"
alias t="tmux"

alias g="git"
alias gs="git status"
alias ga="git add"
alias gd="git diff"
alias gc="git commit"

alias e="emacsclient -n"

# Ruby
alias irb="pry"

alias bi="bundle install"
alias bu="bundle update"
alias be="bundle exec"

alias r="rails"
alias rc="rails console"
alias rg="rails generate"
alias rs="rails server"

# Python
alias saba="python -m SimpleHTTPServer > /dev/null 2>&1 &"
alias shimesaba="pkill -f "python -m SimpleHTTPServer""

# Global
case $OSTYPE in
    darwin*)
        alias -g emacsclient="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient"
        alias -g E="| xargs emacsclient -n"
        alias -g O="| xargs open"
        alias -g C="| pbcopy"
        ;;
esac

alias -g L="| less"
alias -g H="| head"
alias -g T="| tail"
alias -g G="| grep"
alias -g S="| sed"
