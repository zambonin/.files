colorscheme badwolf
let g:lightline = { 'colorscheme': 'seoul256' }

" smart auto-indenting
filetype indent plugin on

" auto-complete words based on files and a dictionary
function! Tab_Or_Complete()
    if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
        return "\<C-N>"
    else
        return "\<Tab>"
    endif
endfunction

" toggle between relative and normal line numbering
function! ToggleNumber()
    if (&relativenumber == 1)
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunction

" insert characters automatically
inoremap <      <><Left>
inoremap "      ""<Left>
inoremap '      ''<Left>

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

" esc twice to save
map <Esc><Esc> :w<CR>

" toggle between relative and normal numbering
nnoremap <F3> :call ToggleNumber()<CR>

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

" dictionary file
set dictionary="/usr/share/dict/cracklib-small"

" expand tabs to spaces
set expandtab

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
