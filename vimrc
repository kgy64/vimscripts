
syntax on
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

