" custom colorscheme and statusline
try
  colorscheme badwolf
  let g:lightline = { 'colorscheme': 'seoul256' }
catch
  colorscheme ron
endtry

" smart auto-indenting
filetype indent plugin on

" do not create .netrwhist
let g:netrw_dirhistmax = 0

" do not use plaintex as default TeX filetype
let g:tex_flavor = "latex"

" turn syntax highlighting on
syntax on

" disable Background Color Erase (BCE) so that color schemes
" render properly when inside 256-color tmux and GNU screen.
" see also http://snk.tuxfamily.org/log/vim-256color-bce.html
if &term =~ '256color'
  set t_ut=
endif

" create vim folder and its subfolders
if !isdirectory($HOME."/.vim")
  call mkdir($HOME."/.vim", "", 0770)
endif
if !isdirectory($HOME."/.vim/backup")
  call mkdir($HOME."/.vim/backup", "", 0700)
endif
if !isdirectory($HOME."/.vim/swap")
  call mkdir($HOME."/.vim/swap", "", 0700)
endif
if !isdirectory($HOME."/.vim/undo")
  call mkdir($HOME."/.vim/undo", "", 0700)
endif

" change makeprg temporarily (https://stackoverflow.com/a/2405131)
function! LaTeXLint()
  let oldmakeprg = &l:makeprg
  setlocal errorformat=%f:%l:%c:%n:%m makeprg=chktex\ -v0\ -q\ '%'
  make
  let &l:makeprg = oldmakeprg
endfunction

" auto-complete words based on files and a dictionary
function! Tab_Or_Complete()
  if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
    return "\<C-N>"
  else
    return "\<Tab>"
  endif
endfunction

" remove trailing whitespaces (http://vi.stackexchange.com/a/456)
function! TrimWhitespace()
  let vsave = winsaveview()
  %s/\s\+$//e
  call winrestview(vsave)
endfunction

" insert characters automatically
inoremap (      ()<Left>
inoremap (<CR>  (<CR>)<ESC>O<Tab>
inoremap ((     (
inoremap ()     ()

inoremap [      []<Left>
inoremap [<CR>  [<CR>]<ESC>O<Tab>
inoremap [[     [
inoremap []     []

inoremap {      {}<Left>
inoremap {<CR>  {<CR>}<ESC>O<Tab>
inoremap {{     {
inoremap {}     {}

" remap tab to auto-complete
inoremap <Tab> <C-R>=Tab_Or_Complete()<CR>

" ctrl+s to save
inoremap <C-s> <Esc>:w<CR>
nnoremap <C-s> :w<CR>

" move lines up and down
inoremap <C-Up>     <Esc>:m-2<CR>==gi
inoremap <C-Down>   <Esc>:m+1<CR>==gi
nnoremap <C-Up>     :m-2<CR>==
nnoremap <C-Down>   :m+1<CR>==
xnoremap <C-Up>     :m-2<CR>gv=gv
xnoremap <C-Down>   :m'>+<CR>gv=gv

" toggle between relative and normal numbering
inoremap <F3> <Esc>:set relativenumber!<CR>
nnoremap <F3> :set relativenumber!<CR>

" toggle search highlighting
inoremap <F4> <Esc>:set hlsearch!<CR>
nnoremap <F4> :set hlsearch!<CR>

" toggle highlighting of unknown words
inoremap <F5> <Esc>:set spell!<CR>
nnoremap <F5> :set spell!<CR>

" compile according to file type
inoremap <F6> <Esc>:silent make<CR>
nnoremap <F6> :silent make<CR>

" call linter for LaTeX files
inoremap <F9> <Esc>:call LaTeXLint()<CR>
nnoremap <F9> :call LaTeXLint()<CR>

" group ensures that commands are applied only once
augroup configs
  " clears all the commands for the current group
  autocmd!

  " set syntax coloring for `sage`
  autocmd BufRead,BufNewFile *.sage setfiletype python

  " before saving, remove trailing whitespaces
  autocmd BufWritePre * call TrimWhitespace()

  " set errorformat for c files
  autocmd FileType c compiler gcc

  " 2 spaces for indenting c files
  autocmd FileType c setlocal tabstop=2 shiftwidth=2

  " 2 spaces for indenting cpp files
  autocmd FileType cpp setlocal tabstop=2 shiftwidth=2

  " `make` is `python` or `sage`, depending on file extension
  if expand("%:e") == "sage"
      autocmd FileType python setlocal makeprg=sage\ '%'
  else
      autocmd FileType python setlocal makeprg=python\ '%'
  endif

  " set errorformat for tex files
  autocmd FileType tex compiler tex

  " `make` is `latexmk`
  autocmd FileType tex setlocal makeprg=latexmk\ -silent\ -pdf\ '%'

  " `make` is `bash`, 2 spaces for indenting
  autocmd FileType sh setlocal makeprg=bash\ '%' tabstop=2 shiftwidth=2
augroup END

" keep indent from previous line if no filetype indent is specified
set autoindent

" allow backspace over autoindent, line breaks and start of insert action
set backspace=indent,eol,start

" centralised backup files
set backupdir^=$HOME/.vim/backup//

" set vim clipboard to usual one
set clipboard=unnamedplus

" ruler at 80 characters
set colorcolumn=80

" confirm quit
set confirm

" highlight current line
set cursorline

" centralised swapfiles (https://vi.stackexchange.com/a/179)
set directory^=$HOME/.vim/swap//

" expand tabs to spaces
set expandtab

" some useful format options according to fo-table
set formatoptions+=1 formatoptions+=j formatoptions+=n formatoptions+=p

" better undo history
set hidden

" search as characters are entered
set incsearch

" case insensitive search
set ignorecase

" always display the status line
set laststatus=2

" redraw only when needed
set lazyredraw

" enable mouse usage
set mouse=a

" do not insert two spaces after end of sentence
set nojoinspaces

" disable file modification by modeline
set nomodeline

" don't always go to first character of line
set nostartofline

" show line numbers on the left
set number

" use <F2> to toggle between paste mode
set pastetoggle=<F2>

" use interactive shell on vim
set shell=/bin/bash\ -i

" 1 tab equals tabstop spaces
set shiftwidth=0

" partial commands in last line of screen
set showcmd

" if a pattern has a capital letter then it is case sensitive
set smartcase

" spellcheck for these languages
set spelllang=en_gb,pt

" open multiple files with `vim -p`
set tabpagemax=64

" display tabs as four characters wide
set tabstop=4

" automatic word wrapping
set textwidth=79

" create undo directory
set undodir^=$HOME/.vim/undo//

" edit history persistent across file closure
set undofile

" create viminfo outside home
set viminfo+=n~/.vim/.viminfo

" better command-line completion
set wildmenu
