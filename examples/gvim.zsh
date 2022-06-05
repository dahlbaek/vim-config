gvim () {
        name=$(printf "%s" "$PWD" | sed 's|/||' | sed 's|/|_|g')
        echo "running container based on $name"

        podman run --interactive --tty --rm --detach-keys='ctrl-_,_' --userns=keep-id \
                --mount "type=bind,source=$PWD,target=$HOME/workspace,relabel=private" \
                --mount "type=volume,source=gvim-cache,target=$HOME/go,chown=true" \
                gvim:v0.7.0 "$@"
}
