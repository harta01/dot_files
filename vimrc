" Plugins: {{{
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle
Plugin 'gmarik/Vundle.vim'

" My plugins
Bundle 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
" Bundle 'Lokaltog/vim-easymotion'
Bundle 'scrooloose/syntastic'
Bundle 'scrooloose/nerdtree'
Bundle 'tpope/vim-surround'
Bundle 'nanotech/jellybeans.vim'
Bundle 'kien/ctrlp.vim'
Bundle 'airblade/vim-gitgutter'
Bundle 'tpope/vim-fugitive'
Bundle 'mileszs/ack.vim'
Bundle 'vsushkov/nerdtree-ack'

call vundle#end()
filetype plugin indent on
" }}}

" Plugin settings: {{{
" powerline
set rtp+=$HOME/.local/lib/python2.7/site-packages/powerline/bindings/vim/
set laststatus=2
set t_Co=256
" nerdtree
map <C-n> :NERDTreeToggle<CR>
" jellybeans
color jellybeans
" ctrlp
map <C-p> :CtrlP<CR>
" }}}

" Stuffs that should be set by default: {{{
syntax on
set nocompatible  " use new features whenever they are available
set bs=2          " backspace should work as we expect
set autoindent    " 
set history=50    " remember last 50 commands
set ruler         " show cursor position in bottom line
set nu            " show line number
set hlsearch      " highlight search result
" y and d put stuff into system clipboard (so that other apps can see it)
set clipboard=unnamed,unnamedplus
" }}}

" Shortcuts

" Tab related stuffs: {{{
set shiftwidth=4  " tab size = 4
set expandtab
set softtabstop=4
set shiftround    " when shifting non-aligned set of lines, align them to next tabstop
" }}}

" Misc {{{
set background=dark
set autoread      " auto re-read changes outside vim
set autowrite     " auto save before make/execute
set pastetoggle=<F10>
" The following line is disabled to make powerline work
" set showcmd
set timeout       " adjust timeout for mapped commands
set timeoutlen=200

set visualbell    " Tell vim to shutup
set noerrorbells  " Tell vim to shutup!
" }}}

" Display related: {{{
set display+=lastline " Show everything you can in the last line (intead of stupid @@@)
set display+=uhex     " Show chars that cannot be displayed as <13> instead of ^M
" }}}

" Searching {{{
set incsearch     " show first match when start typing
set ignorecase    " default should ignore case
set smartcase     " use case sensitive if I use uppercase
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
" }}}
" ======================================================================================================

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
  set makeprg=if\ \[\ -f\ \"Makefile\"\ \];then\ make\ $*;else\ if\ \[\ -f\ \"makefile\"\ \];then\ make\ $*;else\ g++\ -std=gnu++0x\ -O2\ -g\ -Wall\ -Wextra\ -o\ %<\ %;fi;fi
  set cindent
  set textwidth=0
  set nowrap
  nnoremap <buffer> <F9> :w<cr>:!clang++ % -o %< -std=c++11 -stdlib=libc++ -I ./<cr>:!./%<<cr>
  nnoremap <buffer> <F8> :w<cr>:!clang++ % -o %< -std=c++11 -stdlib=libc++ -I ./<cr>
  nnoremap <C-c> ^i// <esc>
endfunction

" Java
function! JAVASET()
  set makeprg=if\ \[\ -f\ \"Makefile\"\ \];then\ make\ $*;else\ if\ \[\ -f\ \"makefile\"\ \];then\ make\ $*;else\ javac\ -g\ %;fi;fi
  set cindent
  set textwidth=0
  set nowrap
  nnoremap <buffer> <F9> :make<cr>:!java %< %<cr>
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

" Python
function! PYSET()
  set textwidth=0
  set nowrap
  nnoremap <buffer> <F9> :exec '!python' shellescape(@%, 1)<cr>
endfunction

" Ruby
function! RUBYSET()
  set tabstop=2
  set softtabstop=2
  set shiftwidth=2
  set expandtab
  nnoremap <buffer> <F9> :exec '!ruby' shellescape(@%, 1)<cr>
  nnoremap <buffer> <F8> :exec '!rspec' shellescape(@%, 1)<cr>
endfunction

" Markdown
function! MARKDOWNSET()
    set wrap
endfunction

" Identify Markdown files
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

" Autocommands for all languages:
autocmd FileType vim    call VIMSET()
autocmd FileType c      call CSET()
autocmd FileType C      call CPPSET()
autocmd FileType cc     call CPPSET()
autocmd FileType cpp    call CPPSET()
autocmd FileType tex    call TEXSET()
autocmd FileType make   call MAKEFILESET()
autocmd FileType html   call HTMLSET()
autocmd FileType php    call HTMLSET()
autocmd FileType python call PYSET()
autocmd FileType ruby   call RUBYSET()
autocmd Filetype markdown call MARKDOWNSET()
" }}}
" ======================================================================================================

