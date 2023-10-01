#
# Ruby
#

export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@3)"

### Aliases ###
alias bi='bundle install'
alias bu='bundle update'
alias be='bundle exec'

### Functions ###
function _ruby_command() {
    typeset cmd=$1
    <<EOF
function ${cmd}() {
    if [ -f bin/${cmd} ]; then
        bin/${cmd} "\$@"
    elif [ -f Gemfile ]; then
        command bundle exec ${cmd} "\$@"
    else
        command ${cmd} "\$@"
    fi
}
EOF
}

function bundle() {
    if [ -f bin/bundle ]; then
        bin/bundle "$@"
    else
        command bundle "$@"
    fi
}

eval "$(_ruby_command rails)"
eval "$(_ruby_command rake)"
eval "$(_ruby_command rspec)"
eval "$(_ruby_command parallel_rspec)"
eval "$(_ruby_command rubocop)"
eval "$(_ruby_command annotate)"
