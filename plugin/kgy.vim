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
  endif
  call cursor(l:currpos, l:column)
  execute ":scs find f " . l:filename
  if exists('l:file_pos') && l:file_pos > 0
    call cursor(l:file_pos, 1)
  endif
  let @"=l:saved_reg
endfunction

function! Print_MyHelp()
  new
  execute ":silent! $read ! ~/bin/vim/print_help"
  execute ":2"
endfunction

function! GetGateName()
  let gatename = "__" . toupper(tr(expand("%"), "+-~.,:;/", "________")) . "_INCLUDED__"
  return gatename
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

function! s:create_generic_header()
  r !~/bin/vim/generic-header
" execute ":1"
" normal! dd
  execute ":$"
endfunction

function! s:create_new_header()
  let gatename = GetGateName()
  call s:create_generic_header()
  execute "normal! o#ifndef " . gatename
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
  call s:create_generic_header()
  execute "normal! o#include \"" . headername . "\""
  execute "normal! o"
  execute "normal! o/* * * * * * * * * * * * * End - of - File * * * * * * * * * * * * * * */"
  normal! k
endfunction

autocmd BufNewFile *.cpp call <SID>create_new_cpp()

function! s:create_new_c()
  let headername = substitute(expand("%:t"), "\\.c", "", "g") . ".h"
  call s:create_generic_header()
  execute "normal! o#include \"" . headername . "\""
  execute "normal! o"
  execute "normal! o/* * * * * * * * * * * * * End - of - File * * * * * * * * * * * * * * */"
  normal! k
endfunction

autocmd BufNewFile *.c call <SID>create_new_c()

function BoldHtml()
  execute "normal! a<b></b>"
  execute "normal! hhh"
endfunction

function BoldHtml2()
  execute "normal! a<b></b>:<br>"
  execute "normal! hhhhhhhh"
endfunction

function RefHtml()
  execute "normal! a<a href=\"\"></a>"
  execute "normal! hhhhh"
endfunction

function NewlineHtml()
  execute "normal! a<br>"
endfunction

function AddListEntry()
  execute "normal! O\t<li>"
  execute "normal! o</li>"
  execute "normal! k"
endfunction

function AddList()
  execute "normal! o<ul>"
  execute "normal! o</ul>"
endfunction

nmap    ;b      :call BoldHtml()<CR>i
nmap    ;c      :call BoldHtml2()<CR>i
nmap    ;r      :call RefHtml()<CR>i
nmap    ;n      :call NewlineHtml()<CR>a
nmap    ;l      :call AddList()<CR>
nmap    ;L      :call AddListEntry()<CR>o<TAB>
nmap    ;f      :call GoToFileAndLine()<CR>

nnoremap ;I     :call IncludeMe()<CR>
nnoremap ;d     :stjump <C-R>=expand("<cword>")<CR><CR>
nnoremap ;<C-D> :stjump 

inoremap <S-F2> <C-R>=GetGateName()<CR>
inoremap <F4>   <C-R>=strftime("%F %R")<CR>
inoremap <S-F4> <C-R>=strftime("%F %R:%S")<CR>

map     <S-F1>  i// KGY: szívás ellen: <ESC>
map     <F2>    :call Print_MyHelp()<CR>
map     <F3>    :! ~/bin/vim/update_tags<CR>:cs reset<CR>
map     <S-F3>  :w! /tmp/vim-difi<CR>:silent ! kompare /tmp/vim-difi &<CR>
map     <F5>    :call Call4Bugtracker()<CR>

