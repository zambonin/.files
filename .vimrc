colorscheme badwolf
let g:lightline = { 'colorscheme': 'seoul256' }

" smart auto-indenting
filetype indent plugin on

" disable Background Color Erase (BCE) so that color schemes
" render properly when inside 256-color tmux and GNU screen.
" see also http://snk.tuxfamily.org/log/vim-256color-bce.html
if &term =~ '256color'
  set t_ut=
endif

" auto-complete words based on files and a dictionary
function! Tab_Or_Complete()
    if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
        return "\<C-N>"
    else
        return "\<Tab>"
    endif
endfunction

" toggle between relative and normal line numbering
" (http://vim.wikia.com/wiki/Autocomplete_with_TAB_when_typing_words)
function! ToggleNumber()
    if (&relativenumber == 1)
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunction

" remove trailing whitespaces (http://vi.stackexchange.com/a/456)
function! TrimWhitespace()
    let vsave = winsaveview()
    %s/\s\+$//e
    call winrestview(vsave)
endfunction

autocmd BufWritePre * :call TrimWhitespace()

" insert characters automatically
inoremap <      <><Left>

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

" toggle between relative and normal numbering
inoremap <F3> <Esc>:call ToggleNumber()<CR>
nnoremap <F3> :call ToggleNumber()<CR>

" enable or disable search highlighting
inoremap <F4> <Esc>:set hlsearch!<CR>
nnoremap <F4> :set hlsearch!<CR>

" toggle highlighting of unknown words
inoremap <F5> <Esc>:set spell! spelllang=en,pt-BR<CR>
nnoremap <F5> :set spell! spelllang=en,pt-BR<CR>

" move lines up and down
inoremap <C-Up>     <Esc>:m-2<CR>==gi
inoremap <C-Down>   <Esc>:m+1<CR>==gi
nnoremap <C-Up>     :m-2<CR>==
nnoremap <C-Down>   :m+1<CR>==
xnoremap <C-Up>     :m-2<CR>gv=gv
xnoremap <C-Down>   :m'>+<CR>gv=gv

" do not create .netrwhist
let g:netrw_dirhistmax = 0

" keep indent from previous line if no filetype indent is specified
set autoindent

" allow backspace over autoindent, line breaks and start of insert action
set backspace=indent,eol,start

" ruler at 80 characters
set colorcolumn=80

" confirm quit
set confirm

" highlight current line
set cursorline

" expand tabs to spaces
set expandtab

" better undo history
set hidden

" case insensitive search
set ignorecase

" always display the status line
set laststatus=2

" redraw only when needed
set lazyredraw

" enable mouse usage
set mouse=a

" don't always go to first character of line
set nostartofline

" show line numbers on the left
set number

" use <F2> to toggle between paste mode
set pastetoggle=<F2>

" use interactive shell on vim
set shell=/bin/bash\ -i

" 1 tab equals four spaces
set shiftwidth=4

" partial commands in last line of screen
set showcmd

" if a pattern has a capital letter then it is case sensitive
set smartcase

" display tabs as four characters wide
set tabstop=4

" better command-line completion
set wildmenu

" turn syntax highlighting on
syntax on

" ctrl+c for copying to external clipboard (needs +clipboard)
vnoremap <C-c> "*y
