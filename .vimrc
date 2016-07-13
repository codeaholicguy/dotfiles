" Leader
let mapleader = " "

set backspace=2   " Backspace deletes like most programs in insert mode
set nobackup
set nowritebackup
set noswapfile
set history=50
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set incsearch     " do incremental searching
set laststatus=2  " Always display the status line
set autowrite     " Automatically :write before running commands

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

" Make it obvious where 80 characters is
set textwidth=80
set colorcolumn=+1

" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·

" Use one space, not two, after punctuation.
set nojoinspaces

" Numbers
set number
set numberwidth=5

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Autocomplete with dictionary words when spell check is on
set complete+=kspell

" Always use vertical diffs
set diffopt+=vertical

set t_8f=[38;2;%lu;%lu;%lum
set t_8b=[48;2;%lu;%lu;%lum

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

set lazyredraw
set termguicolors

set background=dark
colorscheme base16-ocean

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

filetype plugin indent on

" When the type of shell script is /bin/sh, assume a POSIX-compatible
" shell for syntax highlighting purposes.
let g:is_posix = 1

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag -Q -l --nocolor --hidden -g "" %s'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction
inoremap <Tab> <c-r>=InsertTabWrapper()<cr>
inoremap <S-Tab> <c-n>

" Use tab with text block
vmap <Tab> >gv
vmap <S-Tab> <gv

" Switch between the last two files
nnoremap <leader><leader> <c-^>

" Get off my lawn
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

nnoremap <Leader>\ :vsplit<CR>
nnoremap <Leader>/ :split<CR>
nnoremap <Leader>wh :wincmd h<CR>
nnoremap <Leader>wl :wincmd l<CR>
nnoremap <Leader>wk :wincmd k<CR>
nnoremap <Leader>wj :wincmd j<CR>

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Airline
let g:airline_theme='base16_ocean'
let g:airline_powerline_fonts=1
let g:airline#extensions#whitespace#enabled=0

" Autocomplete using deoplete
let g:deoplete#enable_at_startup = 1
let g:tern_request_timeout = 1
let g:tern_show_signature_in_pum = 0  " This do disable full signature type on autocomplete

" Copy to clipboard
set clipboard=unnamed

" Configure syntax checking to check on open as well as save
autocmd! BufWritePost * Neomake
