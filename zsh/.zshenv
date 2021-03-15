### Environment

## Ensure that a non-login, non-interactive shell has a defined environment
if [[ $SHLVL -eq 1 && ! -o LOGIN ]]; then
    source $HOME/.zprofile
fi
