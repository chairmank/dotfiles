" vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif
call plug#begin('~/.local/share/nvim/plugged')
Plug 'https://github.com/altercation/vim-colors-solarized.git'
Plug 'https://github.com/itchyny/lightline.vim'
Plug 'https://github.com/junegunn/rainbow_parentheses.vim.git'
Plug 'https://github.com/neovim/nvim-lspconfig.git'
Plug 'https://github.com/neovimhaskell/haskell-vim.git'
Plug 'https://github.com/rust-lang/rust.vim.git'
Plug 'https://github.com/sdiehl/vim-ormolu.git'
call plug#end()

" Sensible behavior of buffers
set hidden

" Encoding
set encoding=utf-8
set fileencoding=utf-8
set fileformats=unix

" Enable filetype plugins and indent files
filetype plugin indent on

" Space is leader key
let mapleader="\<SPACE>"

" Time (ms) for CursorHold, CursorHoldI autocommand events
set updatetime=1000

" Command completion
set wildmode=longest,list
set history=100

" Whitespace and indentation
set autoindent
set backspace=indent,eol,start
set expandtab
set formatoptions-=t
set nosmartindent
set nostartofline
set shiftwidth=4
set smarttab
set softtabstop=4
set tabstop=4
set textwidth=79

" Don't display long lines as wrapped; instead horizontally scroll viewport
set nowrap
set sidescroll=1

" Search behavior
set hlsearch
set incsearch

" Display diffs with vertical split
set diffopt=filler,vertical

" Show useful information
syntax on
set colorcolumn=+1
set cursorline
set laststatus=2
set list
set listchars=tab:→\ ,trail:·
set modeline
set number
set ruler
set showcmd
set showmatch
set showmode

" Color scheme
colorscheme solarized

" Customize netrw
let g:netrw_silent=1
let g:netrw_banner=0
let g:netrw_liststyle=3
let g:netrw_dirhistmax=100
let g:netrw_browse_split=0
let g:netrw_preview=1
let g:netrw_winsize=25
" <Leader>e toggles the file explorer
autocmd BufEnter * nnoremap <expr> <Leader>e exists(':Rexplore') ? ':Rexplore<CR>' : ':Explore!<CR>'
" Within the file explorer, + is an alias for Ntree
autocmd FileType netrw nnoremap <buffer> + :Ntree<CR>
let g:netrw_browsex_viewer='mimeo'

" Customize terminal buffer
autocmd TermOpen * let g:terminal_scrollback_buffer_size=10000
" Always show line numbers
autocmd TermOpen * set number
" When in a terminal buffer, normal mode o is an alias to a
autocmd TermOpen * nnoremap <buffer> o a
" <C-e> to exit terminal mode
tnoremap <C-e> <C-\><C-n>
" <Leader>t opens terminal buffer
nnoremap <Leader>t :terminal<CR>

" <Leader>d to close buffer in a window split while preserving window split
nmap <Leader>d :b#<bar>bd#<CR>

" Customize lightline
function! LightlineModified()
  if &buftype == 'terminal'
    return ''
  endif
  if &modifiable
    return &modified ? '+' : '✓'
  endif
  return ''
endfunction

function! LightlineReadonly()
  return &readonly ? '' : ''
endfunction

function! LightlineLineinfo()
  return printf('%d/%d %d/%d', line('.'), line('$'), col('.'), col('$'))
endfunction

let g:lightline = {
  \   'colorscheme': 'solarized',
  \   'subseparator': { 'left': '', 'right': '' },
  \   'active': {
  \     'left': [ [ 'mode', 'filetype' ], [ 'filename' ] ],
  \     'right': [ [ 'lineinfo' ] , [ 'modified', 'readonly' ] ]
  \   },
  \   'component': {
  \     'filename': '%<%F'
  \   },
  \   'component_function': {
  \     'modified': 'LightlineModified',
  \     'readonly': 'LightlineReadonly',
  \     'lineinfo': 'LightlineLineinfo'
  \   }
  \ }

" Customize rainbow parentheses
autocmd VimEnter * RainbowParentheses
let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]

" Disable annoying autocompletion on sql files
let g:omni_sql_no_default_maps = 1

" vim-ormolu
autocmd BufWritePre *.hs :call RunOrmolu()

" Language Server Protocol configurations
" rust-analyzer
lua require'lspconfig'.rust_analyzer.setup({})
