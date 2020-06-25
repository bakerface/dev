FROM ubuntu

ARG UID=1000
ARG USERNAME=bakerface
ARG USER_FULLNAME="Chris Baker"
ARG TZ=America/Kentucky/Louisville
ARG NODE_URL=https://deb.nodesource.com/setup_12.x
ARG DOCKER_URL=https://download.docker.com/linux/static/stable/x86_64/docker-18.06.3-ce.tgz
ARG DOCKER_COMPOSE_URL=https://github.com/docker/compose/releases/download/1.24.1/docker-compose-Linux-x86_64

ENV TZ $TZ

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
  && echo $TZ > /etc/timezone \
  && apt-get update \
  && apt-get install -y gnupg ca-certificates \
  && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
  && echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | tee /etc/apt/sources.list.d/mono-official-stable.list \
  && apt-get update \
  && apt-get install -y autoconf build-essential cmake curl git iputils-ping make mono-devel net-tools openssh-client python-dev python3-dev sudo telnet tree tzdata unzip vim zip \
  && apt-get update \
  && curl -fsSL $NODE_URL | bash - \
  && apt-get install -y nodejs \
  && curl https://cli-assets.heroku.com/install-ubuntu.sh | sh \
  && curl -fsSL $DOCKER_URL | sudo tar --strip-components=1 -C /usr/local/bin -xz \
  && curl -fsSL -o /usr/local/bin/docker-compose $DOCKER_COMPOSE_URL \
  && chmod +x /usr/local/bin/docker-compose \
  && npm install -g typescript wsc \
  && addgroup --gid $UID $USERNAME \
  && adduser --uid $UID --gid $UID --shell /bin/bash --disabled-password --gecos "" $USERNAME \
  && echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USERNAME \
  && chmod 440 /etc/sudoers.d/$USERNAME \
  && addgroup docker \
  && usermod -aG docker $USERNAME \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER $USERNAME
WORKDIR /home/$USERNAME
ENV EDITOR=vim VISUAL=vim TERM=xterm-256color

RUN mkdir -p ~/.vim/autoload ~/.vim/bundle \
  && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim \
  && cd ~/.vim/bundle \
  && git clone --depth 1 https://github.com/Valloric/YouCompleteMe \
  && git clone --depth 1 https://github.com/airblade/vim-gitgutter \
  && git clone --depth 1 https://github.com/elmcast/elm-vim \
  && git clone --depth 1 https://github.com/jason0x43/vim-js-indent \
  && git clone --depth 1 https://github.com/leafgarland/typescript-vim \
  && git clone --depth 1 https://github.com/mhartington/vim-typings \
  && git clone --depth 1 https://github.com/mxw/vim-jsx \
  && git clone --depth 1 https://github.com/OmniSharp/omnisharp-vim \
  && git clone --depth 1 https://github.com/pangloss/vim-javascript \
  && git clone --depth 1 https://github.com/posva/vim-vue \
  && git clone --depth 1 https://github.com/quramy/tsuquyomi.git \
  && git clone --depth 1 https://github.com/quramy/vim-dtsm \
  && git clone --depth 1 https://github.com/quramy/vim-js-pretty-template \
  && git clone --depth 1 https://github.com/scrooloose/nerdtree \
  && git clone --depth 1 https://github.com/tpope/vim-fugitive \
  && git clone --depth 1 https://github.com/tpope/vim-sensible \
  && git clone --depth 1 https://github.com/vim-airline/vim-airline \
  && git clone --depth 1 https://github.com/w0rp/ale \
  && cd ~/.vim/bundle/YouCompleteMe \
  && git submodule update --init --recursive \
  && ./install.py --clang-completer --cs-completer --ts-completer \
  && cd ~/.vim/bundle/YouCompleteMe/third_party/ycmd/third_party/tsserver/lib \
  && npm update

COPY --chown=$UID:$UID home .

RUN chmod +x ~/bin/* \
  && git config --global user.name "$USER_FULLNAME" \
  && git config --global push.default simple \
  && git config --global credential.helper cache \
  && git config --global user.useConfigOnly true

ENTRYPOINT ["bash"]
CMD ["-l"]
