#
# Loads prompt themes
#

### VCS Info ###
autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:*' unstagedstr '!'
zstyle ':vcs_info:*' formats '[%b]'
zstyle ':vcs_info:*' actionformats '[%b|%a]'
zstyle ':vcs_info:git:*' formats '[%c%u%b]'
zstyle ':vcs_info:git:*' actionformats '[%c%u%b|%a]'

### Hook ###
autoload -Uz add-zsh-hook

function _precmd-rprompt() {
    LANG=en_US.UTF-8 vcs_info
    psvar[1]=$vcs_info_msg_0_
}
add-zsh-hook precmd _precmd-rprompt

function _chpwd-rprompt() {
    if (( $+commands[rbenv] )); then
        psvar[2]=$(rbenv version | cut -d' ' -f1)
    fi
    if (( $+commands[plenv] )); then
        psvar[3]=$(plenv version | cut -d' ' -f1)
    fi
    if (( $+commands[nodenv] )); then
        psvar[4]=$(nodenv version | cut -d ' ' -f1)
    fi
}
add-zsh-hook chpwd _chpwd-rprompt

psvar=()
_chpwd-rprompt

### Prompt ###
autoload -Uz colors
colors

reset="%{${reset_color}%}"
red="%{${fg[red]}%}"
green="%{${fg[green]}%}"
magenta="%{${fg[magenta]}%}"
cyan="%{${fg[cyan]}%}"
white="%{${fg[white]}%}"

if [ -n "$SSH_TTY" -o "$USER" = 'root' ]; then
    PROMPT="%(?|${green}（╹ω╹）|${red}（☓ω☓）)${green}%n@%m${white}:${cyan}%~${reset}$ "
else
    PROMPT="%(?|${green}（╹ω╹）|${red}（☓ω☓）)${cyan}%~${reset}$ "
fi
RPROMPT="%1(v|${green}%1v${reset} |)%2(v|${red}(%2v)${reset} |)%3(v|${magenta}(%3v)${reset} |)%4(v|${cyan}(%4v)${reset} |)"
SPROMPT='Correct "%R" to "%r" [n,y,a,e]? ' # no, yes, abort, edit

unset reset
unset red
unset green
unset magenta
unset cyan
unset white
