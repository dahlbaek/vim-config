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

# cs and packer deps
RUN apt-get update
RUN apt-get install -y openjdk-11-jre openjdk-11-jdk openjdk-11-source
RUN apt-get install -y curl gzip git ripgrep

# copy entrypoint
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# create user
RUN useradd -ms /bin/bash ${username}
USER ${username}
ENV HOME /home/${username}
ENV XDG_CONFIG_HOME "$HOME/.config"
RUN mkdir "$HOME/.config"
WORKDIR "$HOME"

# install cs
RUN curl -fL https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz | gzip -d >"$HOME/cs"
RUN chmod +x cs
RUN ./cs setup --yes
RUN mkdir -p .sbt/1.0
ENV PATH "$PATH:$HOME/.local/share/coursier/bin"

# install nvim
COPY --from=0 /usr/local/bin/nvim /usr/local/bin/nvim
COPY --from=0 /usr/local/share/nvim/ /usr/local/share/nvim/

# install packer
COPY --chown=${username}:${username} nvim .config/nvim
RUN git clone --depth 1 https://github.com/wbthomason/packer.nvim \
      ~/.local/share/nvim/site/pack/packer/start/packer.nvim
# note: ignore errors due to missing plugins here
RUN nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerInstall'

RUN mkdir "$HOME/workspace"
WORKDIR "$HOME/workspace"
ENV SBT_OPTS $sbt_opts

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
