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
    if (!exists("w:kgy_filetype") || w:kgy_filetype != "diff")
        echo "Error: Not a diff file"
        return
    endif
    " Save the value of the unnamed register
    let l:saved_reg = @"
    let orig_lineno=line(".")
    normal ggdG
    r !sd 2>/dev/null
    normal ggdd
    execute ':set filetype=diff'
    call cursor(orig_lineno,0)
    " Restore the value of the unnamed register
    let @"=l:saved_reg
endfunction

function! GoToMyFile()
    if (!exists("w:kgy_filetype") || w:kgy_filetype != "diff")
      echo "2 Not a diff file"
      return
    endif
    " Save the value of the unnamed register
    let l:saved_reg = @"
    normal ^
    split
    let difference = 0
    "search for original file name
    call search("^ \\*\\*\\* FILE\\>", "bW")
    "open original file with command 'gf'
    normal wwwgf
    " Restore the value of the unnamed register
    let @"=l:saved_reg
endfunction

function! GoToFile()
    if (!exists("w:kgy_filetype") || w:kgy_filetype != "diff")
        let l:filetype=&ft
        if (l:filetype != "diff")
            echo "3 Not a diff file"
            return
        endif
    endif
    " Save the value of the unnamed register
    let l:saved_reg = @"
    normal ^
    split
    let l:difference = 0
    let l:str = getline(".")
    while match(l:str, "@@", 0) == -1
        if match(l:str, "-", 0) != 0
            let l:difference = l:difference + 1
        endif
        normal -
        let l:currpos = line(".")
        if (l:currpos == 1)
            " at the top, nothing to do:
            let @"=l:saved_reg
            execute 'quit'
            execute 'echo "Wrong position: could not find original filename"'
            return
        endif
        let l:str = getline(".")
    endwhile
    "we are at the right position
    "store the line number in orig. file in @z
    normal 6w"zye^
    "search for original file name:
    call search("^+++", "bW")
    "go to the original filename:
    normal w
    "read the filename:
    let l:originalfilename = expand("<cfile>")
    if isdirectory(l:originalfilename)
        execute 'quit'
        execute 'echo "This is probably a submodule, see its diff at the bottom!"'
        return
    endif
    execute ':silent ! ~/bin/vim/create-git-path'
    execute 'edit!' . l:originalfilename
    let l:origfilelineno = @z
    "go to the right position :)
    call cursor(l:origfilelineno + l:difference - 1, 1)
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

