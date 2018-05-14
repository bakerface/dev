FROM ubuntu

ARG UID=1000
ARG USERNAME=bakerface
ARG USER_FULLNAME="Chris Baker"
ARG NODE_URL=https://deb.nodesource.com/setup_10.x
ARG DOCKER_URL=https://download.docker.com/linux/static/edge/x86_64/docker-18.03.0-ce.tgz
ARG DOCKER_COMPOSE_URL=https://github.com/docker/compose/releases/download/1.21.0/docker-compose-Linux-x86_64

RUN apt-get update && apt-get install -y autoconf build-essential curl git make sudo tree vim \
  && curl -fsSL $NODE_URL | bash - \
  && apt-get install -y nodejs \
  && curl -fsSL $DOCKER_URL \
     | sudo tar --strip-components=1 -C /usr/local/bin -xz \
  && curl -fsSL -o /usr/local/bin/docker-compose $DOCKER_COMPOSE_URL \
  && chmod +x /usr/local/bin/docker-compose \
  && cd /usr/local/bin \
  && echo "#!/usr/bin/env bash" > git-email \
  && echo 'NAME=$(git config user.name)' >> git-email \
  && echo 'EMAIL=$(git log --author="$NAME" --format="%ae" -n 1)' >> git-email \
  && echo 'git config user.email "$EMAIL"' >> git-email \
  && chmod +x git-email \
  && addgroup --gid $UID $USERNAME \
  && adduser --uid $UID --gid $UID --shell /bin/bash --disabled-password --gecos "" $USERNAME \
  && echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USERNAME \
  && chmod 440 /etc/sudoers.d/$USERNAME

USER $USERNAME
WORKDIR /home/$USERNAME
ENV EDITOR=vim VISUAL=vim TERM=xterm-256color

RUN mkdir -p ~/.vim/autoload ~/.vim/bundle \
  && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim \
  && cd ~/.vim/bundle \
  && git clone --depth 1 https://github.com/tpope/vim-sensible \
  && git clone --depth 1 https://github.com/scrooloose/nerdtree \
  && git clone --depth 1 https://github.com/vim-syntastic/syntastic \
  && git clone --depth 1 https://github.com/xojs/vim-xo \
  && git clone --depth 1 https://github.com/pangloss/vim-javascript \
  && git clone --depth 1 https://github.com/mxw/vim-jsx \
  && git clone --depth 1 https://github.com/posva/vim-vue \
  && cd ~ \
  && echo "execute pathogen#infect()" > .vimrc \
  && echo "syntax on" >> .vimrc \
  && echo "filetype plugin indent on" >> .vimrc \
  && echo "set enc=utf-8" >> .vimrc \
  && echo "set tabstop=2" >> .vimrc \
  && echo "set softtabstop=2" >> .vimrc \
  && echo "set shiftwidth=2" >> .vimrc \
  && echo "set expandtab" >> .vimrc \
  && echo "set number" >> .vimrc \
  && echo "set autoread" >> .vimrc \
  && echo "inoremap jk <Esc>" >> .vimrc \
  && echo "" >> .vimrc \
  && echo "map <C-n> :NERDTreeToggle<CR>" >> .vimrc \
  && echo "" >> .vimrc \
  && echo "let g:syntastic_javascript_checkers = ['xo']" >> .vimrc \
  && echo "let g:syntastic_javascript_xo_args = ['--fix']" >> .vimrc \
  && echo "au VimEnter *.js au BufWritePost *.js checktime" >> .vimrc \
  && git config --global user.name "$USER_FULLNAME" \
  && git config --global push.default simple \
  && git config --global credential.helper cache

ENTRYPOINT sudo chmod 777 /var/run/docker.sock && bash
