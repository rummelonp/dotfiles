#
# Ruby
#

# ruby-build reads this only when compiling, but the `brew --prefix openssl@3` fork ran every shell.
if [[ -n $HOMEBREW_PREFIX ]]; then
    export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$HOMEBREW_PREFIX/opt/openssl@3"
fi

### Aliases ###
alias bi='bundle install'
alias bu='bundle update'
alias be='bundle exec'

### Functions ###
function bundle() {
    if [ -f bin/bundle ]; then
        bin/bundle "$@"
    else
        command bundle "$@"
    fi
}

# Assigning to functions[] defines these in-process; building the bodies as text forked a sub-shell each.
typeset _ruby_command
for _ruby_command in rails rake rspec parallel_rspec rubocop annotate; do
    functions[$_ruby_command]="
if [ -f bin/$_ruby_command ]; then
    bin/$_ruby_command \"\$@\"
elif [ -f Gemfile ]; then
    command bundle exec $_ruby_command \"\$@\"
else
    command $_ruby_command \"\$@\"
fi"
done
unset _ruby_command
