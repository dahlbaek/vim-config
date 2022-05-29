FROM fedora:36

ARG username

# install neovim
RUN dnf install -y git ripgrep neovim

# install entrypoint
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# install rust tools
RUN dnf install -y cargo rust-src rls

# create user
RUN useradd -ms /bin/bash ${username}
USER ${username}
ENV HOME /home/${username}
ENV XDG_CONFIG_HOME "$HOME/.config"
RUN mkdir "$XDG_CONFIG_HOME"

# install nvim config
COPY --chown=${username}:${username} nvim "$XDG_CONFIG_HOME/nvim"

# install nvim-lspconfig plugin
RUN mkdir -p "$HOME/.local/share/nvim/site/pack/packer/start/lspconfig"
RUN cd "$HOME/.local/share/nvim/site/pack/packer/start/lspconfig" \
 && git init \
 && git remote add origin https://github.com/neovim/nvim-lspconfig \
 && git fetch --depth 1 origin 99596a8cabb050c6eab2c049e9acde48f42aafa4 \
 && git checkout 99596a8cabb050c6eab2c049e9acde48f42aafa4

RUN mkdir "$HOME/.cargo"

RUN mkdir "$HOME/workspace"
WORKDIR "$HOME/workspace"

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
