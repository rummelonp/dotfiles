## History
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# See http://memo.officebrook.net/20100224.html
setopt share_history
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_verify
setopt hist_reduce_blanks
setopt hist_no_functions
setopt inc_append_history

autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
