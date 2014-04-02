## Environment

# Lang
export LANG=ja_JP.UTF-8

# Editor
case $OSTYPE in
    darwin*)
        export EDITOR=/Applications/Emacs.app/Contents/MacOS/bin/emacsclient
        ;;
    *)
        export EDITOR=vim
        ;;
esac

# Path
export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:$PATH

case $OSTYPE in
    darwin*)
        # Ruby
        export RBENV_ROOT=/usr/local/var/rbenv
        if which rbenv > /dev/null; then
            export PATH=$RBENV_ROOT/shims:$PATH
            eval "$(rbenv init -)";
        fi
        # Python
        export PYENV_ROOT=/usr/local/var/pyenv
        if which pyenv > /dev/null; then
            export PATH=$PYENV_ROOT/shims:$PATH
            eval "$(pyenv init -)"
        fi
        # Perl
        export PLENV_ROOT=/usr/local/var/plenv
        if which plenv > /dev/null; then
            export PATH=$PLENV_ROOT/shims:$PATH
            eval "$(plenv init -)";
        fi
        # Node
        export NODEBREW_ROOT=/usr/local/var/nodebrew
        export PATH=$NODEBREW_ROOT/current/bin:$PATH
        if which nodebrew > /dev/null; then
            export NODE_PATH=$NODEBREW_ROOT/node/$(nodebrew ls | tail -n1 | cut -d ' ' -f2)/lib/node_modules
        fi
        # Haskell
        export PATH=$HOME/.cabal/bin:$PATH
        # Gist
        export GISTY_DIR=$HOME/Dropbox/Gist
        ;;
esac

# Rsense
export RSENSE_HOME=$HOME/.emacs.d/el-get/rsense

typeset -U PATH
