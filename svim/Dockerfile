FROM fedora:36

ARG username
ARG sbt_opts

# install neovim
RUN dnf install -y git ripgrep neovim

# install scala tools
RUN dnf install -y java-11-openjdk java-11-openjdk-devel java-11-openjdk-src
RUN mkdir /cs
RUN curl -fL https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz | gzip -d >/cs/cs
RUN chmod u+x /cs/cs
RUN /cs/cs setup --yes --install-dir /usr/local/bin --apps cs,scalac,scalafmt
RUN chmod 0744 /usr/local/bin/cs
RUN cs bootstrap sbt --assembly -o /usr/local/bin/sbt
# install metals
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
 && git fetch --depth 1 origin 99596a8cabb050c6eab2c049e9acde48f42aafa4 \
 && git checkout 99596a8cabb050c6eab2c049e9acde48f42aafa4

RUN mkdir -p "$HOME/.sbt/1.0"
ENV SBT_OPTS $sbt_opts

RUN mkdir "$HOME/workspace"
WORKDIR "$HOME/workspace"

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
