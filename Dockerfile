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
  && apt-get install -y autoconf build-essential cmake curl git iputils-ping make net-tools openssh-client python-dev python3-dev sudo telnet tree tzdata vim \
  && curl -fsSL $NODE_URL | bash - \
  && apt-get install -y nodejs \
  && curl https://cli-assets.heroku.com/install-ubuntu.sh | sh \
  && curl -fsSL $DOCKER_URL | sudo tar --strip-components=1 -C /usr/local/bin -xz \
  && curl -fsSL -o /usr/local/bin/docker-compose $DOCKER_COMPOSE_URL \
  && chmod +x /usr/local/bin/docker-compose \
  && npm install -g typescript wsc \
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
  && echo '#!/usr/bin/env node' >> npm-refresh \
  && echo "" >> npm-refresh \
  && echo 'const child_process = require("child_process");' >> npm-refresh \
  && echo 'const fs = require("fs");' >> npm-refresh \
  && echo "" >> npm-refresh \
  && echo 'function spawn(command = "", args = []) {' >> npm-refresh \
  && echo 'return new Promise((resolve, reject) => {' >> npm-refresh \
  && echo '  const proc = child_process.spawn(command, args, {' >> npm-refresh \
  && echo '    stdio: "inherit"' >> npm-refresh \
  && echo '  });' >> npm-refresh \
  && echo "" >> npm-refresh \
  && echo '  proc.on("data", data => process.stdout.write(data));' >> npm-refresh \
  && echo '  proc.on("error", reject);' >> npm-refresh \
  && echo '  proc.on("exit", code => (code ? reject(code) : resolve()));' >> npm-refresh \
  && echo '});' >> npm-refresh \
  && echo '}' >> npm-refresh \
  && echo "" >> npm-refresh \
  && echo 'function getPackageNames(dependencies = {}) {' >> npm-refresh \
  && echo '  const names = [];' >> npm-refresh \
  && echo "  " >> npm-refresh \
  && echo '  for (const [name, url] of Object.entries(dependencies)) {' >> npm-refresh \
  && echo '    if (url.includes("://")) {' >> npm-refresh \
  && echo '      names.push(url);' >> npm-refresh \
  && echo '    } else {' >> npm-refresh \
  && echo '      names.push(name);' >> npm-refresh \
  && echo '    }' >> npm-refresh \
  && echo '  }' >> npm-refresh \
  && echo "  " >> npm-refresh \
  && echo '  return names;' >> npm-refresh \
  && echo '}' >> npm-refresh \
  && echo "" >> npm-refresh \
  && echo 'async function main() {' >> npm-refresh \
  && echo '  const packageJson = JSON.parse("" + fs.readFileSync("package.json"));' >> npm-refresh \
  && echo '  const dependencies = getPackageNames(packageJson.dependencies);' >> npm-refresh \
  && echo '  const devDependencies = getPackageNames(packageJson.devDependencies);' >> npm-refresh \
  && echo "  " >> npm-refresh \
  && echo '  delete packageJson.dependencies;' >> npm-refresh \
  && echo "  " >> npm-refresh \
  && echo '  fs.writeFileSync("package.json", JSON.stringify(packageJson));' >> npm-refresh \
  && echo "  " >> npm-refresh \
  && echo '  if (dependencies.length > 0) {' >> npm-refresh \
  && echo '    await spawn("npm", ["install", "-S", ...dependencies]);' >> npm-refresh \
  && echo '  }' >> npm-refresh \
  && echo "  " >> npm-refresh \
  && echo '  if (devDependencies.length > 0) {' >> npm-refresh \
  && echo '    await spawn("npm", ["install", "-D", ...devDependencies]);' >> npm-refresh \
  && echo '  }' >> npm-refresh \
  && echo "  " >> npm-refresh \
  && echo '  await spawn("npm", ["audit", "fix"]);' >> npm-refresh \
  && echo '  return 0;' >> npm-refresh \
  && echo '}' >> npm-refresh \
  && echo "" >> npm-refresh \
  && echo 'main();' >> npm-refresh \
  && chmod +x npm-refresh \
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
  && ./install.py --clang-completer --ts-completer \
  && cd ~ \
  && echo "execute pathogen#infect()" > .vimrc \
  && echo "syntax on" >> .vimrc \
  && echo "filetype plugin indent on" >> .vimrc \
  && echo "" >> .vimrc \
  && echo "set background=dark" >> .vimrc \
  && echo "set enc=utf-8" >> .vimrc \
  && echo "set tabstop=2" >> .vimrc \
  && echo "set softtabstop=2" >> .vimrc \
  && echo "set shiftwidth=2" >> .vimrc \
  && echo "set expandtab" >> .vimrc \
  && echo "set number" >> .vimrc \
  && echo "set autoread" >> .vimrc \
  && echo "" >> .vimrc \
  && echo "highlight clear SignColumn" >> .vimrc \
  && echo "highlight GitGutterAdd ctermfg=green" >> .vimrc \
  && echo "highlight GitGutterChange ctermfg=yellow" >> .vimrc \
  && echo "highlight GitGutterDelete ctermfg=red" >> .vimrc \
  && echo "highlight GitGutterChangeDelete ctermfg=yellow" >> .vimrc \
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
  && echo "\  'typescript': glob('.eslintrc*', '.;') != '' ? [ 'prettier', 'eslint' ] : [ 'xo' ]," >> .vimrc \
  && echo "\}" >> .vimrc \
  && echo "" >> .vimrc \
  && echo "autocmd FileType typescript let g:ale_fixers = {" >> .vimrc \
  && echo "\  'typescript': glob('.eslintrc*', '.;') != '' ? [ 'prettier', 'eslint' ] : [ 'xo' ]," >> .vimrc \
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
  && git config --global credential.helper cache \
  && git config --global user.useConfigOnly true

ENTRYPOINT ["bash"]
