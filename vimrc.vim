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
" Create an undofile in $HOME/tmp.
set undofile undodir=$HOME/tmp

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

if !has('termresponse') || !exists('&t_u7') || &t_u7 == ''
  " Show "ambiguous-width" characters in double-width.
  set ambiwidth=double
endif

if exists('&t_Co')
  " enable 256-color terminal. It enables molokai colorscheme in a terminal.
  set t_Co=256
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

" Disable AutoComplPop
let g:acp_enableAtStartup = 0
" Enable neocomplete.
let g:neocomplete#enable_at_startup = 1
" Enable smartcase in neocomplete.
let g:neocomplete#enable_smart_case = 1

" Define dictionary for completion.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
    \ }

" Define keywords.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ neocomplete#start_manual_complete()
function! s:check_back_space() abort "{{{
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=jedi#completions
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns = {}
endif

" Enable autocompletion for vimtex.
" let g:neocomplete#sources#omni#input_patterns.tex =
let g:neocomplete#force_omni_input_patterns.tex =
      \ '\v\\%('
      \ . '\a*cite\a*%(\s*\[[^]]*\]){0,2}\s*\{[^}]*'
      \ . '|\a*ref%(\s*\{[^}]*|range\s*\{[^,}]*%(}\{)?)'
      \ . '|hyperref\s*\[[^]]*'
      \ . '|includegraphics\*?%(\s*\[[^]]*\]){0,2}\s*\{[^}]*'
      \ . '|%(include%(only)?|input)\s*\{[^}]*'
      \ . '|\a*(gls|Gls|GLS)(pl)?\a*%(\s*\[[^]]*\]){0,2}\s*\{[^}]*'
      \ . '|includepdf%(\s*\[[^]]*\])?\s*\{[^}]*'
      \ . '|includestandalone%(\s*\[[^]]*\])?\s*\{[^}]*'
      \ . ')'

" Use jedi for python
"let g:jedi#popup_select_first = 0
let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0
let g:neocomplete#force_omni_input_patterns.python = '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'

"let g:neocomplete#sources#omni#input_patterns.php =
"\ '[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
"let g:neocomplete#sources#omni#input_patterns.c =
"\ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?'
"let g:neocomplete#sources#omni#input_patterns.cpp =
"\ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'

" " For perlomni.vim setting.
" " https://github.com/c9s/perlomni.vim
" let g:neocomplete#sources#omni#input_patterns.perl =
" \ '[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'

" For smart TAB completion.
"inoremap <expr><TAB>  pumvisible() ? "\<C-n>" :
"        \ <SID>check_back_space() ? "\<TAB>" :
"        \ neocomplete#start_manual_complete()
"  function! s:check_back_space() "{{{
"    let col = col('.') - 1
"    return !col || getline('.')[col - 1]  =~ '\s'
"  endfunction"}}}

" Disable spell-checking in general, but enable for certain filetypes.
set nospell
autocmd FileType markdown,html,tex setlocal spell
" Disable spell-checking for Japanese.
set spelllang=en,cjk


" Borrowed from pathogen#helptags, but detects translated docs also.
function! Myhelptags() abort
  let sep = pathogen#slash()
  for glob in pathogen#split(&rtp)
    for dir in map(split(glob(glob), "\n"), 'v:val.sep."/doc/".sep')
      if (dir)[0 : strlen($VIMRUNTIME)] !=# $VIMRUNTIME.sep && filewritable(dir) == 2 && !empty(split(glob(dir.'*.txt'))+split(glob(dir.'*.??x'))) && (!filereadable(dir.'tags') || filewritable(dir.'tags'))
        silent! execute 'helptags' pathogen#fnameescape(dir)
      endif
    endfor
  endfor
endfunction

" Replace existing pathogen#helptags.
command! -bar Helptags :call Myhelptags()

" Prefer Japanese help to English.
set helplang=ja,en

" Automatically open the quickfix window on :make/:grep/etc.
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

" Use markdown for *.md
autocmd BufRead,BufNewFile *.md setlocal filetype=markdown
" Use llvm for *.ll
autocmd BufNewFile,BufRead *.ll setlocal ft=llvm
" Use 4-space indenting for rust
autocmd FileType rust setlocal sts=4 sw=4 et
" Use 4-space indenting for python
autocmd FileType python setlocal sts=4 sw=4 et

" Editorconfig configuration
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
