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
    /opt/homebrew/{opt,sbin,bin}
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
        # Homebrew
        if which brew > /dev/null; then
            eval "$(brew shellenv)"
        fi

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
        export NODENV_ROOT=/usr/local/var/nodenv
        if which nodenv > /dev/null; then
            export PATH=$NODENV_ROOT/shims:$PATH
            eval "$(nodenv init -)";
        fi

        # Go
        export GOPATH=/usr/local/var/go
        export PATH=$GOPATH/bin:$PATH

        # Android
        export ANDROID_SDK_ROOT=/usr/local/share/android-sdk
        export ANDROID_NDK_ROOT=/usr/local/share/android-ndk
        export PATH=$ANDROID_SDK_ROOT/platform-tools:$PATH
        ;;
esac

typeset -U path fpath cdpath
