#
# Executes commands at login pre-zshrc
#

### Language ###
export LANG='ja_JP.UTF-8'
export LC_CTYPE='ja_JP.UTF-8'

### Editors ###
case "$OSTYPE" in
    darwin*)
        export EDITOR='/Applications/Emacs.app/Contents/MacOS/bin/emacsclient'
        export JAVA_HOME='/Applications/Android Studio.app/Contents/jbr/Contents/Home'
        export MANPAGER="sh -c 'col -bx | bat -l man -p'"
        ;;
    *)
        export EDITOR='vim'
        ;;
esac
export PAGER='less'
export LESS='--quit-if-one-screen --hilite-search --ignore-case --LONG-PROMPT --RAW-CONTROL-CHARS --chop-long-lines --hilite-unread --no-init --window=-5'

### Paths ###

# Ensure path arrays do not contain duplicates
typeset -gU path fpath cdpath

# Set the list of directories that Zsh searches for programs
path=(
    $HOME/.bin
    /opt/homebrew/{sbin,bin}
    /usr/local/{sbin,bin}
    /usr/{sbin,bin}
    /{sbin,bin}
    $path
)

fpath=(
    $HOME/.zsh/completions
    $fpath
)

# Set the list of directories that cd searches
cdpath=(
    $HOME
    $HOME/{Documents,Dropbox}
    $cdpath
)

# Homebrew
if (( $+commands[brew] )); then
    eval "$(brew shellenv)"
    path=(
        $(brew --prefix)/{sbin,bin}
        $(brew --prefix)/opt/{gnu-sed,gnu-tar,grep}/libexec/gnubin
        $path
    )
    fpath=(
        $(brew --prefix)/share/zsh-completions
        $(brew --prefix)/share/zsh/{functions,site-functions}
        $fpath
    )
fi

# Ruby
if (( $+commands[rbenv] )); then
    eval "$(rbenv init --no-rehash -)"
fi

# Python
if (( $+commands[pyenv] )); then
    eval "$(pyenv init --no-rehash -)"
fi

# Perl
if (( $+commands[plenv] )); then
    eval "$(plenv init --no-rehash -)"
fi

# Node
if (( $+commands[nodenv] )); then
    eval "$(nodenv init --no-rehash -)"
fi

# Scala
if (( $+commands[cs] )); then
    path=("$HOME/Library/Application Support/Coursier/bin" $path)
fi

# Android
if (( $+commands[brew] )); then
    export ANDROID_SDK_ROOT=$(brew --prefix)/share/android-sdk
    path=($ANDROID_SDK_ROOT/platform-tools $path)
fi

# Dart
if (( $+commands[fvm] )); then
    export FVM_HOME=$HOME/.fvm
    path=($HOME/.pub-cache/bin $FVM_HOME/default/bin $path)
fi

# Rust
if [ -f $HOME/.cargo/env ]; then
    source $HOME/.cargo/env
fi

# Go
if (( $+commands[go] )); then
    export GOPATH="$HOME/.go"
    path=($GOPATH/bin $path)
fi

# Rancher
if [ -d $HOME/.rd/bin ]; then
    path=($HOME/.rd/bin $path)
fi

# ghq
if (( $+commands[ghq] )); then
    export GHQ_ROOT="$HOME/Repos"
    cdpath=($GHQ_ROOT/github.com/rummelonp $cdpath)
    fpath=($GHQ_ROOT/github.com/rummelonp/zsh-completions/src $fpath)
fi
