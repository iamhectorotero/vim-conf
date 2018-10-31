" Set errorbells off. In later versions of Vim it can be done with 'set belloff=all'
" To disable bells at system level as well, add:
" - BASH: 'set bell-style visible' to .inputrc
" - ZSH: 'unsetopt BEEP' to .zshrc
set vb t_vb=

" Syntax highlighting
syntax on

" Tabs as spaces
set tabstop=4
set shiftwidth=4
set expandtab

"EOL and tabs visible
set listchars=eol:¬,tab:>.
set list 

" Vertical column for line width
highlight ColorColumn ctermbg=lightgrey guibg=lightgrey
set colorcolumn=100

" Allow backspacing over indents, line breaks and before the start of current insert.
set backspace=indent,eol,start
