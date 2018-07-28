FROM ubuntu

ARG UID=1000
ARG USERNAME=bakerface
ARG USER_FULLNAME="Chris Baker"
ARG NODE_URL=https://deb.nodesource.com/setup_10.x
ARG DOCKER_URL=https://download.docker.com/linux/static/stable/x86_64/docker-18.03.1-ce.tgz
ARG DOCKER_COMPOSE_URL=https://github.com/docker/compose/releases/download/1.21.2/docker-compose-Linux-x86_64

RUN apt-get update && apt-get install -y autoconf build-essential cmake curl git iputils-ping make openssh-client python-dev python3-dev sudo tree vim \
  && curl -fsSL $NODE_URL | bash - \
  && apt-get install -y nodejs \
  && curl https://cli-assets.heroku.com/install-ubuntu.sh | sh \
  && curl -fsSL $DOCKER_URL | sudo tar --strip-components=1 -C /usr/local/bin -xz \
  && curl -fsSL -o /usr/local/bin/docker-compose $DOCKER_COMPOSE_URL \
  && chmod +x /usr/local/bin/docker-compose \
  && npm install -g typescript \
  && cd /usr/local/bin \
  && echo "#!/usr/bin/env bash" > git-email \
  && echo "" >> git-email \
  && echo 'NAME=$(git config user.name)' >> git-email \
  && echo 'EMAIL=$(git log --author="$NAME" --format="%ae" -n 1)' >> git-email \
  && echo "" >> git-email \
  && echo 'if [ -z "$EMAIL" ]; then' >> git-email \
  && echo '  echo Could not find an email associated with name \\"$NAME\\"' >> git-email \
  && echo "  exit 1" >> git-email \
  && echo "fi" >> git-email \
  && echo "" >> git-email \
  && echo 'git config user.email "$EMAIL"' >> git-email \
  && echo "" >> git-email \
  && echo 'echo Using \\"$EMAIL\\" for git commits in this repository' >> git-email \
  && echo "exit 0" >> git-email \
  && chmod +x git-email \
  && echo "#!/usr/bin/env bash" > git-c \
  && echo "" >> git-c \
  && echo "set -e" >> git-c \
  && echo "" >> git-c \
  && echo 'DOMAIN="$1"' >> git-c \
  && echo 'ORG="$2"' >> git-c \
  && echo 'REPO="$3"' >> git-c \
  && echo "" >> git-c \
  && echo 'if [ -z "$DOMAIN" ]; then' >> git-c \
  && echo "  echo Cannot clone with empty domain" >> git-c \
  && echo "  exit 1" >> git-c \
  && echo "fi" >> git-c \
  && echo "" >> git-c \
  && echo 'if [ -z "$ORG" ]; then' >> git-c \
  && echo "  echo Cannot clone with empty organization" >> git-c \
  && echo "  exit 1" >> git-c \
  && echo "fi" >> git-c \
  && echo "" >> git-c \
  && echo 'if [ -z "$REPO" ]; then' >> git-c \
  && echo "  echo Cannot clone with empty repository" >> git-c \
  && echo "  exit 1" >> git-c \
  && echo "fi" >> git-c \
  && echo "" >> git-c \
  && echo 'git clone $DOMAIN/$ORG/$REPO.git' >> git-c \
  && echo 'cd "$REPO"' >> git-c \
  && echo 'git email' >> git-c \
  && echo "" >> git-c \
  && echo "exit 0" >> git-c \
  && chmod +x git-c \
  && echo "#!/usr/bin/env bash" > git-hub \
  && echo "" >> git-hub \
  && echo 'git c https://github.com $@' >> git-hub \
  && chmod +x git-hub \
  && echo "#!/usr/bin/env bash" > git-lab \
  && echo "" >> git-lab \
  && echo 'git c https://gitlab.com $@' >> git-lab \
  && chmod +x git-lab \
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
  && git clone --depth 1 https://github.com/nanotech/jellybeans.vim \
  && git clone --depth 1 https://github.com/Valloric/YouCompleteMe \
  && git clone --depth 1 https://github.com/elmcast/elm-vim \
  && git clone --depth 1 https://github.com/jason0x43/vim-js-indent \
  && git clone --depth 1 https://github.com/leafgarland/typescript-vim \
  && git clone --depth 1 https://github.com/mhartington/vim-typings \
  && git clone --depth 1 https://github.com/mxw/vim-jsx \
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
  && ./install.py --clang-completer --js-completer \
  && cd ~ \
  && echo "execute pathogen#infect()" > .vimrc \
  && echo "syntax on" >> .vimrc \
  && echo "filetype plugin indent on" >> .vimrc \
  && echo "colorscheme jellybeans" >> .vimrc \
  && echo "" >> .vimrc \
  && echo "set enc=utf-8" >> .vimrc \
  && echo "set tabstop=2" >> .vimrc \
  && echo "set softtabstop=2" >> .vimrc \
  && echo "set shiftwidth=2" >> .vimrc \
  && echo "set expandtab" >> .vimrc \
  && echo "set number" >> .vimrc \
  && echo "set autoread" >> .vimrc \
  && echo "" >> .vimrc \
  && echo "let NERDTreeIgnore=['node_modules']" >> .vimrc \
  && echo "" >> .vimrc \
  && echo "let g:ale_linters = {}" >> .vimrc \
  && echo "let g:ale_fixers = {}" >> .vimrc \
  && echo "let g:ale_fix_on_save = 1" >> .vimrc \
  && echo "" >> .vimrc \
  && echo "if !exists('g:ycm_semantic_triggers')" >> .vimrc \
  && echo "  let g:ycm_semantic_triggers = {}" >> .vimrc \
  && echo "endif" >> .vimrc \
  && echo "" >> .vimrc \
  && echo "let g:ycm_semantic_triggers['javascript'] = ['.']" >> .vimrc \
  && echo "let g:ycm_semantic_triggers['typescript'] = ['.']" >> .vimrc \
  && echo "let g:ycm_autoclose_preview_window_after_completion = 1" >> .vimrc \
  && echo "" >> .vimrc \
  && echo "let g:tsuquyomi_disable_quickfix = 0" >> .vimrc \
  && echo "" >> .vimrc \
  && echo "autocmd FileType css let g:ale_linters = {" >> .vimrc \
  && echo "\  'css': glob('.stylelintrc*', '.;') != '' ? [ 'prettier', 'stylelint' ] : []," >> .vimrc \
  && echo "\}" >> .vimrc \
  && echo "" >> .vimrc \
  && echo "autocmd FileType css let g:ale_fixers = {" >> .vimrc \
  && echo "\  'css': glob('.stylelintrc*', '.;') != '' ? [ 'prettier', 'stylelint' ] : []," >> .vimrc \
  && echo "\}" >> .vimrc \
  && echo "" >> .vimrc \
  && echo "autocmd FileType javascript let g:ale_linters = {" >> .vimrc \
  && echo "\  'javascript': glob('.eslintrc*', '.;') != '' ? [ 'prettier', 'eslint' ] : [ 'xo' ]," >> .vimrc \
  && echo "\}" >> .vimrc \
  && echo "" >> .vimrc \
  && echo "autocmd FileType javascript let g:ale_fixers = {" >> .vimrc \
  && echo "\  'javascript': glob('.eslintrc*', '.;') != '' ? [ 'prettier', 'eslint' ] : [ 'xo' ]," >> .vimrc \
  && echo "\}" >> .vimrc \
  && echo "" >> .vimrc \
  && echo "autocmd FileType typescript let g:ale_linters = {" >> .vimrc \
  && echo "\  'typescript': [ 'prettier', 'tslint' ]," >> .vimrc \
  && echo "\}" >> .vimrc \
  && echo "" >> .vimrc \
  && echo "autocmd FileType typescript let g:ale_fixers = {" >> .vimrc \
  && echo "\  'typescript': [ 'prettier', 'tslint' ]," >> .vimrc \
  && echo "\}" >> .vimrc \
  && echo "" >> .vimrc \
  && echo "inoremap jk <Esc>" >> .vimrc \
  && echo "nmap <silent> <C-j> :ALENext<cr>" >> .vimrc \
  && echo "nmap <silent> <C-k> :ALEPrevious<cr>" >> .vimrc \
  && echo "map <C-n> :NERDTreeToggle<cr>" >> .vimrc \
  && echo "map <C-i> :YcmCompleter FixIt<cr>" >> .vimrc \
  && echo "map <C-h> :echo tsuquyomi#hint()<cr>" >> .vimrc \
  && git config --global user.name "$USER_FULLNAME" \
  && git config --global push.default simple \
  && git config --global credential.helper cache

ENTRYPOINT ["bash"]
