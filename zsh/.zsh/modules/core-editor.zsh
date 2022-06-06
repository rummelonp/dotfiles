#
# Sets key bindings
#

# Emacs key layout
bindkey -e

# History
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

bindkey '^p' history-beginning-search-backward-end
bindkey '^n' history-beginning-search-forward-end

# Redo
bindkey '^[_' redo
