# vim-config

Containerized vim setups

## Scala based nvim setup

### Create image

Go to [svim](svim) and run

```
docker build . \
  --tag svim:v0.7.0 \
  --build-arg nvim_version=333ba6569d833e22c0d291547d740d4bbfa3fdab \
  --build-arg nvim_lspconfig_version=99596a8cabb050c6eab2c049e9acde48f42aafa4 \
  --build-arg "username=$USER" \
  --build-arg "sbt_opts=-Xmx8G -Xss4m"
```

### Use image

There is a [zsh example](examples/svim/svim.zsh). The svim
function will mount credentials and a workspace from the host machine,
and attach (or create) a volume for cached data.

You can use the image like this from a project root

```
svim path/to/file.scala
```

Inside vim, there is a custom command `Metals` available to make it easier to run
metals related lsp commands. For intance, if you want to change the build server,
you can do

```
:Metals bsp-switch
```

## Python based nvim setup

### Create image

Go to [pvim](pvim) and run

```
docker build . \
  --tag pvim:v0.7.0 \
  --build-arg nvim_version=333ba6569d833e22c0d291547d740d4bbfa3fdab \
  --build-arg nvim_lspconfig_version=99596a8cabb050c6eab2c049e9acde48f42aafa4 \
  --build-arg "username=$USER"
```

### Use image

There is a [zsh example](examples/pvim/pvim.zsh). The pvim
function will mount a workspace from the host machine,
and attach (or create) a volume for a virtual environment.

You can use the image like this from a project root

```
pvim path/to/file.py
```
