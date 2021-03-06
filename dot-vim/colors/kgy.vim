" local syntax file - set colors on a per-machine basis:
" vim: tw=0 ts=4 sw=4
" Vim color file
" Maintainer:        Ron Aaron <ron@ronware.org>
" Last Change:        2003 May 02

hi clear
set background=dark
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "kgy"

highlight Comment    ctermfg=8                         guifg=#80e080
highlight Constant   ctermfg=6             cterm=none  guifg=#00ffff                 gui=none
highlight Identifier ctermfg=2                         guifg=#00ff80
highlight SpecialKey ctermfg=4                         guifg=#005080
highlight Statement  ctermfg=3             cterm=bold  guifg=#c0c000                 gui=bold
highlight PreProc    ctermfg=2                         guifg=#00ff00
highlight Type       ctermfg=2                         guifg=#00c000
highlight Special    ctermfg=5  ctermbg=8              guifg=#409090
highlight Error                 ctermbg=1                             guibg=#ff0000
highlight Todo       ctermfg=4  ctermbg=3              guifg=#000080  guibg=#c0c000
highlight Directory  ctermfg=2                         guifg=#00c000
highlight StatusLine ctermfg=7  ctermbg=2  cterm=bold  guifg=#ffff00  guibg=#0000ff  gui=none
highlight Normal                                       guifg=#d0e0d0  guibg=#202020
highlight Search     ctermbg=3                                        guibg=#c0c000
