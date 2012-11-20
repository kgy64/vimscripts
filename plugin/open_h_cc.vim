"This script provides easy navigation between source and header files
"Usage:
"\c  : Opens the corresponding .cc file if it exists
"\sc : Opens the corresponding .cc file in a new split if it exists
"\h  : Opens the corresponding .h file if it exists
"\sh : Opens the corresponding .h file in a new split if it exists
nnoremap <Leader>c :call Open_C(0)<CR>
nnoremap <Leader>h :call Open_H(0)<CR>
nnoremap <Leader>sc :call Open_C(1)<CR>
nnoremap <Leader>sh :call Open_H(1)<CR>

function! OpenAnyFile(p_name, p_split, p_forced)
    if a:p_name == @%
        return 1
    endif
    if !a:p_forced && !filereadable(a:p_name)
        return 0
    endif
    if a:p_split > 0
        exec "split"
    endif
    exec "e ".a:p_name
    return 1
endfunction

"open a file with "c", "cc", or "cpp" extension:
function! Open_C(p_split)
    let l:result = OpenAnyFile(expand("%:r").".c", a:p_split, 0)
    if l:result
        return
    endif
    let l:result = OpenAnyFile(expand("%:r").".cc", a:p_split, 0)
    if l:result
        return
    endif
    call OpenAnyFile(expand("%:r").".cpp", a:p_split, 1)
endfunction

"open a file with "h" extension:
function! Open_H(p_split)
    call OpenAnyFile(expand("%:r").".h", a:p_split, 1)
endfunction

