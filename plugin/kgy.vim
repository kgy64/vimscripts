"
"
"

colorscheme kgy

function! IncludeMe()
	let l:f=expand("%:t")
	execute ":scs find i ".l:f
endfunction

" --------------------------------------------------

function! GoToFileAndLine()
  let l:saved_reg = @"
  let l:filename = expand("<cfile>")
  let l:currpos = line(".")
  let l:column = col(".")
  execute "normal! f:"
  let l:colon_pos = col(".")
  if l:column != l:colon_pos
    execute "normal !l"
    let l:file_pos = expand("<cword>")
  else
    let l:file_pos = 1
  endif
  call cursor(l:currpos, l:column)
  execute ":scs find f " . l:filename
  call cursor(l:file_pos, 1)
  let @"=l:saved_reg
endfunction

function! Print_MyHelp()
  new
  execute ":silent! $read ! ~/bin/vim/print_help"
  execute ":2"
endfunction

function! Call4Bugtracker()
  let l:tracker_id = expand("<cword>")
  if l:tracker_id[0] == 'b'
    execute ":silent ! ~/bin/vim/do-bugtracker-call " . strpart(l:tracker_id, 1)
  elseif l:tracker_id[0] == 'r'
    execute ":silent ! ~/bin/vim/do-review-call " . strpart(l:tracker_id, 1)
  else
    execute ":silent ! ~/bin/vim/do-bugtracker-call " . l:tracker_id
  endif
endfunction

function! s:create_new_header()
  let gatename = "__" . substitute(toupper(expand("%:t")), "\\.", "_", "g") . "__"
  execute "normal! i#ifndef " . gatename
  execute "normal! o#define " . gatename
  execute "normal! o"
  execute "normal! o#endif /* " . gatename . " */"
  execute "normal! o"
  execute "normal! o/* * * * * * * * * * * * * End - of - File * * * * * * * * * * * * * * */"
  normal! kkk
endfunction
autocmd BufNewFile *.{h,hpp} call <SID>create_new_header()

function! s:create_new_cpp()
  let headername = substitute(expand("%:t"), "\\.cpp", "", "g") . ".h"
  execute "normal! i#include \"" . headername . "\""
  execute "normal! o"
  execute "normal! o/* * * * * * * * * * * * * End - of - File * * * * * * * * * * * * * * */"
  normal! k
endfunction
autocmd BufNewFile *.cpp call <SID>create_new_cpp()

function! s:create_new_c()
  let headername = substitute(expand("%:t"), "\\.c", "", "g") . ".h"
  execute "normal! i#include \"" . headername . "\""
  execute "normal! o"
  execute "normal! o/* * * * * * * * * * * * * End - of - File * * * * * * * * * * * * * * */"
  normal! k
endfunction

autocmd BufNewFile *.c call <SID>create_new_c()

nmap ;f :call GoToFileAndLine()<CR>
nnoremap ;I :call IncludeMe()<CR>
nnoremap ;d :stjump <C-R>=expand("<cword>")<CR><CR>
nnoremap ;<C-D> :stjump 
map <S-F1> i// KGY: szívás ellen: <ESC>
map <F2> :call Print_MyHelp()<CR>
map <F3> :! ~/bin/vim/update_tags<CR>:cs reset<CR>
map <S-F3> :w! /tmp/vim-difi<CR>:silent ! kompare /tmp/vim-difi &<CR>
inoremap <F4> <C-R>=strftime("%F %R")<CR>
inoremap <S-F4> <C-R>=strftime("%F %R:%S")<CR>
map <F5> :call Call4Bugtracker()<CR>

