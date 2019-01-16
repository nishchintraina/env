"
" @file .vimrc
"
" @brief
" RC file to set up vim
"
" @changelog
" 2015/08/20 - Original version
"
" @author nisraina
" @date 2015/08/20
"
"

" basic settings
set laststatus=2						" Always show the statusline
set tabstop=4							" Default tabstop
set shiftwidth=4						" Default shiftwidth
set backspace=indent,eol,start 			" Allow backspace key to be used in insert mode
set hlsearch 							" Highlight all matches for previous searcg pattern
set number 								" Print the line number in front of each line
set autoindent 							" Copy indent from current line when starting a new line
set viminfo='1000,<3000,s100,h 			" Read/Write viminfo file on startup/exit. Do ":help 'viminfo'" for info on the identifying chars
set cst 								" Use cscope for tag commands
set csto=0 								" Cscope database(s) are searched first, followed by tag file(s)
set nocsverb 							" Disable verbosity in cscope
set wildmenu 							" Auto completetion of vim menu commands on pressing the wildchar (default <Tab>)
set nocompatible   						" Disable vi-compatibility
set encoding=utf-8 						" Necessary to show Unicode glyphs
set nocompatible   						" Disable vi-compatibility
set nofoldenable    					" Disable folding


" add any database in current directory
if filereadable("cscope.out")
	cs add cscope.out
" else add database pointed to by environment
elseif $CSCOPE_DB != ""
	cs add $CSCOPE_DB
endif
set csverb


" diff settings
if version >= 600
	if (&foldmethod == 'diff')
		set diffopt=filler,context:1000
		set number
		:set wrap
	endif
endif


" screen title
if &term == "xterm-256color"
 let &titlestring = expand("%:t")
 set t_ts=k
 set t_fs=\
 set title
endif
autocmd TabEnter,WinEnter,BufReadPost,FileReadPost,BufNewFile * let &titlestring = expand("%:t")
let &titleold=substitute(getcwd(), $HOME, "~", "")

" Set up pathogen
execute pathogen#infect()
execute pathogen#helptags()
syntax on
filetype plugin indent on

" vim-airline configs
let g:airline_theme='luna'
let g:Powerline_symbols = 'fancy'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme='papercolor'

" Toggle between relativenumber and number
function NumberToggle()
  if(&relativenumber == 1)
    set norelativenumber
    set number
  else
    set relativenumber
  endif
endfunc

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

if &diff
    colorscheme edge
else
	colorscheme delek
endif

" Enable line number and make the active line's number a different color
set number
set cursorline
hi CursorLine term=bold cterm=bold guibg=Grey40

"" All mappings

" add cscope mappings
nnoremap <C-\> :cs find 3 <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-@> :cs find 0 <C-R>=expand("<cword>")<CR><CR>

" Toggle absolute and relative line numbering
nnoremap <unique> tn :call NumberToggle()<CR>

" Powerline Mappings
nnoremap <C-n> :bn<CR>
nnoremap <C-b> :bp<CR>

" NERDTree Mappings
nnoremap <F5> :NERDTreeToggle<CR>

" Tagbar Mappings
nnoremap <F6> :TagbarToggle<CR>

" to delete trailing spaces
nnoremap <F7> :%s/\s\+$//<CR>

" colorsheme color changes
nnoremap <F8> :colorscheme edge<CR>
nnoremap <F9> :colorscheme delek<CR>

" cscope rebuild
nnoremap <F10> :silent :!find . -iname '*.c' -o -iname '*.cpp' -o -iname '*.h' -o -iname '*.hpp' > cscope.files<CR><CR>
	\:!cscope -b -i cscope.files -f cscope.out<CR><CR>
	\:silent :cs reset<CR><CR>
