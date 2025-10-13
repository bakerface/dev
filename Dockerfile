FROM ubuntu:24.04

ARG UID="2000"
ARG USERNAME="bakerface"
ARG DISPLAY_NAME="Chris Baker"
ARG TZ="America/Kentucky/Louisville"
ARG DOCKER_VERSION="28.3.3"
ARG NVM_VERSION="0.40.3"
ARG APT_PACKAGES="adb autoconf build-essential clangd cmake curl git gforth htop iputils-ping make man-db net-tools openssh-client python3-dev sudo telnet tree tzdata unzip neovim zip"
ARG NPM_PACKAGES="eslint prettier tsx typescript"
ARG COC_PLUGINS="@yaegassy/coc-tailwindcss3 coc-clangd coc-eslint coc-html coc-json coc-prettier coc-tsserver"

ENV TZ=${TZ}

RUN yes | unminimize \
  && ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime \
  && echo ${TZ} > /etc/timezone \
  && apt update \
  && apt install -y ${APT_PACKAGES} \
  && curl -fsSL https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz | sudo tar --strip-components=1 -C /usr/local/bin -xz \
  && curl -fLo /usr/local/bin/dind "https://raw.githubusercontent.com/moby/moby/refs/tags/v${DOCKER_VERSION}/hack/dind" \
  && chmod +x /usr/local/bin/dind \
  && addgroup --gid ${UID} ${USERNAME} \
  && adduser --uid ${UID} --gid ${UID} --shell /bin/bash --disabled-password --gecos "" ${USERNAME} \
  && echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USERNAME} \
  && chmod 440 /etc/sudoers.d/${USERNAME} \
  && addgroup docker \
  && usermod -aG docker ${USERNAME} \
  && apt clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER ${USERNAME}
WORKDIR /home/${USERNAME}
ENV EDITOR=vim
ENV VISUAL=vim
ENV TERM=xterm-256color
COPY --chown=${UID}:${UID} home .

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash \
  && curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

SHELL ["/bin/bash", "-l", "-i", "-c"]

RUN source .bashrc \
  && nvm install node \
  && npm install -g ${NPM_PACKAGES} \
  && vim "+PlugInstall" +qall \
  && vim "+CocInstall -sync ${COC_PLUGINS}" +qall \
  && chmod +x ~/.bin/* \
  && echo "" >> ~/.bashrc \
  && echo 'export PATH="${PATH}:${HOME}/.bin"' >> ~/.bashrc \
  && git config --global user.name "${DISPLAY_NAME}" \
  && git config --global push.default simple \
  && git config --global credential.helper cache \
  && git config --global user.useConfigOnly true

SHELL ["/bin/bash", "-l", "-c"]
