"
"
"

function! StartPyclewn()
    execute ':Pyclewn'
    execute ':Cmapkeys'
    map     <F6>    :make 
    map     <F5>    :Cfile 
    map     <S-F5>  :Cstart 
    map     <F3>    :Csigint<CR>
    map     <F4>    :Ccontinue<CR>
    map     <F8>    :Cdbgvar 
    map     <S-F8>  :exe "Cfoldvar " . line(".")<CR>
    map     <A-F8>  :exe "Cdelvar " . line(".")<CR>
    map     <F9>    <C-B>
    map     <S-F9>  <C-E>
    map     <F10>   :Cnext<CR>
    map     <F11>   :Cstep<CR>
    map     <C-Up>  :Cup<CR>
    map     <C-Down>  :Cdown<CR>
endfunction

" --------------------------------------------------

nmap    <F6>    :call StartPyclewn()<CR>
" nmap    <S-F6>  :Cfile 
" nmap    <A-F6>  :Csigint<CR>
" nmap    <F7>    :Cstart<CR>