function! Ver_Blame()
  let l:saved_reg = @"
  let l:name = expand("%")
  let l:filetype=&ft
  if empty(l:name)
    if !exists("w:kgy_orig_name")
      execute 'echo "Error: incorrect file"'
      return
    endif
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
    let l:display_rev = ' (rev ' . l:svn_revision . ')'
  else
    let l:revision = ''
    let l:display_rev = ''
  endif
  execute ':silent! $read ! $HOME/bin/vim/do-revision-cmd blame ' . l:name . l:revision
  normal ggdd
  call cursor(l:currpos, 1)
  let l:statusline = 'Blame of ' . l:name . l:display_rev
  let l:statusline .= ' [;vb]+'
  execute ':setl statusline=' . escape(l:statusline, ' \')
  execute ':set filetype=' . l:filetype
  let w:kgy_filetype = "blame"
  let @"=l:saved_reg
endfunction

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! Ver_Log_Generic(name, revision)
  execute "normal! o### Log of '" . a:name . "', revision " . a:revision . ":"
  execute ":silent! $read! $HOME/bin/vim/do-revision-cmd log " . a:name . " -r " . a:revision
endfunction

function! Ver_Log_Rev()
  let l:saved_reg = @"
  let l:revision = expand("<cword>")
  let l:name = '.'
  if exists("w:kgy_orig_name")
    let l:name = w:kgy_orig_name
  endif
  if empty(l:revision)
    execute 'echo "Error: no revision number under cursor"'
    return
  endif
  new
  call Ver_Log_Generic(l:name, l:revision)
  normal ggdd
  let l:statusline = 'Log of revision ' . l:revision
  let l:statusline .= ' [;vr]+'
  execute ':setl statusline=' . escape(l:statusline, ' \')
  let @"=l:saved_reg
endfunction

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! Ver_Blame_Mergeinfo()
  let l:saved_reg = @"
  let l:name = expand("%")
  let l:filetype=&ft
  if empty(l:name)
    if !exists("w:kgy_orig_name")
      execute 'echo "Error: incorrect file"'
      return
    endif
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
    let l:display_rev = ' (rev' . l:svn_revision . ')'
  else
    let l:revision = ''
    let l:display_rev = ''
  endif
  execute ':silent! $read ! $HOME/bin/vim/do-revision-cmd blame ' . l:name . l:revision . ' --force -g'
  normal ggdd
  call cursor(l:currpos, 1)
  let l:statusline = 'Blame-M of ' . l:name . l:display_rev
  let l:statusline .= ' [A-F12]+'
  execute ':setl statusline=' . escape(l:statusline, ' \')
  execute ':set filetype=' . l:filetype
  let w:kgy_filetype = "blame"
  let @"=l:saved_reg
endfunction

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! Ver_Diff_Local(name)
  execute "normal! o### Diff of '" . a:name . "', local modifications:"
  execute ":silent! $read! $HOME/bin/vim/do-revision-cmd local " . a:name
  execute ":set filetype=diff"
  let w:kgy_filetype = "diff"
endfunction

function! Ver_Diff_Generic_Rev(name, revision)
  execute "normal! o### Diff of '" . a:name . "', revision " . a:revision . ":"
  execute ":silent! $read! $HOME/bin/vim/do-revision-cmd change " . a:name . " -r " . a:revision
  execute ":set filetype=diff"
  let w:kgy_filetype = "diff"
endfunction

function! Ver_GotoInDiff(pos)
  execute ':$'
  normal 0
  while 1
    if (line(".") == 1)
      execute 'echo "Wrong file format"'
      return
    endif
    let l:found = search("^@@ ", "bW")
    if (l:found == 0)
      execute 'echo "Position not found"'
      return
    endif
    let l:result = system('$HOME/bin/vim/goto-in-diff ' . a:pos . ' "' . getline(".") . '"')
    if (!empty(l:result))
      execute 'echo "got {' . l:result . 'X}"'
      execute 'normal! ' . l:result . 'j'
      return
    endif
  endwhile
endfunction

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! Ver_LocalDiff()
  let l:saved_reg = @"
  let l:name = expand("%")
  if empty(l:name)
    if !exists("w:kgy_orig_name")
      execute 'echo "Error: incorrect file"'
      return
    endif
    let l:name = w:kgy_orig_name
  endif
  let l:currpos = line(".")
  if exists("w:kgy_row_offset")
    let l:currpos -= w:kgy_row_offset
  endif
  new
  call Ver_Diff_Local(l:name)
  normal ggdd
  call Ver_GotoInDiff(l:currpos)
  let l:statusline = 'Local change of ' . l:name
  let l:statusline .= ' [A-F11]+'
  execute ':setl statusline=' . escape(l:statusline, ' \')
  let @"=l:saved_reg
endfunction

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! Ver_Diff_Current()
  let l:saved_reg = @"
  let l:name = expand("%")
  if empty(l:name)
    if !exists("w:kgy_orig_name")
      execute 'echo "Error: incorrect file"'
      return
    endif
    let l:name = w:kgy_orig_name
  endif
  let l:currpos = line(".")
  if exists("w:kgy_row_offset")
    let l:currpos -= w:kgy_row_offset
  endif
  let l:revision = expand("<cword>")
  new
  call Ver_Diff_Generic_Rev(l:name, l:revision)
  normal ggdd
  call Ver_GotoInDiff(l:currpos)
  let l:statusline = 'Change of ' . l:name . ' in rev ' . l:revision
  let l:statusline .= ' [S-F11]+'
  execute ':setl statusline=' . escape(l:statusline, ' \')
  let @"=l:saved_reg
endfunction

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! Ver_FindRootPath(revision)
  return system('$HOME/bin/vim/do-find-revision-root ' . a:revision)
endfunction

function! Ver_Read_Log_Rev(file_path, revision)
  execute "normal! o### svn log of revision " . a:revision . ":"
  execute ':silent! $read! $HOME/bin/vim/do-revision-cmd log ' . a:file_path . ' -r ' . a:revision
endfunction

function! Ver_Diff_Full_Rev(file_path, revision)
  execute "normal! o### svn diff of revision " . a:revision . ":"
  execute ':silent! $read! $HOME/bin/vim/do-revision-cmd change ' . a:file_path . ' -r ' . a:revision
  execute ':set filetype=diff'
  let w:kgy_filetype = "diff"
endfunction

function! Ver_Diff_Full()
  let l:saved_reg = @"
  let l:revision = expand("<cword>")
  let l:file_path = w:kgy_orig_name
  new
  call Ver_Read_Log_Rev(l:file_path, l:revision)
  normal o
  call Ver_Diff_Full_Rev(l:file_path, l:revision)
  normal ggdd
  let @"=l:saved_reg
endfunction

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! Ver_GetRevOfFile()
  let l:saved_reg = @"
  if exists("w:kgy_filetype") && w:kgy_filetype == "blame"
    let l:filetype=&ft
    let l:revision = expand("<cword>")
    let l:orig_file_name = w:kgy_orig_name
    let l:currpos = line(".")
    if exists("w:kgy_row_offset")
      let l:currpos -= w:kgy_row_offset
    endif
    new
    execute ':silent! $read ! $HOME/bin/vim/do-revision-cmd cat ' . l:orig_file_name . ' -r ' . l:revision
    let w:kgy_orig_name = l:orig_file_name
    let w:kgy_svn_revision = l:revision
    call cursor(l:currpos, 1)
    let l:statusline = 'File ' . l:orig_file_name . ' (rev ' . l:revision . ')'
    let l:statusline .= ' [F10]+'
    execute ':setl statusline=' . escape(l:statusline, ' \')
    execute ':set filetype=' . l:filetype
  else
    let l:filename = expand("%")
    if exists("w:kgy_orig_name")
      let l:filename = w:kgy_orig_name
    endif
    let l:revision = ''
    if exists ("w:kgy_svn_revision")
      let l:revision = ' -r ' . w:kgy_svn_revision
    endif
    execute ':!$HOME/bin/vim/do-revision-cmd show-revision ' . l:filename . l:revision
  endif
  let @"=l:saved_reg
endfunction

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! Ver_GetPrevRevOfFile()
  let l:saved_reg = @"
  let l:filetype=&ft
  if exists("w:kgy_orig_name")
    let l:filename = w:kgy_orig_name
  else
    let l:filename = expand("%")
  endif
  if exists("w:kgy_svn_revision")
    let l:revision = w:kgy_svn_revision
  else
    if (exists("w:kgy_filetype") && (w:kgy_filetype == "diff" || w:kgy_filetype == "blame"))
      let l:revision = expand("<cword>")
    else
      let l:revision = ''
    endif
  endif
  let l:prev_revision = system('$HOME/bin/vim/get-previous-revision ' . l:filename . ' ' . l:revision)
  let l:currpos = line(".")
  if exists("w:kgy_row_offset")
      let l:currpos -= w:kgy_row_offset
  endif
  new
  execute ':silent! $read ! $HOME/bin/vim/do-revision-cmd cat "' . l:filename . '" -r ' . l:prev_revision
  let w:kgy_orig_name = l:filename
  let w:kgy_svn_revision = l:prev_revision
  call cursor(l:currpos, 1)
  let l:statusline = 'File ' . l:filename . ' (rev ' . l:prev_revision . ')'
  let l:statusline .= ' [;vp]+'
  execute ':setl statusline=' . escape(l:statusline, ' \')
  execute ':set filetype=' . l:filetype
  let @"=l:saved_reg
endfunction

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! Ver_Cat()
  let l:saved_reg = @"
  if exists("w:kgy_orig_name")
    let l:filename = w:kgy_orig_name
  else
    let l:filename = expand("%")
  endif
  let l:filetype=&ft
  let l:currpos = line(".")
  if exists("w:kgy_row_offset")
      let l:currpos -= w:kgy_row_offset
  endif
  new
  execute ':silent! $read ! svn cat ' . l:filename
  let w:kgy_orig_name = l:filename
  let w:kgy_svn_revision = "HEAD"
  call cursor(l:currpos, 1)
  let l:statusline = 'File ' . l:filename . ' (rev ' . w:kgy_svn_revision . ')'
  let l:statusline .= ' [A-F10]+'
  execute ':setl statusline=' . escape(l:statusline, ' \')
  execute ':set filetype=' . l:filetype
  let @"=l:saved_reg
endfunction

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Ver_Read_Log_File(name)
  execute "normal! o### svn log of file " . a:name . ":"
  let w:kgy_orig_name = a:name
  execute ':silent! $read ! $HOME/bin/vim/do-revision-cmd log ' . a:name
endfunction

function! Ver_Log()
  let l:saved_reg = @"
  let l:name = expand("%")
  if empty(l:name)
    if !exists("w:kgy_orig_name")
      execute 'echo "Error: incorrect file"'
      return
    endif
    let l:name = w:kgy_orig_name
  endif
  new
  call Ver_Read_Log_File(l:name)
  normal ggdd
  let @"=l:saved_reg
endfunction

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! Ver_GetGivenRevOfFile()
  let l:saved_reg = @"
  let l:filetype=&ft
  if exists("w:kgy_orig_name")
    let l:filename = w:kgy_orig_name
  else
    let l:filename = expand("%")
  endif
  let l:revision = input("Revision #")
  if !empty(l:revision)
    let l:currpos = line(".")
    if exists("w:kgy_row_offset")
        let l:currpos -= w:kgy_row_offset
    endif
    new
    let w:kgy_orig_name = l:filename
    let w:kgy_svn_revision = l:revision
    execute ':silent! $read ! $HOME/bin/vim/do-revision-cmd cat ' . l:filename . ' -r ' . l:revision
    let l:statusline = 'File ' . l:filename . ' (rev ' . l:revision . ')'
    let l:statusline .= ' [S-F9]+'
    execute ':setl statusline=' . escape(l:statusline, ' \')
    execute ':set filetype=' . l:filetype
    call cursor(l:currpos, 1)
  endif
  let @"=l:saved_reg
endfunction

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! Ver_DoRevert(name)
  execute ':! $HOME/bin/vim/do-revision-cmd revert ' . a:name
endfunction

function! Ver_Revert()
  let l:saved_reg = @"
  if (exists("w:kgy_filetype") && w:kgy_filetype == "diff")
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
  else
    let l:filename = expand("%")
    if empty(l:filename)
      execute 'echo "Error: wrong filetype."'
      return
    endif
  endif
  call Ver_DoRevert(l:filename)
  if (exists("w:kgy_filetype") && w:kgy_filetype == "diff")
    call Refreshdiff()
  endif
  let @"=l:saved_reg
endfunction

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! Ver_UpdateTo()
  let l:saved_reg = @"
  if !exists("w:kgy_svn_revision")
    execute ':echo "Nothing to do!"'
    return
  endif
  execute ':echo "Updating to revision ' . w:kgy_svn_revision . ' ..."'
  execute ':!$HOME/bin/vim/do-revision-cmd update "." -r ' . w:kgy_svn_revision
  let @"=l:saved_reg
endfunction

" * * * * * * * * * * * * * * * * End - of - File * * * * * * * * * * * * * * * *
