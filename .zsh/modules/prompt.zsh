### Theme

## VCS Info
autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:*' unstagedstr '!'
zstyle ':vcs_info:*' formats '(%s) - [%b]'
zstyle ':vcs_info:*' actionformats '(%s) - [%b|%a]'
zstyle ':vcs_info:git:*' formats '(%s) - [%c%u%b]'
zstyle ':vcs_info:git:*' actionformats '(%s) - [%c%u%b|%a]'

## Hook
autoload -Uz add-zsh-hook

function _precmd-rprompt() {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    psvar[1]=$vcs_info_msg_0_
    if which rbenv > /dev/null; then
        psvar[2]=$(rbenv version | cut -d' ' -f1)
    fi
}
add-zsh-hook precmd _precmd-rprompt

## Prompt
autoload -Uz colors
colors

reset="%{${reset_color}%}"
green="%{${fg[green]}%}"
red="%{${fg[red]}%}"
blue="%{${fg[blue]}%}"
white="%{${fg[white]}%}"

if [ -n "$SSH_TTY" ]; then
    PROMPT="%(?|${green}（╹ω╹）|${red}（☓ω☓）)${green}%n@%m${white}:${blue}%~${reset}$ "
else
    PROMPT="%(?|${green}（╹ω╹）|${red}（☓ω☓）)${blue}%~${reset}$ "
fi
RPROMPT="%1(v|${green}%1v${reset} |)%2(v|${red}(%2v)${reset} |)"
SPROMPT='Correct "%R" to "%r" [n,y,a,e]? ' # no, yes, abort, edit

unset reset
unset green
unset red
unset blue
unset white
