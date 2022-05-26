gvim () {
        name=$(printf "%s" "$PWD" | sed 's|/||' | sed 's|/|_|g')
        echo "running container based on $name"

        docker run --interactive --tty --rm --detach-keys='ctrl-_,_' \
                --mount "type=bind,source=$PWD,target=$HOME/workspace" \
                --mount "type=volume,source=gvim-cache,target=$HOME/go" \
                gvim:v0.7.0 "$@"
}
