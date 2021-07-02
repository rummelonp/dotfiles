#
# Executes commands at login pre-zshrc
#

### Language ###
export LANG='ja_JP.UTF-8'

### Editors ###
case "$OSTYPE" in
    darwin*)
        export EDITOR='/Applications/Emacs.app/Contents/MacOS/bin/emacsclient'
        ;;
    *)
        export EDITOR='vim'
        ;;
esac
export PAGER='less'

### Direnv ###
if which direnv > /dev/null; then
    eval "$(direnv hook zsh)"
fi

### Paths ###
typeset -g path fpath cdpath

path=(
    $HOME/.bin
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

case "$OSTYPE" in
    darwin*)
        # Homebrew
        if which brew > /dev/null; then
            eval "$(brew shellenv)"
        fi
        export PATH=$(brew --prefix)/opt/grep/libexec/gnubin:$PATH

        # Ruby
        if which rbenv > /dev/null; then
            eval "$(rbenv init -)"
        fi

        # Python
        if which pyenv > /dev/null; then
            eval "$(pyenv init -)"
        fi

        # Node
        if which nodenv > /dev/null; then
            eval "$(nodenv init -)";
        fi

        # Go
        export GOPATH=$HOME/.go
        export PATH=$GOPATH/bin:$PATH

        # Android
        export ANDROID_SDK_ROOT=$(brew --prefix)/share/android-sdk
        export PATH=$ANDROID_SDK_ROOT/platform-tools:$PATH
        ;;
esac

typeset -U path fpath cdpath
