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
        export JAVA_HOME='/Applications/Android Studio.app/Contents/jre/Contents/Home/'
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

# Scala
if (( $+commands[cs] )); then
    path=("$HOME/Library/Application Support/Coursier/bin" $path)
fi

# Ruby
if (( $+commands[rbenv] )); then
    eval "$(rbenv init -)"
fi

# Python
if (( $+commands[pyenv] )); then
    eval "$(pyenv init --path)"
    eval "$(pip completion --zsh)"
fi

# Node
if (( $+commands[nodenv] )); then
    eval "$(nodenv init -)"
    eval "$(npm completion --zsh)"
fi

# Go
if (( $+commands[go] )); then
    export GOPATH="$HOME/.go"
    path=($GOPATH/bin $path)
fi

# Android
if (( $+commands[brew] )); then
    export ANDROID_SDK_ROOT=$(brew --prefix)/share/android-sdk
    path=($ANDROID_SDK_ROOT/platform-tools $path)
fi

# Direnv
if (( $+commands[direnv] )); then
    eval "$(direnv hook zsh)"
fi
