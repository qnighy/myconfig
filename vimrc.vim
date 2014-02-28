if has("win32")
  if $LANG ==? "ja"
    let $LANG='ja_JP.UTF-8'
  endif
  set encoding=utf-8
endif

let &runtimepath=expand("<sfile>:p:h")."/vim,".expand("<sfile>:p:h")."/vim/after,".&runtimepath
let &runtimepath=expand("<sfile>:p:h")."/vim/bundle/vim-pathogen,".&runtimepath

call pathogen#infect()

set nocompatible

set title titlestring=V>%F

set backspace=2
set iminsert=0 imsearch=-1

set autoindent smartindent smarttab
set expandtab tabstop=8 softtabstop=2 shiftwidth=2

"set textwidth=0
"set wrapmargin=0

set scrolloff=2

set history=1000
set backup
set nowritebackup
set backupdir=$HOME/tmp
set swapfile
set directory=$HOME/tmp

set incsearch hlsearch
set noignorecase nosmartcase
set wrapscan
set magic

syntax on
set list
set listchars=tab:>\-,trail:-
let &listchars = &listchars . ",eol:\xab"
highlight NonText guifg=lightblue

set whichwrap=b,s,h,l,<,>,[,]
set showmatch
set laststatus=2
set showcmd
set ambiwidth=double

"set number
set ruler

set showcmd
set wildmenu

set mouse=a
set ttymouse=xterm2

filetype plugin indent on

highlight ZenkakuSpace cterm=underline ctermfg=red gui=underline guifg=red guibg=#AAFFFF
match ZenkakuSpace /\%u3000\|\%x81\%x40\|\xa1\xa1/

"highlight UnderScore cterm=underline gui=underline
"match UnderScore /_/


set modeline
" set guifont=Monospace
set guioptions=abcriL

set shortmess=axtToOI

au BufRead,BufNewFile *.ijx set filetype=j
au BufRead,BufNewFile *.ijs set filetype=j
au BufRead,BufNewFile *.scala set filetype=scala
au BufRead,BufNewFile *.md set filetype=markdown
" au BufRead,BufNewFile tls-state.txt set filetype=state-machine

" command Hoge :let b:eruby_subtype="ruby"

" let c_no_curly_error=1

hi CursorIM  guifg=black  guibg=red  gui=NONE  ctermfg=black  ctermbg=white  cterm=reverse

