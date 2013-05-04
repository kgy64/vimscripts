
syntax on
colorscheme kgy
set background=dark
set textwidth=120

" Egzotikus >-ok
set list listchars=tab:>\ ,trail:$
set aw si bs=2 errorformat=%E%f:%l:\ %m,%Dmake[%*\\d]:\ Entering\ directory\ `%f',%Dgmake[%*\\d]:\ Leaving\ directory\ `%f',%C\ %m
set nocompatible ai history=100 ruler hlsearch sw=4 ts=4 sta noet nowrap scrolloff=2 autoindent

"set path="./src"

" Press space to clear search highlighting and any message already displayed:
nnoremap <silent> <Space> :silent noh<Bar>echo<CR>

" Switch off the annoying beeps:
set noeb vb t_vb=

" configure tags - add additional tags here or comment out not-used ones
"set tags+=~/.vim/tags/cpp
"set tags+=~/.vim/tags/gl
"set tags+=~/.vim/tags/sdl
"set tags+=~/.vim/tags/qt4

" OmniCppComplete
set nocp
filetype plugin on
let OmniCpp_DisplayMode = 1
let OmniCpp_ShowScopeInAbbr = 1
let OmniCpp_NamespaceSearch = 2
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_SelectFirstItem = 1
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
let OmniCpp_MayCompleteDot = 1      " autocomplete after .
let OmniCpp_MayCompleteArrow = 1    " autocomplete after ->
let OmniCpp_MayCompleteScope = 1    " autocomplete after ::
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest,preview

