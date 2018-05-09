" This file contains all the maps added to vim
"

" for kgy.vim:

nmap     ;hb    :call BoldHtml()<CR>i
nmap     ;hB    :call BoldHtml2()<CR>i
nmap     ;hr    :call RefHtml()<CR>i
nmap     ;hn    :call NewlineHtml()<CR>a
nmap     ;hl    :call AddList()<CR>
nmap     ;hL    :call AddListEntry()<CR>o<TAB>
nmap     ;f     :call GoToFileAndLine()<CR>
nmap     ;<C-F> :call EnterFile2Search()<CR>

nnoremap ;I     :call IncludeMe()<CR>
nnoremap ;d     :stjump <C-R>=expand("<cword>")<CR><CR>
nnoremap ;<C-D> :stjump 

inoremap <S-F2> <C-R>=GetGateName()<CR>
inoremap <F4>   <C-R>=strftime("%F %R")<CR>
inoremap <S-F4> <C-R>=strftime("%F %R:%S")<CR>
inoremap ;m     <C-R>=InsertMain()<CR>

map      <F2>   :call Print_MyHelp()<CR>
map      <F3>   :! ~/bin/vim/update_tags<CR>:cs reset<CR>
map      <S-F3> :w! /tmp/vim-difi<CR>:silent ! kompare /tmp/vim-difi &<CR>
map      ;b     :call Call4Bugtracker()<CR>

" for revision.vim:

map      ;vb    :call Ver_Blame()<CR>
map      ;vr    :call Ver_Log_Rev()<CR>
map      ;vR    :call Ver_Revert()<CR>
map      ;vp    :call Ver_GetPrevRevOfFile()<CR>

" map <A-F12>     :call Ver_Blame_Mergeinfo()<CR>
" map <A-F11>     :call Ver_LocalDiff()<CR>
" map <A-F10>     :call Ver_Cat()<CR>
" map <S-C-F10>   :call Ver_Cat()<CR>
" map <S-F11>     :call Ver_Diff_Current()<CR>
" map <S-F9>      :call Ver_GetGivenRevOfFile()<CR>
" map <S-F8>      :call Ver_UpdateTo()<CR>
" map <F9>        :call Ver_Log()<CR>
" map <F11>       :call Ver_Diff_Full()<CR>
" map <F10>       :call Ver_GetRevOfFile()<CR>

" for vebugger.vim:

nmap    <F5>    :VBGstartGDB 
nmap    <S-F5>  :VBGkill<CR>
nmap    <F8>    :VBGtoggleTerminalBuffer<CR>
nmap    <S-F8>  :VBGrawWrite 
nmap    <C-F8>  :VBGrawWrite f 
nmap    <F9>    :VBGtoggleBreakpointThisLine<CR>
nmap    <F10>   :VBGstepOver<CR>
nmap    <F11>   :VBGstepIn<CR>
nmap    <S-F11> :VBGstepOut<CR>
nmap    <C-S-F9> :VBGclearBreakpoints<CR>
nmap    <S-F9>  :VBGevalWordUnderCursor<CR>
nmap    <C-F9>  :VBGcontinue<CR>
nmap    <C-A-c> :

" * * * * * * * * * * * * * * * * End - of - File * * * * * * * * * * * * * * * *
