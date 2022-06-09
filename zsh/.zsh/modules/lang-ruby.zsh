#
# Ruby
#

alias bi='bundle install'
alias bu='bundle update'
alias be='bundle exec'

function _ruby_command() {
    typeset cmd=$1
    <<EOF
function ${cmd}() {
    if [ -f bin/${cmd} ]; then
        bin/${cmd} "\$@"
    elif [ -f Gemfile ]; then
        bundle exec ${cmd} "\$@"
    else
        \$(rbenv root)/shims/${cmd} "\$@"
    fi
}
EOF
}

eval "$(_ruby_command bundle)"
eval "$(_ruby_command rails)"
eval "$(_ruby_command rake)"
eval "$(_ruby_command rspec)"
eval "$(_ruby_command parallel_rspec)"
eval "$(_ruby_command rubocop)"
eval "$(_ruby_command annotate)"
