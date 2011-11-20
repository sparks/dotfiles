set nocompatible "VIM Mode

autocmd BufRead, BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

set backspace=indent,eol,start " allow backspacing over everything in insert mode

set history=200 " 200 lines of command scroll back
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch	" do incremental searching

set number		" line numebrs
set nuw=3		" number with 6

set nobackup
"set backupdir=~/.vim/backup
"set directory=~/.vim/tmp

if has("mouse")
	set mouse=a
	set mousehide
endif

filetype on
filetype plugin indent on
syntax on
set hlsearch

" Who doesn't like autoindent?
set autoindent

set wildmenu
set wildmode=list:longest,full

set ignorecase
set smartcase

set nohidden

"highlight MatchParen ctermbg=4
