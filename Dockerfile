FROM ubuntu:20.04

ARG UID=1000
ARG USERNAME=bakerface
ARG USER_FULLNAME="Chris Baker"
ARG TZ=America/Kentucky/Louisville
ARG DOCKER_URL=https://download.docker.com/linux/static/stable/x86_64/docker-18.06.3-ce.tgz

ENV TZ $TZ

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
  && echo $TZ > /etc/timezone \
  && apt-get update \
  && apt-get install -y autoconf build-essential cmake curl git iputils-ping make net-tools openssh-client python-dev python3-dev sudo telnet tree tzdata unzip neovim zip \
  && curl -fsSL $DOCKER_URL | sudo tar --strip-components=1 -C /usr/local/bin -xz \
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
COPY --chown=$UID:$UID home .

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash \
  && curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

SHELL ["/bin/bash", "-l", "-i", "-c"]
RUN source .bashrc \
  && nvm install --lts \
  && npm install -g prettier eslint typescript \
  && vim '+PlugInstall' +qall \
  && vim '+CocInstall -sync coc-eslint coc-prettier coc-json coc-tsserver coc-html' +qall \
  && chmod +x ~/.bin/* \
  && echo '' >> ~/.bashrc \
  && echo 'export PATH="${PATH}:${HOME}/.bin"' >> ~/.bashrc \
  && git config --global user.name "$USER_FULLNAME" \
  && git config --global push.default simple \
  && git config --global credential.helper cache \
  && git config --global user.useConfigOnly true
SHELL ["/bin/bash", "-l", "-c"]
