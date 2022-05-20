# vim-config

Containerized vim setups

## Scala based nvim setup

### Create image

Go to [svim](svim) and run

```
docker build . --tag svim:v0.7.0 --build-arg "nvim_version=v0.7.0" --build-arg "username=$USER" --build-arg "sbt_opts=-Xmx8G -Xss4m"
```

### Use image

There is a [zsh example](examples/svim/svim.zsh). The svim
function will mount credentials and a workspace from the host machine,
and attach (or create) a volume for cached data.

You can use the image like this from a project root

```
svim path/to/file.scala
```
