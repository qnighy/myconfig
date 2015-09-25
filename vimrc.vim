if has("win32")
  if $LANG ==? "ja"
    let $LANG='ja_JP.UTF-8'
  endif
  set encoding=utf-8
endif

if !has('clientserver')
  let g:loaded_asynccommand = 0
endif

let &runtimepath=expand("<sfile>:p:h")."/vim,".expand("<sfile>:p:h")."/vim/after,".&runtimepath
let &runtimepath=expand("<sfile>:p:h")."/vim/bundle/vim-pathogen,".&runtimepath

call pathogen#infect()
Helptags

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

au BufRead,BufNewFile *.md set filetype=markdown

" let c_no_curly_error=1

hi CursorIM  guifg=black  guibg=red  gui=NONE  ctermfg=black  ctermbg=white  cterm=reverse

" neocomplcache
let g:acp_enableAtStartup = 0
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : ''
    \ }

inoremap <expr><C-g> neocomplcache#undo_completion()
inoremap <expr><C-l> neocomplcache#complete_common_string()

inoremap <silent> <CR> <C-R>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplcache#smart_close_popup() . "\<CR>"
endfunction

inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y> neocomplcache#close_popup()
inoremap <expr><C-e> neocomplcache#cancel_popup()

autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

autocmd BufNewFile,BufRead *.ll setlocal ft=llvm
autocmd FileType rust setlocal sts=4 sw=4 et
autocmd FileType python setlocal sts=4 sw=4 et
