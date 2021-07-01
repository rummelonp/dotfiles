#
# Sets completion options
#

autoload -Uz compinit
compinit -i

### Options ###
setopt always_to_end     # Move cursor to the end of a completed word.
setopt complete_in_word  # Complete from both ends of a word.
setopt auto_list         # Automatically list choices on ambiguous completion.
setopt auto_menu         # Show completion menu on a successive tab press.
setopt auto_param_slash  # If completed parameter is a directory, add a trailing slash.
unsetopt flow_control    # Disable start/stop characters in shell editor.
unsetopt menu_complete   # Do not autoselect the first completion entry.

### Word separator ###
autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars ' ,-./:;=@_'
zstyle ':zle:*' word-style unspecified

#### Cache ### ###
zstyle ':completion:*' use-cache on

### Group matches and describe ###
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:warnings' format '%B%F{red}No matches for: %d%f'
zstyle ':completion:*' format '%B%F{cyan}%d%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes

### Don't complete unavailable commands ###
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'

### Directory ###
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
unsetopt case_glob
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*' squeeze-slashes true

### Ignore multiple entries ###
zstyle ':completion:*:(rm|kill|diff|colordiff):*' ignore-line other
zstyle ':completion:*:rm:*' file-patterns '*:all-files'

### Process ###
zstyle ':completion:*:*:*:*:processes' command 'ps -u $USER -o pid,user,command -w'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*' insert-ids single

### Hostname ###
[ -r /etc/ssh/ssh_known_hosts ] && _global_ssh_hosts=(${${${${(f)"$(</etc/ssh/ssh_known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _global_ssh_hosts=()
[ -r ~/.ssh/known_hosts ] && _ssh_hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
[ -r /etc/hosts ] && : ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}} || _etc_hosts=()
hosts=(
    "$_global_ssh_hosts[@]"
    "$_ssh_hosts[@]"
    "$_etc_hosts[@]"
    "$HOST"
    localhost
)

zstyle ':completion:*:hosts' hosts $hosts

### User ###
zstyle ':completion:*:*:*:users' ignored-patterns \
       adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
       dbus distcache dovecot fax ftp games gdm gkrellmd gopher \
       hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
       mailman mailnull mldonkey mysql nagios \
       named netdump news nfsnobody nobody nscd ntp nut nx openvpn \
       operator pcap postfix postgres privoxy pulse pvm quagga radvd \
       rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs '_*'
