FROM ubuntu:22.04

ARG username
ARG nvim_version

# neovim build deps
RUN apt-get update
RUN apt-get install -y ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen

# build neovim
RUN apt-get install -y git
RUN mkdir -p /usr/local/src/neovim
RUN cd /usr/local/src/neovim \
 && git init \
 && git remote add origin https://github.com/neovim/neovim \
 && git fetch --depth 1 origin "$nvim_version" \
 && git checkout "$nvim_version" \
 && make CMAKE_BUILD_TYPE=Release \
 && make install


FROM ubuntu:22.04

ARG username
ARG nvim_lspconfig_version

RUN apt-get update
RUN apt-get install -y git ripgrep

# install nvim
COPY --from=0 /usr/local/bin/nvim /usr/local/bin/nvim
COPY --from=0 /usr/local/share/nvim/ /usr/local/share/nvim/


# install python tools
RUN apt-get install -y black python3-venv
# install pyright
RUN apt-get install -y nodejs npm
RUN npm install -g pyright

# install entrypoint
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# create user
RUN useradd -ms /bin/bash ${username}
USER ${username}
ENV HOME /home/${username}
ENV PATH "$PATH:$HOME/.local/bin"
ENV XDG_CONFIG_HOME "$HOME/.config"
RUN mkdir "$XDG_CONFIG_HOME"


# install nvim config
COPY --chown=${username}:${username} nvim "$XDG_CONFIG_HOME/nvim"

# install nvim-lspconfig plugin
RUN mkdir -p "$HOME/.local/share/nvim/site/pack/packer/start/lspconfig"
RUN cd "$HOME/.local/share/nvim/site/pack/packer/start/lspconfig" \
 && git init \
 && git remote add origin https://github.com/neovim/nvim-lspconfig \
 && git fetch --depth 1 origin "$nvim_lspconfig_version" \
 && git checkout "$nvim_lspconfig_version"

# create virtual environment
RUN python3 -m venv "$HOME/.venv"

RUN mkdir "$HOME/workspace"
WORKDIR "$HOME/workspace"

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
