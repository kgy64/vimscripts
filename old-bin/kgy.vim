"
"
"

colorscheme kgy

function! IncludeMe()
	let l:f=expand("%:t")
	execute ":scs find i ".l:f
endfunction

" --------------------------------------------------

inoremap <F4> <C-R>=strftime("%F %R")<CR>
inoremap <S-F4> <C-R>=strftime("%F %R:%S")<CR>

nnoremap ;I :call IncludeMe()<CR>

nnoremap ;d :stjump <C-R>=expand("<cword>")<CR><CR>
nnoremap ;<C-D> :stjump 

function! Print_MyHelp()
  new
  execute ":silent! $read ! ~/bin/vim/print_help"
endfunction

map <S-F1> i// KGY: szívás ellen: <ESC>

map <F2> :call Print_MyHelp()<CR>

map <F3> :! ~/bin/vim/update_tags<CR>:cs reset<CR>

map <S-F3> :w! /tmp/vim-difi<CR>:silent ! kompare /tmp/vim-difi &<CR>

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

