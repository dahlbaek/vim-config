svim () {
        name=$(printf "%s" "$PWD" | sed 's|/||' | sed 's|/|_|g')
        echo "running container based on $name"

        docker run --interactive --tty --rm --detach-keys='ctrl-_,_' \
                --mount "type=bind,readonly,source=$HOME/.sbt/1.0/sonatype.sbt,target=$HOME/.sbt/1.0/sonatype.sbt" \
                --mount "type=volume,source=svim-cache,target=$HOME/.cache" \
                --mount "type=bind,source="$PWD",target=$HOME/workspace" \
                nvim:v0.7.0 "$@"
}
