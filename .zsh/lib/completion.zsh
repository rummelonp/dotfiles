## Completion
autoload -U compinit
compinit -u

zmodload -i zsh/complist

# See http://www.ayu.ics.keio.ac.jp/~mukai/translate/zshoptions.html
unsetopt menu_complete
unsetopt flowcontrol
unsetopt auto_remove_slash
unsetopt list_beep
setopt auto_menu
setopt complete_in_word
setopt always_to_end
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt list_packed
setopt list_types
setopt auto_list
setopt magic_equal_subst
setopt auto_param_keys
setopt auto_param_slash
setopt brace_ccl
setopt multios
setopt path_dirs
setopt complete_aliases

# See http://d.hatena.ne.jp/sugyan/20100712/1278869962
autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars " _-./;@"
zstyle ':zle:*' word-style unspecified

# See http://d.hatena.ne.jp/lurker/20061231/1167570929
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

# Messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*' format '%B%d%b'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

# File
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors di=34 fi=0
zstyle ':completion:*:*:*:*:*' menu select

# Directory
# See http://voidy21.hatenablog.jp/entry/20090902/1251918174
cdpath=($HOME/ $HOME/Documents $HOME/Dropbox)
zstyle ':completion:*:cd:*' tag-order local-directories path-directories
zstyle ':completion:*:cd:*' ignore-parents parent pwd

# Process
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u `whoami` -o pid,user,comm -w -w"

# Hostname
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

# User
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
        dbus distcache dovecot fax ftp games gdm gkrellmd gopher \
        hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
        mailman mailnull mldonkey mysql nagios \
        named netdump news nfsnobody nobody nscd ntp nut nx openvpn \
        operator pcap postfix postgres privoxy pulse pvm quagga radvd \
        rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs \
        _amavisd _appleevents _appowner _appserver _ard _assetcache \
        _atsserver _avbdeviced _calendar _ces _clamav _coreaudiod \
        _cvmsroot _cvs _cyrus _devdocs _devicemgr _dovecot _dovenull \
        _dpaudio _eppc _ftp _geod _installassistant _installer _jabber \
        _kadmin_admin _kadmin_changepw _krb_anonymous _krb_changepw \
        _krb_kadmin _krb_kerberos _krb_krbtgt _krbtgt _lda _locationd \
        _lp _mailman _mcxalr _mdnsresponder _mysql _netbios \
        _netstatistics _networkd _pcastagent _pcastlibrary _pcastserver \
        _postfix _postgres _qtss _sandbox _screensaver _scsd \
        _securityagent _serialnumberd _softwareupdate _spotlight \
        _sshd _svn _taskgated _teamsserver _timezone _tokend \
        _trustevaluationagent _unknown _update_sharing _usbmuxd _uucp \
        _warmd _webauthserver _windowserver _www _xgridagent _xgridcontroller
