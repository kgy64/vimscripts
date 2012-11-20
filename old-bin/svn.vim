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

" ------------------------------------------------------------------------------
"
" My own svn-related stuff:
"

function! Svn_Blame()
  let l:saved_reg = @"
  let l:name = expand("%")
  if empty(l:name)
      let l:name = w:kgy_orig_name
  endif
  let l:currpos = line(".")
  if exists("w:kgy_row_offset")
    let l:currpos -= w:kgy_row_offset
  endif
  if exists("w:kgy_svn_revision")
    let l:svn_revision = w:kgy_svn_revision
  endif
  new
  let w:kgy_orig_name = l:name
  let w:kgy_row_offset = 3
  let l:currpos += w:kgy_row_offset
  if exists("l:svn_revision")
    let w:kgy_svn_revision = l:svn_revision
    let l:revision = ' -r ' . l:svn_revision
  else
    let l:revision = '@BASE'
  endif
  execute '$read ! $HOME/bin/vim/do-svn-command blame ' . l:name . l:revision
  normal ggdd
  call cursor(l:currpos, 1)
  let @"=l:saved_reg
endfunction

map <F12> :call Svn_Blame()<CR>

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! Svn_Blame_Mergeinfo()
  let l:saved_reg = @"
  let l:name = expand("%")
  if empty(l:name)
      let l:name = w:kgy_orig_name
  endif
  let l:currpos = line(".")
  if exists("w:kgy_row_offset")
    let l:currpos -= w:kgy_row_offset
  endif
  if exists("w:kgy_svn_revision")
    let l:svn_revision = w:kgy_svn_revision
  endif
  new
  let w:kgy_orig_name = l:name
  let w:kgy_row_offset = 3
  let l:currpos += w:kgy_row_offset
  if exists("l:svn_revision")
    let w:kgy_svn_revision = l:svn_revision
    let l:revision = ' -r ' . l:svn_revision
  else
    let l:revision = '@BASE'
  endif
  execute '$read ! $HOME/bin/vim/do-svn-blame ' . l:name . l:revision . ' --force -g'
  normal ggdd
  call cursor(l:currpos, 1)
  let @"=l:saved_reg
endfunction

map <S-F12> :call Svn_Blame_Mergeinfo()<CR>

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! Svn_MyDiff()
  let l:saved_reg = @"
  let l:filename = expand("%")
  let l:currpos = line(".")
  new
  execute ':silent! $read ! svn diff ' . l:filename
  execute ':set filetype=diff'
  call cursor(1, 1)
  execute "normal! dd"
  let @"=l:saved_reg
endfunction

map <A-F11> :call Svn_MyDiff()<CR>

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! Svn_Diff_Current()
  let l:saved_reg = @"
  let l:name = expand("%")
  if empty(l:name)
    let l:name = w:kgy_orig_name
  endif
  let l:revision = expand("<cword>")
  new
  execute ':silent! $read ! $HOME/bin/vim/do-svn-command log ' . l:name . ' -r ' . l:revision
  execute "normal! o"
  execute "normal! o### svn diff of revision " . l:revision . ":"
  execute ':silent! $read ! $HOME/bin/vim/do-svn-command diff ' . l:name . ' -c ' . l:revision
  execute ":1"
  execute "normal! dd"
  execute "normal! O### svn log of revision " . l:revision . ":"
  execute ":set filetype=diff"
  let @"=l:saved_reg
endfunction

map <S-F11> :call Svn_Diff_Current()<CR>

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! Svn_Diff()
  let l:saved_reg = @"
  let l:revision = expand("<cword>")
  new
  execute ':silent! $read ! $HOME/bin/vim/do-svn-command log . -r ' . l:revision
  execute "normal! o"
  execute "normal! o### svn diff of revision " . l:revision . ":"
  execute ':silent! $read ! $HOME/bin/vim/do-svn-command diff . -c ' . l:revision
  execute ":1"
  execute "normal! dd"
  execute "normal! O### svn log of revision " . l:revision . ":"
  execute ":set filetype=diff"
  let @"=l:saved_reg
endfunction

