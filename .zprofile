### Profile

## Language
export LANG=ja_JP.UTF-8

## Editors
case $OSTYPE in
    darwin*)
        export EDITOR=/Applications/Emacs.app/Contents/MacOS/bin/emacsclient
        ;;
    *)
        export EDITOR=vim
        ;;
esac
export PAGER=less

## Direnv
if which direnv > /dev/null; then
    eval "$(direnv hook zsh)"
fi

## Paths
typeset -g path fpath cdpath

path=(
    $HOME/bin
    /usr/local/{sbin,bin}
    /usr/{sbin,bin}
    /{sbin,bin}
    $path
)

fpath=(
    $HOME/.zsh/completions
    $fpath
)

cdpath=(
    $HOME
    $HOME/{Dropbox,Documents}
    $cdpath
)

case $OSTYPE in
    darwin*)
        # Ruby
        export RBENV_ROOT=/usr/local/var/rbenv
        if which rbenv > /dev/null; then
            eval "$(rbenv init -)"
        fi

        # Python
        export PYENV_ROOT=/usr/local/var/pyenv
        if which pyenv > /dev/null; then
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
        if which nodebrew > /dev/null; then
            export PATH=$NODEBREW_ROOT/current/bin:$PATH
            export NODE_PATH=$NODEBREW_ROOT/node/$(nodebrew ls | tail -n1 | cut -d ' ' -f2)/lib/node_modules
        fi
        if which npm > /dev/null; then
            eval "$(npm completion)"
        fi

        # Go
        export GOPATH=$HOME/go
        export PATH=$GOPATH/bin:$PATH

        # Android
        export ANDROID_HOME=/usr/local/opt/android-sdk

        # Gist
        export GISTY_DIR=$HOME/Dropbox/Gist
        ;;
esac

typeset -U path fpath cdpath
