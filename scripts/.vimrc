set nocompatible
syntax enable
set scrolloff=1

"! syntax highlight
":syntax on
":au BufRead,BufNewFile *.svh   setfiletype verilog_systemverilog
":au BufRead,BufNewFile *.sv    setfiletype verilog_systemverilog
":au BufRead,BufNewFile *.vt    setfiletype verilog

filetype plugin indent on
filetype indent on

hi Normal guibg=black guifg=white
hi Visual guibg=cyan guifg=red
hi Search guibg=yellow guifg=red
set bs=2	" allow backspacing over everything in insert mode
set mousehide	" hide mouse pointer while typing
set mouse=a
set number

set guioptions+=a
set et                  | " expandtab
set is                  | " incsearch
set ic                  | " ignore case search
set ru                  | " ruler
set scs                 | " smartcase
set sw=2                | " shiftwidth
set ts=4                | " *tabstop* show existing tabs with spaces
set expandtab           | " replace tab by spaces
set smarttab
set wm=15               | " wrapmargin
set comments+=fb:.      | " auto-indention for a '.'
                          " . handy for a text-mode item list,
                          "   like this one.
set cmdheight=2         | " reduce annoy hit-enter prompt
set cpo-=C
"set wh=9999             | " extend the split window
set cindent
set smartindent
set autoindent
set shiftwidth=4        | " use 4 spaces while indenting
set showcmd
set nocp
set incsearch
set hlsearch
set wrap
set linebreak
set nolist   " list disable linebreak
set noerrorbells
set novisualbell
set tw=0
set ai
set ls=2
set autoread
set cmdheight=2 "The commandbar height
set showmatch
set mat=2 "How many tenths of a second to blink
set cd=,, "List of directory names used for :cd
set nobackup
set statusline=%<%f%h%m%r%=%{&ff}\ %l,%c%V\ %P
set expandtab
set autochdir
"set paste               | " turn off auto indent while pasting code
"set sol 
"set si
"set sta
"set cul

filetype plugin on
augroup filetypedetect
	autocmd BufRead,BufNewFile *.V set ft=verilog
	autocmd BufRead,BufNewFile *.log set ft=verilog
	autocmd BufRead,BufNewFile *.force set ft=verilog
	autocmd BufRead,BufNewFile *.vh set ft=verilog
	autocmd BufRead,BufNewFile *.vi set ft=verilog
	autocmd BufRead,BufNewFile *.vo set ft=verilog
	autocmd BufRead,BufNewFile *.sv set ft=verilog_systemverilog
	autocmd BufRead,BufNewFile *.epy set ft=verilog_systemverilog
	autocmd BufRead,BufNewFile *.svh set ft=verilog_systemverilog
	autocmd BufRead,BufNewFile test.list set ft=asm
	autocmd BufRead,BufNewFile *.src set ft=asm
	autocmd BufRead,BufNewFile *.lis set ft=asm ignorecase
	autocmd BufRead,BufNewFile *.io set iskeyword+=[,],.
augroup END 

"se pastetoggle=<F8>
:nmap <F8> :call TooglePaste()<CR>
fun! TooglePaste()
    se paste!
endfun

:nmap <F12> :call ToggleMouse()<CR>
fun! ToggleMouse()
	if &mouse=="a"
		set mouse=c
	else
		set mouse=a
	endif
endfun

:nmap <F10> :call ToggleSwap()<CR>
fun! ToggleSwap()
    se wrap!
endfun

:nmap <F9> :call SetNu()<CR>
fun! SetNu()
    se nu!
endfun

"! open ctag in tab/vertical split
set tags=./tags,tags;
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
map <leader><C-\> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

if &diff
  set diffopt+=iwhite
endif

set diffexpr=MyDiff()
function! MyDiff()
  let opt = ""
  if exists("g:diffignore") && g:diffignore != ""
    let opt = "-I " . g:diffignore . " "
  endif
  if &diffopt =~ "icase"
    let opt = opt . "-i "
  endif
  if &diffopt =~ "iwhite"
    let opt = opt . "-b "
  endif
  silent execute "!diff -a --binary " . opt . v:fname_in . " " .
    \ v:fname_new . " > " . v:fname_out
endfunction
