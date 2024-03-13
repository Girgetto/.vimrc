" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

" File explorer
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" Fuzzy file finding
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Git integration and utilities
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

" TypeScript and JavaScript syntax
Plug 'HerringtonDarkholme/yats.vim' " TS Syntax
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'

" General syntax highlight
Plug 'metakirby5/codi.vim'

" Commenting utility
Plug 'scrooloose/nerdcommenter'

" Tag auto-closing for HTML, XML, etc.
Plug 'alvan/vim-closetag'

" Surrounding characters shortcuts
Plug 'tpope/vim-surround'

" Vim UI enhancements
Plug 'vim-airline/vim-airline'

" Color scheme
Plug 'joshdick/onedark.vim'

" Integration with Tmux
Plug 'christoomey/vim-tmux-navigator'

" Intellisense engine
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Initialize plugin system
call plug#end()

" Vim Basic Settings
set number                   " Show line numbers
set relativenumber           " Show relative line numbers
syntax on                    " Enable syntax highlighting
colorscheme onedark          " Set colorscheme to onedark
set encoding=utf-8           " Use UTF-8 encoding

" Key Bindings
" Exit insert mode with 'jk'
inoremap jk <ESC>
" Toggle NERDTree with Ctrl+n
nmap <C-n> :NERDTreeToggle<CR>
" Toggle commenting in visual mode with ++
vmap ++ <plug>NERDCommenterToggle 
" Toggle commenting in normal mode with ++
nmap ++ <plug>NERDCommenterToggle
" Call :GFiles with Ctrl+p
nnoremap <C-p> :GFiles<CR> 
nnoremap <leader>pf :Files<CR> 

" NERDTree Configuration
let g:NERDTreeGitStatusWithFlags = 1  " Show git status flags in NERDTree
let g:NERDTreeWinPos = "right"        " Set NERDTree window position to right
let g:NERDTreeIgnore = ['^node_modules$']  " Ignore node_modules in NERDTree

" Coc (Conquer of Completion) Configuration
" List of CoC extensions

let g:coc_global_extensions = [      
  \ 'coc-snippets',
  \ 'coc-pairs',
  \ 'coc-tsserver',
  \ 'coc-eslint', 
  \ 'coc-prettier', 
  \ 'coc-json', 
  \ ]
set hidden                          " Required for some CoC functionalities
set nobackup                        " Disable backup files
set nowritebackup                   " Disable write backup files
set cmdheight=2                     " Set command line height for better display
set updatetime=300                  " Faster completion trigger
set shortmess+=c                    " Avoid showing extra messages during completion
set signcolumn=yes                  " Always show the sign column

" Coc Key Mappings
" Use Tab for various completions and navigations
inoremap <silent><expr> <TAB> coc#pum#visible() ? coc#pum#next(1) : CheckBackspace() ? "\<Tab>" : coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Use Enter to accept completion and format
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use Ctrl+Space to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Goto mappings
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <F2> <Plug>(coc-rename)

" Format mappings
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Coc Commands
command! -nargs=0 Prettier :CocCommand prettier.formatFile  " Format file with Prettier
command! -nargs=0 Format :call CocAction('format')          " Format current buffer
command! -nargs=? Fold :call CocAction('fold', <f-args>)    " Fold current buffer
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')  " Organize imports

" Vim-Tmux-Navigator Configuration
let g:tmux_navigator_no_mappings = 1  " Disable default tmux navigator mappings
" Custom Tmux navigation mappings
noremap <silent> {Left-Mapping} :<C-U>TmuxNavigateLeft<cr>
noremap <silent> {Down-Mapping} :<C-U>TmuxNavigateDown<cr>
noremap <silent> {Up-Mapping} :<C-U>TmuxNavigateUp<cr>
noremap <silent> {Right-Mapping} :<C-U>TmuxNavigateRight<cr>
noremap <silent> {Previous-Mapping} :<C-U>TmuxNavigatePrevious<cr>

" Formatting and Indentation
set smarttab
set cindent
set tabstop=2
set shiftwidth=2
set expandtab
set scrolloff=8

let mapleader = " "

" Functions and Autocommands
function! IsNERDTreeOpen() " Check if NERDTree is open
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

function! SyncTree() " Sync NERDTree with current file
  if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
    NERDTreeFind
    wincmd p
  endif
endfunction

autocmd BufRead * call SyncTree()  " Call SyncTree on buffer read

function! s:check_back_space() " Check for backspace
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" CtrlP Configuration
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']  " CtrlP command for Git

" Autocommands for Coc Actions
autocmd CursorHold * silent call CocActionAsync('highlight')  " Highlight symbol under cursors

nnoremap <leader><CR> :so ~/.nvimrc<CR> " Reload .nvimrc with leader + Enter
inoremap <C-c> <ESC>  " use ctrl + c to escape insert mode
nnoremap <C-j> :cnext<CR>  " use ctrl + j to go next in quickfix
nnoremap <C-k> :cprev<CR>  " use ctrl + k to go previous in quickfix

" Set guidcursor to avoid change cursor shape
set guicursor=
