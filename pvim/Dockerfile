FROM fedora:36

ARG username

# install neovim
RUN dnf install -y git ripgrep neovim

# install python tools
RUN dnf install -y black
# install pyright
RUN dnf install -y nodejs npm
RUN npm install -g pyright

# install entrypoint
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

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

RUN python3 -m venv "$HOME/.venv"

RUN mkdir "$HOME/workspace"
WORKDIR "$HOME/workspace"

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
