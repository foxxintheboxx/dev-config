"
"

" ======================================================================================================


autocmd BufWritePre * :%s/\s\+$//e
" For starters, some settings that should be default, but one never knows: {{{
set hlsearch
set number
set nocompatible " we want new vim features whenever they are available
set bs=2         " backspace should work as we expect it to
set autoindent
set history=50   " remember last 50 commands
set ruler        " show cursor position in the bottom line
syntax on        " turn on syntax highlighting if not available by default
" }}}
" ======================================================================================================


" Small tweaks: my preferred
" ind
" entation, colors, autowrite, status line etc.:  {{{

" currently I prefer indent step 4 and spaces -- tabs are evil and should be avoided
set shiftwidth=2
set tabstop=2
set expandtab
set softtabstop=2

" when shifting a non-aligned set of lines, align them to the next tabstop
set shiftround

" by default, if I'm editing text, I want it to wrap
set textwidth=100

" my terminal is dark, use an appropriate colorscheme
set background=dark
" use the following to force black background if necessary:
" highlight Normal guibg=black guifg=white ctermbg=black ctermfg=white

" automatically re-read files changed outside vim
set autoread

" automatically save before each make/execute command
set autowrite

" if I press <tab> in command line, show me all options if there is more than one
set wildmenu

" y and d put stuff into system clipboard (so that other apps can see it)
set clipboard=unnamed,unnamedplus

" <F12> toggles paste mode
set pastetoggle=<F12>

" while typing a command, show it in the bottom right corner
set showcmd

" adjust timeout for mapped commands: 200 milliseconds should be enough for everyone
set timeout
set timeoutlen=200

" an alias to convert a file to html, using vim syntax highlighting
command ConvertToHTML so $VIMRUNTIME/syntax/2html.vim

" text search settings
set incsearch  " show the first match already while I type
set ignorecase
set smartcase  " only be case-sensitive if I use uppercase in my query

" enough with the @@@s, show all you can if the last displayed line is too long
set display+=lastline
" show chars that cannot be displayed as <13> instead of ^M
set display+=uhex

" status line: we want it at all times -- white on blue, with ASCII code of the current letter
set statusline=%<%f%h%m%r%=char=%b=0x%B\ \ %l,%c%V\ %P
set laststatus=2
set highlight+=s:MyStatusLineHighlight
highlight MyStatusLineHighlight ctermbg=darkblue ctermfg=white

" tab line: blue as well to fit the theme
" (this is what appears instead of the status line when you use <tab> in command mode)
highlight TabLine ctermbg=darkblue ctermfg=gray
highlight TabLineSel ctermbg=darkblue ctermfg=yellow
highlight TabLineFill ctermbg=darkblue ctermfg=darkblue

" some tweaks taken from vimbits.com:
" reselect visual block after indent/outdent
vnoremap < <gv
vnoremap > >gv
" make Y behave like other capitals
map Y y$
" force saving files that require root permission
cmap w!! %!sudo tee > /dev/null %

" }}}
" ======================================================================================================
" <Tab> at the end of a word should attempt to complete it using tokens from the current file: {{{
function! My_Tab_Completion()
    if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
        return "\<C-P>"
    else
        return "\<Tab>"
endfunction
inoremap <Tab> <C-R>=My_Tab_Completion()<CR>
"
" }}}
" ======================================================================================================
" Specific settings for specific filetypes:  {{{

" usual policy: if there is a Makefile present, :mak calls make, otherwise we define a command to compile the filetype

