""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vimrc File                                                                 "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" General Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set viminfo='20,\"50	" read/write a .viminfo file, don't store more than 50 lines of registers

if has("autocmd")
  " In text files, always limit the width of text to 78 characters
  autocmd BufRead *.txt set tw=78
  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
endif

if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

set nocompatible " Vim defaults > vi defaults
filetype on		" filetype detection is good
set history=1000	" Set command history to 1000 lines, probably overkill, but meh
set cf		" Ask for confirmation about stuff. Like quitting with unsaved files open.
set ffs=unix,dos,mac	" Allow *nix, DOS and Mac line-endings
filetype indent plugin on	" Set the indent and filetype-specific settings on
"set foldmethod=indent	" Disabled because i find it annoying. Enabled folding
" and set the method to fold based on indent
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Theme Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set background=dark " duh
syntax on	" Syntax hilight enable stuff
colorscheme evening	" elflord is a decently pretty colourscheme. Default to it.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" UI Tweaks
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set lsp=0	" Number of pixel lines between characters.
set ruler
set cmdheight=2
set backspace=2
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Visual Reference
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set showmatch
set mat=10
set hlsearch
set incsearch
set novisualbell
set noerrorbells
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [HEX=\%02.2B]\ [BUF=\#%n]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
set laststatus=2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Layout
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set ai
" Comment out explicit set cindent because cindent on all files (not just
" C/C-like) is annoying as hell.
" set cindent
au BufRead,BufNewFile *.c,*.h,*.cpp,*.cxx,*.hpp,*.cc,*.c++,*.hh,*.hxx,*.ipp,*.moc,*.tcc,*.inl set cindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set nowrap
set smarttab
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Macros
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <F3> gg=G:w<cr>
map <F4> :q!<cr>
map <F5> ZZ
map <F8> :set paste<CR>
map <F9> :set nopaste<CR>
imap <F8> <C-O>:set paste<CR>
imap <F9> <nop>
set pastetoggle=<F9>

" JD options
" Sets a actual menu for tab-completion.
set wildmenu

" Allow backgrounding buffers without writing them. This makes multi-buffer
" not a pain in the ass. It also remembers marks for backgrounded buffers.
set hidden

" Wrap on arrowkeys as well as backspace and space (defaults)
set whichwrap=<,>,[,],b,s

" testing option to not backspace on exiting insert mode
"imap <Esc> <Esc><Space>

" function (possibly command) to check for filetype detection after you
" start editing a file.
function CheckFileType()
	if &filetype == ""
		filetype detect
	endif
endfunction

command -nargs=* CheckFileType :call CheckFileType()	" Command to run above function.
