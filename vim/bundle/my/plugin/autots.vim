if exists("loaded_autots")
  finish
endif

function! AutoTS()
    setlocal ts=8
    if search("^\t","nw") > 0
        setlocal noexpandtab
        if search("^      ","nw") > 0
            setlocal sts=2 sw=2
        elseif search("^    ","nw") > 0
            setlocal sts=4 sw=4
        elseif search("^  ","nw") > 0
            setlocal sts=2 sw=2
        else
            setlocal sts=8 sw=8
        endif
    else
        if search("^  [^ ]","nw") > 0
            setlocal expandtab
            setlocal sts=2 sw=2
        elseif search("^    [^ ]","nw") > 0
            setlocal expandtab
            setlocal sts=4 sw=4
        endif
    endif
endfunction

augroup autots
    au!
    au BufRead * call AutoTS()
augroup END

