FROM fedora:36

ARG username
ARG userid

# install neovim
RUN dnf install -y git ripgrep neovim

# install entrypoint
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# install python tools
RUN dnf install -y black
# install pyright
RUN dnf install -y nodejs npm
RUN npm install -g pyright
RUN dnf remove -y npm

# create user
RUN groupadd --gid "${userid}" "${username}"
RUN useradd --uid "${userid}" --gid "${userid}" --create-home --shell /bin/bash "${username}"
USER ${userid}
ENV HOME "/home/${username}"
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

COPY --chown=${username}:${username} get-poetry.py "$HOME/get-poetry.py"
RUN python3 "$HOME/get-poetry.py"
RUN rm "$HOME/get-poetry.py"

RUN python3 -m venv "$HOME/.venv"

RUN mkdir "$HOME/workspace"
WORKDIR "$HOME/workspace"

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
