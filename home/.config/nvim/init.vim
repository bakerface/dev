" REFERENCES: {{{

" How to do 90% of what plugins do (with just vim)
" https://www.youtube.com/watch?v=XA2WjJbmmoM

" }}}

" PLUGINS: {{{
call plug#begin('~/.vim/plugged')

" Color Scheme
Plug 'joshdick/onedark.vim'

" Syntax Files
Plug 'sheerun/vim-polyglot'

" File browser
Plug 'preservim/nerdtree'

" Code completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

" }}}

" BASIC SETUP: {{{
syntax on
filetype plugin indent on

colorscheme onedark
set background=dark
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

" Make the gutter transparent and always active
highlight clear SignColumn
set signcolumn=yes

" Use comma as the leader
let g:mapleader=','

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

" Use <TAB> for coc.nvim completion and navigate to next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

" Close preview window when completion is done.
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" Jump to definition
nmap <c-]> <Plug>(coc-definition)

" Quick fix the current line
nmap <c-i> <Plug>(coc-fix-current)

" Jump to previous error
nmap <c-j> <Plug>(coc-diagnostic-prev)

" Jump to next error
nmap <c-k> <Plug>(coc-diagnostic-next)

" Trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" }}}

" SNIPPETS: {{{

" Create a snippet for a TypeScript error
nnoremap <leader>err :read $HOME/.snippets/err.ts<CR>k"_dd2wi

" THINGS TO CONSIDER:
" - :read adds a newline, which we remove with k"_dd

" }}}