" LaTeX
function! TEXSET()
  set makeprg=if\ \[\ -f\ \"Makefile\"\ \];then\ make\ $*;else\ if\ \[\ -f\ \"makefile\"\ \];then\ make\ $*;else\ pdfcslatex\ -file-line-error-style\ %;fi;fi
  set textwidth=0
  set nowrap
endfunction

" C/C++:
function! CSET()
  set makeprg=if\ \[\ -f\ \"Makefile\"\ \];then\ make\ $*;else\ if\ \[\ -f\ \"makefile\"\ \];then\ make\ $*;else\ gcc\ -O2\ -g\ -Wall\ -Wextra\ -o%.bin\ %\ -lm;fi;fi
  set cindent
  set textwidth=0
  set nowrap
endfunction

function! CPPSET()
  set makeprg=if\ \[\ -f\ \"Makefile\"\ \];then\ make\ $*;else\ if\ \[\ -f\ \"makefile\"\ \];then\ make\ $*;else\ g++\ -std=gnu++0x\ -O2\ -g\ -Wall\ -Wextra\ -o%.bin\ %;fi;fi
  set cindent
  set textwidth=0
  set nowrap
endfunction

" Java
function! JAVASET()
  set makeprg=if\ \[\ -f\ \"Makefile\"\ \];then\ make\ $*;else\ if\ \[\ -f\ \"makefile\"\ \];then\ make\ $*;else\ javac\ -g\ %;fi;fi
  set cindent
  set textwidth=0
  set nowrap
endfunction

" Pascal
function! PPSET()
  set makeprg=if\ \[\ -f\ \"Makefile\"\ \];then\ make\ $*;else\ if\ \[\ -f\ \"makefile\"\ \];then\ make\ $*;else\ fpc\ -g\ -O2\ -o\%.bin\ %;fi;fi
  set textwidth=0
  set nowrap
  " note: we do NOT want cindent here
endfunction

" vim scripts
function! VIMSET()
  set textwidth=0
  set nowrap
  set comments+=b:\"
endfunction

" Makefile
function! MAKEFILESET()
  set textwidth=0
  set nowrap
  " in a Makefile we need to use <Tab> to actually produce tabs
  set noexpandtab
  set softtabstop=8
  iunmap <Tab>
endfunction

" HTML/PHP
function! HTMLSET()
  set textwidth=0
  set nowrap
endfunction

" Asymptote
function! ASYSET()
  runtime asy.vim " find this somewhere and place it into ~/.vim/ for syntax highlighting to work
  set textwidth=0
  set nowrap
  set makeprg=if\ \[\ -f\ \"Makefile\"\ \];then\ make\ $*;else\ if\ \[\ -f\ \"makefile\"\ \];then\ make\ $*;else\ asy\ -noV\ -fpdf\ %\ -o\ %.pdf;fi;fi
  set errorformat=%f:\ %l.%c:\ %m
endfunction

" Python
function! PYSET()
  set textwidth=0
  set nowrap
endfunction

" Asymptote does not get recognized by default, fix it
augroup filetypedetect
autocmd BufNewFile,BufRead *.asy setfiletype asy
autocmd BufNewFile,BufRead *.cup setfiletype java

augroup END
filetype plugin on

" Autocommands for all languages:
autocmd FileType vim    call VIMSET()
autocmd FileType c      call CSET()
autocmd FileType C      call CPPSET()
autocmd FileType cc     call CPPSET()
autocmd FileType cpp    call CPPSET()
autocmd FileType java   call JAVASET()

autocmd FileType tex    call TEXSET()
autocmd FileType pascal call PPSET()
autocmd FileType make   call MAKEFILESET()
autocmd FileType html   call HTMLSET()
autocmd FileType php    call HTMLSET()
autocmd FileType asy    call ASYSET()
autocmd FileType python call PYSET()

autocmd FileType *      call JAVASET()
"
" }}}
" ======================================================================================================

 "Commenting blocks of code.
autocmd FileType c,cpp,java,scala let b:comment_leader = '// '
autocmd FileType sh,ruby,python   let b:comment_leader = '# '
autocmd FileType conf,fstab       let b:comment_leader = '# '
autocmd FileType tex              let b:comment_leader = '% '
autocmd FileType mail             let b:comment_leader = '> '
autocmd FileType vim              let b:comment_leader = '" '
noremap <silent> ,, :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
noremap <silent> .. :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>
" finally, tell the folds to fold on file open

nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

set fdm=marker
set commentstring=\ \"\ %s
