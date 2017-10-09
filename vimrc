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

set autoindent
set smartindent

set autoread
set autowrite

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
set relativenumber
set number
set numberwidth=5

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Autocomplete with dictionary words when spell check is on
set complete+=kspell

" Always use vertical diffs
set diffopt+=vertical

" Copy to clipboard
set clipboard=unnamed

set lazyredraw
set termguicolors

set background=dark
colorscheme dracula

filetype plugin indent on

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

augroup vimrcEx
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
        \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile Appraisals set filetype=ruby
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd BufRead,BufNewFile .{eslint,babel}rc set filetype=json
augroup END

" When the type of shell script is /bin/sh, assume a POSIX-compatible
" shell for syntax highlighting purposes.
let g:is_posix = 1

" Use tab with text block
vmap <Tab> >gv
vmap <S-Tab> <gv

" Get off my lawn
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

nnoremap <Leader>\ :vsplit<CR>
nnoremap <Leader>/ :split<CR>

nnoremap <Leader>w :w<CR>

" Remove highlight
map <F3> :nohl<CR>

" Python support
let g:python2_host_prog = '/usr/local/bin/python'
let g:python3_host_prog = '/usr/local/bin/python3'

" Airline
let g:airline_theme = 'dracula'
let g:airline_powerline_fonts = 1
let g:airline#extensions#whitespace#enabled = 0

" Autocomplete using deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1

let g:tern#command = ['tern']
let g:tern#filetypes = ['js', 'jsx', 'vue']

" Configure syntax checking to check on open as well as save
autocmd! BufWritePost * Neomake

let s:eslint_path = system('PATH=$(npm bin):$PATH && which eslint')
let g:neomake_javascript_eslint_exe = substitute(s:eslint_path, '^\n*\s*\(.\{-}\)\n*\s*$', '\1', '')
let g:neomake_javascript_enabled_makers = ['eslint']
let g:neomake_open_list = 2
let g:neomake_list_height = 5

" NERD tree configuration
map <F2> :NERDTreeToggle<CR>

" Multi select
let g:multi_cursor_next_key='<C-n>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'

" fzf
nnoremap <F12> :Files<CR>

" bind \ (backward slash) to grep shortcut
nnoremap \ :Ag<SPACE>


" Formats file automatically on save
" autocmd BufWritePre Neoformat
nnoremap <Leader>f :Neoformat<CR>

" Execute command in tmux
nnoremap = :VimuxPromptCommand<CR>

" Vim JavaScript
let g:javascript_plugin_flow = 1
let g:javascript_plugin_jsdoc = 1

" Flow
nnoremap ] :FlowJumpToDef<CR>

let g:flow#enable = 0
