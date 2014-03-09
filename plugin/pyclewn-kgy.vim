"
"
"

function! StartPyclewn()
    execute ':Pyclewn'
    execute ':Cmapkeys'
    map     <F6>    :make 
    map     <F5>    :Cfile 
    map     <S-F5>  :Cstart<CR>
    map     <F3>    :Csigint<CR>
    map     <F4>    C
    map     <F9>    <C-B>
    map     <S-F9>  <C-E>
    map     <F10>   <C-N>
    map     <F11>   S
    map     <C-Up>  <C-U>
    map     <C-Down> <C-D>
endfunction

" --------------------------------------------------

nmap    <F6>    :call StartPyclewn()<CR>
" nmap    <S-F6>  :Cfile 
" nmap    <A-F6>  :Csigint<CR>
" nmap    <F7>    :Cstart<CR>
