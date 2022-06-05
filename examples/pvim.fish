function pvim
    set name "$(printf %s "$PWD" | sed 's|/||' | sed 's|/|_|g')"
    echo running container based on $name

    podman run --interactive --tty --rm --detach-keys='ctrl-_,_' --userns=keep-id \
        --mount "type=bind,source=$PWD,target=$HOME/workspace,relabel=private" \
        --mount "type=volume,source=pvim-cache-$name,target=$HOME/.venv,chown=true" \
        pvim:v0.7.0 $argv
end
