execute pathogen#infect()
syntax on
filetype plugin indent on

set background=dark
set enc=utf-8
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set number
set autoread

highlight clear SignColumn
highlight GitGutterAdd ctermfg=green
highlight GitGutterChange ctermfg=yellow
highlight GitGutterDelete ctermfg=red
highlight GitGutterChangeDelete ctermfg=yellow

let NERDTreeIgnore=['node_modules']

let g:ale_linters = {}
let g:ale_fixers = {}
let g:ale_fix_on_save = 1

if !exists('g:ycm_semantic_triggers')
  let g:ycm_semantic_triggers = {}
endif

let g:ycm_semantic_triggers['javascript'] = ['.']
let g:ycm_semantic_triggers['typescript'] = ['.']
let g:ycm_autoclose_preview_window_after_completion = 1

let g:tsuquyomi_disable_quickfix = 0

autocmd FileType cs let g:ale_linters = {
\  'cs': ['OmniSharp'],
\}

autocmd FileType css let g:ale_linters = {
\  'css': glob('.stylelintrc*', '.;') != '' ? ['prettier', 'stylelint'] : ['prettier'],
\}

autocmd FileType css let g:ale_fixers = {
\  'css': glob('.stylelintrc*', '.;') != '' ? ['prettier', 'stylelint'] : ['prettier'],
\}

autocmd FileType javascript let g:ale_linters = {
\  'javascript': glob('.eslintrc*', '.;') != '' ? ['prettier', 'eslint'] : ['prettier'],
\}

autocmd FileType javascript let g:ale_fixers = {
\  'javascript': glob('.eslintrc*', '.;') != '' ? ['prettier', 'eslint'] : ['prettier'],
\}

autocmd FileType typescript let g:ale_linters = {
\  'typescript': glob('.eslintrc*', '.;') != '' ? ['prettier', 'eslint'] : ['prettier'],
\}

autocmd FileType typescript let g:ale_fixers = {
\  'typescript': glob('.eslintrc*', '.;') != '' ? ['prettier', 'eslint'] : ['prettier'],
\}

inoremap jk <Esc>
nmap <silent> <C-j> :ALENext<cr>
nmap <silent> <C-k> :ALEPrevious<cr>
map <C-n> :NERDTreeToggle<cr>
map <C-i> :YcmCompleter FixIt<cr>
map <C-h> :echo tsuquyomi#hint()<cr>
