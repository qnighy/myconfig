scriptencoding utf-8
" vim:set ts=8 sts=2 sw=2 tw=0 et:

" Force enable vim functionality. (Perhaps redundant)
set nocompatible


if has("win32")
  " Force UTF-8 in $LANG.
  if $LANG ==? "ja"
    let $LANG='ja_JP.UTF-8'
  endif
  " Force UTF-8 encoding.
  set encoding=utf-8
endif

if !has('clientserver')
  " Disable AsyncCommand in -clientserver environment (like in Cygwin)
  let g:loaded_asynccommand = 0
endif

" Before overriding runtimepath, set netrwhome as the first element of
" runtimepath.
let g:netrw_home=split(&runtimepath,',')[0]

" Use pathogen to add bundles o &runtimepath.
exec "source ".expand("<sfile>:p:h")."/vim/bundle/vim-pathogen/autoload/pathogen.vim"
exec pathogen#infect(expand("<sfile>:p:h")."/vim/bundle/{}")

" Set window title
" %f: absolue/relative path
set title
let &titlestring="vim %f"

" Allow backspace go beyond autoindents, eol, and starting point of insert mode.
set backspace=indent,eol,start

" Disable input methods in insert/search by default.
set iminsert=0 imsearch=-1

" Use smart indenting method.
set autoindent smartindent

" Set the width of hard tabs as 8 (default).
set tabstop=8

" Enable soft tab.
set smarttab
" Insert two spaces when tab is hit at the head of the line.
set shiftwidth=2
" Insert two spaces when tab is hit at the middle of the line.
set softtabstop=2
" Don't convert 8 spaces into a tab.
set expandtab

" Disable hard text wrapping.
set textwidth=0
set wrapmargin=0

" Always show at least 2 lines above/below the current line.
set scrolloff=2

" Number of command/search history entries to save.
set history=1000

" Create a backup in $HOME/tmp only when writing.
set nobackup writebackup backupdir=$HOME/tmp
" Create a swapfile in $HOME/tmp.
set swapfile directory=$HOME/tmp

" Use highlighted incremental search.
set incsearch hlsearch
" Ignore case only when there is no capital letter. Use \C to override it.
set ignorecase smartcase
" Wrap to the top/bottom when forward/backward search finishes.
set wrapscan
" Change the behavior of regexp.
set magic

" Enable syntax highlighting.
syntax enable

" Set alternative characters to show.
" Hard tabs are replaced with >-------.
" Trailing spaces are replaced with -.
" « is shown in every end-of-line.
set list
" set listchars=tab:>-,trail:-,eol:«
let &listchars="tab:>-,trail:-,eol:«"

" Allow cursor go across lines in these actions.
" b: backspace in normal/visual
" s: space in normal/visual
" h: H in normal/visual
" l: L in normal/visual
" <: Left in normal/visual
" >: Right in normal/visual
" ~: ~ in normal
" [: Left in insert/replace
" ]: Right in insert/replace
set whichwrap=b,s,h,l,<,>,~,[,]

" When parentheses/brackets/etc. are input, move to the matching one for a moment.
set showmatch

" Always show the status line.
set laststatus=2
" Show the command line.
set showcmd

if !has('termresponse') || &t_u7 == ''
  " Show "ambiguous-width" characters in double-width.
  set ambiwidth=double
endif

" Show ruler (column/row number) in the status line.
set ruler

" Enable wild menu.
set wildmenu

" Enable mouse in normal/visual/insert/command.
set mouse=a

" Assume we have xterm2-compatible terminal.
set ttymouse=xterm2

" Enable filetype-dependent plugin and indent and autodetection.
filetype plugin indent on

" Highlight the zenkaku-space character to avoid confusion.
highlight ZenkakuSpace cterm=underline ctermfg=red gui=underline guifg=red guibg=#AAFFFF
match ZenkakuSpace /\%u3000\|\%x81\%x40\|\xa1\xa1/

"highlight UnderScore cterm=underline gui=underline
"match UnderScore /_/


" Check for modelines in the first 5 lines in a file.
set modeline modelines=5

" a: Use "+ for visual selection.
" c: Use console dialog instead of visual dialog
" i: Use vim icon.
" !m: Do not show the menubar.
" !T: Do not show the toolbar.
" r: always show right scroll bars.
" L : only show left scroll bars when windows are vertically split.
" b: show horizontal scroll bars.
set guioptions=acirLb

" Shorten certain messages.
" a: same as filmnrwx.
" f: (3 of 5) instead of (file 3 of 5)
" i: [noeol] instead of [Incomplete last line]
" l: [999L, 888C] instead of 999 lines, 888 characters
" m: [+] instead of [Modified]
" n: [New] instead of [New File]
" r: [RO] instead of [readonly]
" w: [w]/[a] instead of written/appended
" x: [dos]/[unix]/[mac] instead of [dos format]/[unix format]/[mac format]
" o: overwrite read after write.
" O : overwrite read/quickfix after something.
" t: truncate file messages
" T : truncate other messages
" I : don't give the intro message
set shortmess=axoOtTI

" Use molokai color scheme.
colorscheme molokai

" let c_no_curly_error=1

" highlight cursor as red when using input methods.
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

" Use markdown for *.md
autocmd BufRead,BufNewFile *.md setlocal filetype=markdown
" Use llvm for *.ll
autocmd BufNewFile,BufRead *.ll setlocal ft=llvm
" Use 4-space indenting for rust
autocmd FileType rust setlocal sts=4 sw=4 et
" Use 4-space indenting for python
autocmd FileType python setlocal sts=4 sw=4 et
