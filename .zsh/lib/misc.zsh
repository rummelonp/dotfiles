## Misc

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
export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH
export RSENSE_HOME=$HOME/.emacs.d/el-get/rsense

# Environment
case $OSTYPE in
    darwin*)
        # Ruby
        eval "$(rbenv init -)"
        export RBENV_ROOT=/usr/local/opt/rbenv
        # Perl
        export PERLBREW_ROOT=/usr/local/perlbrew
        source $PERLBREW_ROOT/etc/bashrc
        # Node
        eval "$(npm completion)"
        export PATH=$PATH:/usr/local/share/npm/bin
        export NODE_PATH=/usr/local/share/npm/lib/node_modules
        # Android
        export ANDROID_HOME=/usr/local/var/lib/android-sdk
        # Gist
        export GISTY_DIR=$HOME/Dropbox/Gist
        ;;
    linux*)
        # Ruby
        export PATH=$PATH:/var/lib/gems/1.9.1/bin
        ;;
esac

# Grep
export GREP_OPTIONS='--color=auto --exclude=*.git*'
