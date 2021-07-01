#
# Provides for an easier use of SSH by setting up ssh-agent
#

if (( ! $+commands[ssh-agent] )); then
    return 1
fi

if ssh-add -l 2>&1 | grep -q 'The agent has no identities'; then
    ssh-add $HOME/.ssh/id_rsa 2> /dev/null
fi
