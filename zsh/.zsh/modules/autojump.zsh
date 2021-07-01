#
# Autojump
#

if [ -f /usr/share/autojump/autojump.zsh ]; then
    source /usr/share/autojump/autojump.zsh
elif [[ -f $(brew --prefix)/etc/profile.d/autojump.sh ]]; then
    source $(brew --prefix)/etc/profile.d/autojump.sh
fi
