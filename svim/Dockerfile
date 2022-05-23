FROM ubuntu:22.04

ARG username
ARG nvim_version

# neovim build deps
RUN apt-get update
RUN apt-get install -y ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen

# build neovim
RUN apt-get install -y git
RUN git clone https://github.com/neovim/neovim /usr/local/src/neovim
WORKDIR /usr/local/src/neovim
RUN git checkout $nvim_version
RUN make CMAKE_BUILD_TYPE=Release
RUN make install

FROM ubuntu:22.04

ARG username
ARG sbt_opts

RUN apt-get update
RUN apt-get install -y git ripgrep
# install nvim
COPY --from=0 /usr/local/bin/nvim /usr/local/bin/nvim
COPY --from=0 /usr/local/share/nvim/ /usr/local/share/nvim/

# install scala tools
RUN apt-get install -y openjdk-11-jre openjdk-11-jdk openjdk-11-source
# cs installation dep
RUN apt-get install -y curl gzip

# copy entrypoint
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# create user
RUN useradd -ms /bin/bash ${username}
USER ${username}
ENV HOME /home/${username}
RUN mkdir -p "$HOME/.sbt/1.0"
ENV XDG_CONFIG_HOME "$HOME/.config"
RUN mkdir "$XDG_CONFIG_HOME"

# install metals
RUN curl -fL https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz | gzip -d >"$HOME/cs"
RUN chmod +x "$HOME/cs"
ENV PATH "$PATH:$HOME/.local/share/coursier/bin"
RUN "$HOME/cs" setup --yes
RUN cs install metals

# install nvim config
COPY --chown=${username}:${username} nvim "$XDG_CONFIG_HOME/nvim"

# install nvim plugins
RUN git clone --depth 1 https://github.com/neovim/nvim-lspconfig \
      "$HOME/.local/share/nvim/site/pack/packer/start/lspconfig"

RUN mkdir "$HOME/workspace"
WORKDIR "$HOME/workspace"
ENV SBT_OPTS $sbt_opts

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
