#
# Ruby
#

alias bi='bundle install'
alias bu='bundle update'
alias be='bundle exec'

function _ruby_command_bin() {
    typeset cmd=$1
    <<EOF
function ${cmd}() {
    if [ -f bin/${cmd} ]; then
        bin/${cmd} "\$@"
    else
        \$(rbenv root)/shims/${cmd} "\$@"
    fi
}
EOF
}

function _ruby_command_bundle() {
    typeset cmd=$1
    <<EOF
function ${cmd}() {
    if [ -f Gemfile ]; then
        bundle exec ${cmd} "\$@"
    else
        \$(rbenv root)/shims/${cmd} "\$@"
    fi
}
EOF
}

eval "$(_ruby_command_bin rails)"
eval "$(_ruby_command_bin rake)"
eval "$(_ruby_command_bundle rspec)"
eval "$(_ruby_command_bundle rubocop)"
