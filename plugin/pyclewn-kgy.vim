"   My extensions for Pyclewn
"

function! GoToThreadFunction()
    " Save the value of the unnamed register
    let l:saved_reg = @"
    let l:str = getline(".")
    let l:line1 = l:str
    let l:i = 0
    while match(l:str, "Thread", 0) == -1
        if (l:i > 200)
            let @"=l:saved_reg
            return
        endif
        normal -
        let l:i = l:i + 1
        let str = getline(".")
    endwhile
    let l:thread_no = split(l:str)[1]
    let l:func_level = split(l:line1)[0]
    execute ":Cthread " . l:thread_no
    sleep 1
    execute ":Cframe " . l:func_level[1:]
    let @"=l:saved_reg
endfunction

function SetUpTtyOut()
    if has('gui_running')
        execute ":Cshell setsid xterm -e inferior_tty.py &"
    else
        let tty_name = input('Enter terminal name: ')
        execute ":Cset inferior-tty " . tty_name
    endif
endfunction

function! StartPyclewn()
    execute ':Pyclewn'
    execute ':Cmapkeys'
    map     <S-F2>  :call SetUpTtyOut()<CR>
    map     <F6>    :make 
    map     <F5>    :Cfile 
    map     <S-F5>  :Cstart 
    map     <F3>    :Csigint<CR>
    map     <F4>    :Ccontinue<CR>
    map     <S-F4>  :Cprint 
    map     <F7>    :Cthread apply all backtrace<CR>
    map     <S-F7>  :call GoToThreadFunction()<CR>
    map     <A-F7>  :Cbt<CR>
    map     <F8>    :Cdbgvar 
    map     <S-F8>  :exe "Cfoldvar " . line(".")<CR>
    map     <A-F8>  0llll:exe "Cdelvar " . expand("<cword>")<CR>
    map     <F9>    <C-B>
    map     <S-F9>  <C-E>
    map     <F10>   :Cnext<CR>
    map     <F11>   :Cstep<CR>
    map     <C-Up>  :Cup<CR>
    map     <C-Down>  :Cdown<CR>
endfunction

" --------------------------------------------------

nmap    <F6>    :call StartPyclewn()<CR>

