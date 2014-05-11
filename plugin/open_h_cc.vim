"This script provides easy navigation between source and header files
"Usage:
"\c  : Opens the corresponding C/C++ file if it exists
"\sc : Opens the corresponding C/C++ file in a new split if it exists
"\h  : Opens the corresponding header file if it exists
"\sh : Opens the corresponding header file in a new split if it exists
nnoremap <Leader>c :call Open_C(0)<CR>
nnoremap <Leader>h :call Open_H(0)<CR>
nnoremap <Leader>sc :call Open_C(1)<CR>
nnoremap <Leader>sh :call Open_H(1)<CR>

function! OpenAnyFile(p_name, p_ext, p_split, p_forced)
    let l:new_name = substitute(a:p_name, "\M\\|.cpp$\\|.cc$\\|.c$\\|.h$", a:p_ext, "")
    if l:new_name == @%
        return 1
    endif
    if !a:p_forced && !filereadable(l:new_name)
        return 0
    endif
    if a:p_split > 0
        exec "split"
    endif
    exec "e ".l:new_name
    return 1
endfunction

"open a file with "c", "cc", or "cpp" extension:
function! Open_C(p_split)
    if exists("w:kgy_orig_name")
        let l:filename = w:kgy_orig_name
    else
        let l:filename = expand("%")
    endif
    if OpenAnyFile(l:filename, ".c", a:p_split, 0)
        return
    endif
    if OpenAnyFile(l:filename, ".cc", a:p_split, 0)
        return
    endif
    call OpenAnyFile(l:filename, ".cpp", a:p_split, 1)
endfunction

"open a file with "h" extension:
function! Open_H(p_split)
    if exists("w:kgy_orig_name")
        let l:filename = w:kgy_orig_name
    else
        let l:filename = expand("%")
    endif
    call OpenAnyFile(l:filename, ".h", a:p_split, 1)
endfunction

