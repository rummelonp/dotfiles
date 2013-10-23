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
export RSENSE_HOME=$HOME/.emacs.d/el-get/rsense

case $OSTYPE in
    darwin*)
        # Ruby / rbenv
        export RBENV_ROOT=/usr/local/var/rbenv
        if which rbenv > /dev/null; then
            eval "$(rbenv init -)";
        fi
        # Python / pyenv
        export PYENV_ROOT=/usr/local/opt/pyenv
        if which pyenv > /dev/null; then
            eval "$(pyenv init -)"
        fi
        # Perl / plenv
        if which plenv > /dev/null; then
            eval "$(plenv init -)";
        fi
        # Node / nodebrew
        export PATH=$HOME/.nodebrew/current/bin:$PATH
        # Haskell
        export PATH=$HOME/.cabal/bin:$PATH
        # MySQL / mysqlenv
        if [ -f $HOME/.mysqlenv/etc/bashrc ]; then
            source $HOME/.mysqlenv/etc/bashrc
        fi
        # Android
        export ANDROID_SDK_ROOT=/usr/local/opt/android-sdk
        # Gist
        export GISTY_DIR=$HOME/Dropbox/Gist
        ;;
esac

typeset -U PATH
