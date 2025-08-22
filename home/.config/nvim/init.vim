" REFERENCES: {{{

" How to do 90% of what plugins do (with just vim)
" https://www.youtube.com/watch?v=XA2WjJbmmoM

" }}}

" PLUGINS: {{{
call plug#begin('~/.vim/plugged')

" Color Schemes
Plug 'axvr/photon.vim'
Plug 'baskerville/bubblegum'

" Syntax Files
Plug 'sheerun/vim-polyglot'

" File browser
Plug 'preservim/nerdtree'

" Markdown preview
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" Code completion for TypeScript
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Code completion for C#
Plug 'OmniSharp/omnisharp-vim'

call plug#end()

" }}}

" BASIC SETUP: {{{
syntax on
filetype plugin indent on

set hidden
set foldmethod=marker
set encoding=utf-8
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set number
set ruler
set nowrap
" set textwidth=80
" set colorcolumn=81

"set background=light
"colorscheme antiphoton
"colorscheme bubblegum-256-light

set background=dark
"colorscheme photon
colorscheme bubblegum-256-dark

" some servers have issues with backup files
set nobackup
set nowritebackup

" reduce diagnostic messages time from default 4000
set updatetime=300

" disable |ins-completion-menu| messages
set shortmess+=c

" Make the gutter transparent and always active
highlight clear SignColumn
set signcolumn=yes

" Use comma as the leader
let g:mapleader=','

" Disable the startup warning about old nvim versions
let g:coc_disable_startup_warning = 1

" Disable the conversion of commas to pipes for csv files
let g:csv_no_conceal = 1

" }}}

" GENERIC KEY MAPPINGS: {{{

" Remap the escape key to 'jk' in insert mode
" This is to avoid the software escape key on Mac touchbars
inoremap jk <Esc>

" Provide a shortcut to open/close file browser
nnoremap <C-n> :NERDTreeToggle<CR>

" }}}

" FINDING FILES: {{{

" Recursive search
" Provides tab-completion for all file-related tasks
set path+=**

" Display all matching files when we tab complete
set wildmenu

" NOW WE CAN:
" - Hit tab to :find by partial match
" - Use * to make it fuzzy

" THINGS TO CONSIDER:
" - :b lets you autocomplete any open buffer

" }}}

" TAG JUMPING: {{{

" Create the `tags` file (may need to install ctags first)
command! MakeTags !ctags -R .

" NOW WE CAN:
" - Use ^] to jump to tag under cursor
" - Use g^] for ambiguous tags
" - Use ^t to jump back up the tag stack

" THINGS TO CONSIDER:
" - This doesn't help if you want a visual list of tags

" }}}

" AUTOCOMPLETE: {{{

" The good stuff in documented in |ins-completion|

" HIGHLIGHTS:
" - ^x^n for JUST this file
" - ^x^f for filenames (works with our recursive path)
" - ^x^] for tags only
" - ^n for anything specified by the 'complete' option

" NOW WE CAN:
" - Use ^n and ^p to go back and forth in the suggestion list
" - Use ^e to escape autocomplete

" }}}

" NODEJS: {{{

" Ignore node_modules in tab-completion when working with files
set wildignore+=*/node_modules/*

" Ignore node_modules in NERDTree
let g:NERDTreeIgnore = ['node_modules']

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR>
      \ coc#pum#visible() ? coc#pum#confirm() :
      \ "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()

inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() :
      \ "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Close preview window when completion is done.
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" Rename symbol
nmap <leader>rn <Plug>(coc-rename)

" Jump to definition
nmap <c-]> <Plug>(coc-definition)

" Quick fix the current line
nmap <c-i> <Plug>(coc-fix-current)

" Jump to previous error
nmap <c-k> <Plug>(coc-diagnostic-prev)

" Jump to next error
nmap <c-j> <Plug>(coc-diagnostic-next)

" Use <c-space> to trigger completion
inoremap <silent><expr> <c-space> coc#refresh()

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" }}}

" C#: {{{

" Ignore output directories when performing code checks
let g:OmniSharp_diagnostic_exclude_paths = [
\ 'obj\\',
\ '[Tt]emp\\',
\ '\.nuget\\',
\ '\<AssemblyAttributes\.cs\>',
\ '\<AssemblyInfo\.cs\>'
\]

if !empty(glob("*.csproj"))
  let g:NERDTreeIgnore = ['bin', 'obj']
endif

if !empty(glob("*.sln"))
  let g:NERDTreeIgnore = ['bin', 'obj']
endif

" Jump to definition
autocmd FileType cs nmap <c-]> <Plug>(omnisharp_go_to_definition)

" Code actions
autocmd FileType cs nmap <c-i> <Plug>(omnisharp_code_actions)

" Auto add/remove usings
autocmd FileType cs nmap <c-u> <Plug>(omnisharp_fix_usings)

" Show documentation
autocmd FileType cs nmap K <Plug>(omnisharp_documentation)

" Auto-format code
autocmd FileType cs nmap = <Plug>(omnisharp_code_format)

" Close quickfix window on save
autocmd BufWritePre *.cs :ccl

" Check for errors after a save
autocmd BufWritePost *.cs :OmniSharpGlobalCodeCheck

" C# class snippet
autocmd FileType cs iabbrev namespace namespace {<CR>class <C-R>=expand("%:t:r")<CR> {<CR><CR>}<CR>}<Up><Up><Up><Up><Right><Right><Right><Right><Right><Right><Right><Right>

" }}}
