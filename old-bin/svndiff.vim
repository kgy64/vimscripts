" ViM script to provide easy navigation in an svn diff
"
" Usage is to simply call 'vim -S svndiff.vim' in the directory where you want to make the diff.
" After that ;r or \r  reads in the initial diff.
"
" After that (in normal mode) ;g or \g  brings you to the code that corresponds to the code in the
" diff where the cursor is. ;d or \d opens the original file in diff mode thus you can investigate
" the original and the modified file line by line
"
" If you have done some changes in the code you can refresh the diff with ;r or \r
"

function! Refreshdiff()
    if (&filetype != "diff")
        echo "Not a diff file"
        return
    endif
    " Save the value of the unnamed register
    let l:saved_reg = @"
    let orig_lineno=line(".")
    normal ggdG
    r !sd 2>/dev/null | dos2unix
    normal ggdd
    set filetype=diff
    call cursor(orig_lineno,0)
    " Restore the value of the unnamed register
    let @"=l:saved_reg
endfunction

function! GoToMyFile()
    if (&filetype != "diff")
	echo "Not a diff file"
	return
    endif
    " Save the value of the unnamed register
    let l:saved_reg = @"
    normal ^
    split
    "remember current position
    let currpos = line(".")
    let difference = 0
    "search for original file name
    call search("^ \\*\\*\\* FILE\\>", "bW")
    "open original file with command 'gf'
    normal wwwgf
    " Restore the value of the unnamed register
    let @"=l:saved_reg
endfunction

function! GoToFile()
    if (&filetype != "diff")
	echo "Not a diff file"
	return
    endif
    " Save the value of the unnamed register
    let l:saved_reg = @"
    normal ^
    split
    "remember current position
    let currpos = line(".")
    let difference = 0
    let str = getline(".")
    while match(str, "@@", 0) == -1
        if match(str, "-", 0) != 0
            let difference = difference + 1
        endif
        normal -
        let str = getline(".")
    endwhile
    "we are at the right position
    "store the line number in orig. file in @z
    normal 6w"zye^
    "search for original file name
    call search("^+++", "bW")
    "open original file with command 'gf'
    normal wgf
    let origfilelineno = @z
    "go to the right position :)
    call cursor(origfilelineno + difference - 1, 1)
    " Restore the value of the unnamed register
    let @"=l:saved_reg
endfunction

function! OpenDiff()
    let l:fname=@%
    let l:fnamePatch = l:fname . ".s2patch"
    let l:fnameOrig = l:fname . ".s2orig"
    exec "!svn diff " . l:fname . " >" . l:fnamePatch
    exec "!patch -o " . l:fnameOrig . " -R " . l:fname . " <" . l:fnamePatch
    exec "vert diffsplit " . l:fnameOrig
    exec "au BufDelete <buffer> !rm " . l:fnameOrig
    exec "au BufDelete <buffer> !rm " . l:fnamePatch
endfunction

nmap ;g :call GoToFile()<CR>
nmap ;r :call Refreshdiff()<CR>
nmap ;d :call OpenDiff()<CR>
set filetype=diff

nmap <Leader>g :call GoToFile()<CR>
nmap <Leader>f :call GoToMyFile()<CR>
nmap <Leader>r :call Refreshdiff()<CR>
nmap <Leader>d :call OpenDiff()<CR>

" automatically load the initial diff
" TODO - commented out for now, because this breaks the case when the diff is piped in
"normal ;r
