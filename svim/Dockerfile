FROM ubuntu:22.04

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
ARG sbt_opts
ARG nvim_lspconfig_version

# install nvim
RUN apt-get update
RUN apt-get install -y git ripgrep
COPY --from=0 /usr/local/bin/nvim /usr/local/bin/nvim
COPY --from=0 /usr/local/share/nvim/ /usr/local/share/nvim/

# install scala tools
RUN apt-get install -y openjdk-11-jre openjdk-11-jdk openjdk-11-source
# install metals
RUN apt-get install -y curl gzip
RUN mkdir /cs
RUN curl -fL https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz | gzip -d >/cs/cs
RUN chmod u+x /cs/cs
RUN /cs/cs setup --yes --install-dir /usr/local/bin --apps cs,scalac,scalafmt
RUN chmod 0744 /usr/local/bin/cs
RUN cs bootstrap sbt --assembly -o /usr/local/bin/sbt
RUN cs bootstrap \
      --java-opt -Xss4m \
      --java-opt -Xms100m \
      --java-opt -Dmetals.client=nvim-lspconfig \
      --java-opt -Dmetals.bloopSbtAlreadyInstalled=true \
      --java-opt -Dmetals.superMethodLensesEnabled=true \
      --java-opt -Dmetals.showInferredType=true \
      --java-opt -Dmetals.showImplicitArguments=true \
      --java-opt -Dmetals.showImplicitConversionsAndClasses=true \
      metals \
      -r bintray:scalacenter/releases \
      -r sonatype:snapshots \
      -o /usr/local/bin/metals -f

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
 && git fetch --depth 1 origin "$nvim_lspconfig_version" \
 && git checkout "$nvim_lspconfig_version"

RUN mkdir -p "$HOME/.sbt/1.0"
ENV SBT_OPTS $sbt_opts

RUN mkdir "$HOME/workspace"
WORKDIR "$HOME/workspace"

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
