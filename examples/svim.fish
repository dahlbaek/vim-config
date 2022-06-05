function svim
    set name "$(printf %s "$PWD" | sed 's|/||' | sed 's|/|_|g')"
    echo running container based on $name

    podman run --interactive --tty --rm --detach-keys='ctrl-_,_' --userns=keep-id \
        --mount "type=bind,readonly,source=$HOME/.sbt/1.0/sonatype.sbt,target=$HOME/.sbt/1.0/sonatype.sbt,chown=true" \
        --mount "type=volume,source=svim-cache,target=$HOME/.cache,relabel=private" \
        --mount "type=bind,source=$PWD,target=$HOME/workspace,chown=true" \
        svim:v0.7.0 $argv
end
