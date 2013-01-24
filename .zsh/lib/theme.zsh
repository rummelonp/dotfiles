## Theme

# Color
autoload -Uz colors
colors

RESET="%{${reset_color}%}"
GREEN="%{${fg[green]}%}"
BLUE="%{${fg[blue]}%}"
RED="%{${fg[red]}%}"
CYAN="%{${fg[cyan]}%}"
WHITE="%{${fg[white]}%}"
BASE_COLOR=""

case $OSTYPE in
    darwin*)
        BASE_COLOR=$CYAN
        ;;
    *)
        BASE_COLOR=$GREEN
        ;;
esac

# Prompt
autoload -Uz add-zsh-hook
autoload -Uz vcs_info

function _precmd_rprompt () {
  psvar=()
  LANG=en_US.UTF-8 vcs_info
  psvar[1]=$vcs_info_msg_0_
  if which rbenv > /dev/null; then
      psvar[2]=$(rbenv version | cut -d' ' -f1)
  fi
}
add-zsh-hook precmd _precmd_rprompt

zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr "+"
zstyle ':vcs_info:*' unstagedstr "!"
zstyle ':vcs_info:*' formats '(%s) - [%b]'
zstyle ':vcs_info:*' actionformats '(%s) - [%b|%a]'
zstyle ':vcs_info:git:*' formats '(%s) - [%c%u%b]'
zstyle ':vcs_info:git:*' actionformats '(%s) - [%c%u%b|%a]'

PROMPT="%(?|${GREEN}（･ω･）|${RED}（☓ω☓）)${BASE_COLOR}%n@%m${WHITE}:${BLUE}%~${RESET}$ "
RPROMPT="%1(v|${GREEN}%1v${RESET} |)%2(v|${RED}(%2v)${RESET} |)(%*)"
SPROMPT="Correct '%R' to '%r' [n,y,a,e]? " # no, yes, abort, edit