map <F11> :call Svn_Diff()<CR>

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! Svn_GetRevOfFile()
  let l:saved_reg = @"
  let l:revision = expand("<cword>")
  let l:orig_file_name = w:kgy_orig_name
  let l:currpos = line(".")
  if exists("w:kgy_row_offset")
      let l:currpos -= w:kgy_row_offset
  endif
  new
  execute '$read ! $HOME/bin/vim/do-svn-command cat ' . l:orig_file_name . ' -r ' . l:revision
  let w:kgy_orig_name = l:orig_file_name
  let w:kgy_svn_revision = l:revision
  call cursor(l:currpos, 1)
  let @"=l:saved_reg
endfunction

map <F10> :call Svn_GetRevOfFile()<CR>

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! Svn_GetPrevRevOfFile()
  let l:saved_reg = @"
  let l:revision = expand("<cword>")
  let l:prev_revision = l:revision
  let l:prev_revision -= 1
  let l:orig_file_name = w:kgy_orig_name
  let l:currpos = line(".")
  if exists("w:kgy_row_offset")
      let l:currpos -= w:kgy_row_offset
  endif
  new
  execute '$read ! $HOME/bin/vim/do-svn-command cat ' . l:orig_file_name . ' -r ' . l:prev_revision
  let w:kgy_orig_name = l:orig_file_name
  let w:kgy_svn_revision = l:prev_revision
  call cursor(l:currpos, 1)
  let @"=l:saved_reg
endfunction

map <S-F10> :call Svn_GetPrevRevOfFile()<CR>

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! Svn_Cat()
  let l:saved_reg = @"
  let l:filename = expand("%")
  let l:currpos = line(".")
  if exists("w:kgy_row_offset")
      let l:currpos -= w:kgy_row_offset
  endif
  new
  execute ':silent! $read ! svn cat ' . l:filename
  call cursor(l:currpos, 1)
  let @"=l:saved_reg
endfunction

map <A-F10> :call Svn_Cat()<CR>

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! Svn_Log()
  let l:saved_reg = @"
  let l:name = expand("%")
  if empty(l:name)
    let l:name = w:kgy_orig_name
  endif
  new
  execute "normal! O### svn log of file " . l:name . ":"
  let w:kgy_orig_name = l:name
  execute '$read ! $HOME/bin/vim/do-svn-command log ' . l:name . "@BASE"
  call cursor(1, 1)
  let @"=l:saved_reg
endfunction

map <F9> :call Svn_Log()<CR>

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! Svn_GetGivenRevOfFile()
  let l:saved_reg = @"
  let l:revision = input("Revision #")
  if !empty(l:revision)
    let l:currpos = line(".")
    if exists("w:kgy_row_offset")
        let l:currpos -= w:kgy_row_offset
    endif
    let l:orig_file_name = expand("%")
    new
    let w:kgy_orig_name = l:orig_file_name
    let w:kgy_svn_revision = l:revision
    execute '$read ! $HOME/bin/vim/do-svn-command cat ' . l:orig_file_name . ' -r ' . l:revision
    call cursor(l:currpos, 1)
  endif
  let @"=l:saved_reg
endfunction

map <S-F9> :call Svn_GetGivenRevOfFile()<CR>

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! Svn_DoRevert(name)
  execute ':! $HOME/bin/vim/do_svn_revert "' . a:name . '"'
endfunction

function! Svn_Revert()
  let l:saved_reg = @"
  let l:filename = expand("%")
  if empty(l:filename)
    let l:curpos = line(".")
    if exists("w:kgy_row_offset")
        let l:currpos -= w:kgy_row_offset
    endif
    let l:found = search("^Index: ", "bcW")
    if (l:found == 0)
      execute 'echo "Error: no filename and not in diff file."'
      return
    endif
    normal w
    let l:filename = expand("<cfile>")
    call cursor(l:curpos, 1)
  endif
  call Svn_DoRevert(l:filename)
  let @"=l:saved_reg
endfunction

map <F8> :call Svn_Revert()<CR>

" * * * * * * * * * * * * * * * * End - of - File * * * * * * * * * * * * * * * *
