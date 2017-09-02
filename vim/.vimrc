" Name:   .vimrc
" Author: Titus Sanchez <titusjo@gmail.com>
"
" Derived from Steve Losh's vimrc (bitbucket.org/sjl/dotfiles)

" Preamble ----------------------------------------------------------------- {{{

set shell=/bin/bash
set term=screen-256color
set t_ut=
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#rc()

" }}}

" Plugin Options ----------------------------------------------------------- {{{

" CtrlP
let g:ctrlp_map = '<c-t>'
let g:ctrlp_cmd = 'CtrlP'

"}}}

" Bundles ------------------------------------------------------------------ {{{
Bundle 'VundleVim/Vundle.vim'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-unimpaired'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-endwise'
Bundle 'tpope/vim-haml'
Bundle 'tpope/vim-rails'
Bundle 'scrooloose/nerdtree'
Bundle 'kien/ctrlp.vim'
Bundle 'sirver/UltiSnips'
Bundle 'godlygeek/tabular'
Bundle 'rking/ag.vim'
Bundle 'honza/vim-snippets'
Bundle 'vim-scripts/restore_view.vim'
Bundle 'editorconfig/editorconfig-vim'

" Syntax
Bundle 'groenewege/vim-less'
Bundle 'kchmck/vim-coffee-script'

" Colors
Bundle 'tomasr/molokai'
Bundle 'altercation/vim-colors-solarized'

filetype plugin indent on " Placed after the bundles. Doesn't work otherwise.
" }}}

" Basic Options ------------------------------------------------------------ {{{
set encoding=utf-8
set smartindent
set showmode
set showcmd
set showmatch
set incsearch
set hlsearch
set ignorecase smartcase
set relativenumber
set number
set hidden
set visualbell
set ttyfast
set ruler
set laststatus=2
set history=10000
set undofile
set undoreload=10000
set list
set listchars=tab:▸\ ,trail:·,extends:❯,precedes:❮
set nowrap
set lazyredraw
set matchtime=2
set pastetoggle=<f4>
set splitbelow
set splitright
set shiftround
set foldmethod=manual
set title
"set linebreak
"set showbreak=↪
set dictionary=/usr/share/dict/words
set spellfile=~/.vim/custom-dictionary.utf-8.add

" iTerm2 is currently slow as at rendering the nice unicode lines, so for
" now I'll just use ascii pipes. They're ugly but at least I won't want to kill
" myself when trying to move around a file.
set fillchars=diff:⣿,vert:│
set fillchars=diff:⣿,vert:\|

" Don't try to highlight lines longer than 800 characters.
set synmaxcol=800

" Time out on key codes but not mappings.
" Basically this makes terminal Vim work sanely.
set notimeout
set ttimeout
set ttimeoutlen=10

" Make Vim able to edit crontab files again.
set backupskip=/tmp/*,/private/tmp/*"

" Resize splits when the window is resized
 au VimResized * :wincmd =

 " Backspace over auto-indents and line-breaks
 set backspace=indent,eol,start

" Leader
let mapleader = ","
let maplocalleader = "\\"

" Cursorline {{{
" Only show cursorline in the current window and in normal mode.

augroup cline
    au!
    au WinLeave,InsertEnter * set nocursorline
    au WinEnter,InsertLeave * set cursorline
augroup END

" }}}

" Wildmenu completion {{{
set wildmenu
set wildmode=list:longest
set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.DS_Store

set wildignore+=*.luac                           " Lua byte code

set wildignore+=migrations                       " Django migrations
set wildignore+=*.pyc                            " Python byte code

set wildignore+=node_modules
set wildignore+=vendor

" }}}

" Tabs, spaces, wrapping {{{
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
"set wrap
set textwidth=80
" }}}

" Backups {{{
set backup
set noswapfile

set undodir=~/.vim/tmp/undo//
set backupdir=~/.vim/tmp/backup//
set directory=~/.vim/tmp/swap//

" Make those folders automatically if they don't already exist.
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif

" }}}

" Color scheme {{{
syntax on
set t_Co=256
set background=dark
colorscheme solarized

if has('gui_running')
  set background=light
else
  set background=dark
endif
" }}}

" }}}

" Abbreviations ------------------------------------------------------------ {{{
iab <expr> clds strftime("* %a %b %d %Y Titus Sanchez <tsanchez@sendio.com>")

" }}}

" Functions ---------------------------------------------------------------- {{{
function! RenameFile()
  let old_name = expand('%')
  call inputsave()
  let new_name = input('New file name: ', expand('%'), 'file')
  call inputrestore()
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction

function! RenameWord()
  let old_name = expand('<cword>')
  call inputsave()
  let new_name = input('New name: ', expand('<cword>'))
  call inputrestore()
  if new_name != '' && new_name != old_name
    exec ':%s/' . old_name . '/' . new_name . '/gc'
  endif
endfunction

function! RunTestFile(...)
  if a:0
      let command_suffix = a:1
  else
      let command_suffix = ""
  endif

  " Run the tests for the previously-marked file.
  let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\)$') != -1
  if in_test_file
      call SetTestFile()
  elseif !exists("t:ts_test_file")
      return
  end
  call RunTests(t:ts_test_file . command_suffix)
endfunction

function! RunNearestTest()
  let spec_line_number = line('.')
  call RunTestFile(":" . spec_line_number)
endfunction

function! SetTestFile()
  " Set the spec file that tests will be run for.
  let t:ts_test_file=@%
endfunction

function! RunTests(filename)
  " Write the file and run tests for the given filename
  if expand("%") != ""
    :w
  end
  if match(a:filename, '\.feature$') != -1
      exec ":!script/features " . a:filename
  else
      if filereadable("script/test")
          exec ":!script/test " . a:filename
      elseif filereadable("Gemfile")
          exec ":!bundle exec rspec --color " . a:filename
      else
          exec ":!rspec --color " . a:filename
      end
  end
endfunction
" }}}


" Convenience Mappings ----------------------------------------------------- {{{

" Clipboard
vmap <leader>cp :!pbcopy<cr>u

" File management
nnoremap <leader><c-s>  :call RenameFile()<cr>

" Substitution
nnoremap <leader>sw :call RenameWord()<cr>

" Buffer Manipulaton
nnoremap <c-s>      :w<cr>
inoremap <c-s>      <esc>:w<cr>
nnoremap <leader>q  :q<cr>

" emacs movement
noremap <c-a>      ^
noremap <c-e>      $
inoremap <c-a>      <esc>I
inoremap <c-e>      <esc>A
vnoremap <c-a>      ^
vnoremap <c-e>      $

" split movement
nnoremap <leader>vs :vs 
nnoremap <c-j>      <c-w>j
nnoremap <c-k>      <c-w>k
nnoremap <c-h>      <c-w>h
nnoremap <c-l>      <c-w>l

" highlighting
nnoremap <leader>/  :nohl<cr>

" .vimrc
nnoremap <leader>ev :vs ~/.vimrc<cr>
nnoremap <leader>sv :source ~/.vimrc<cr>

"CtrlP
nnoremap <leader><c-t>  :CtrlPTag<cr>

" NERDTree
nnoremap <leader>n  :NERDTreeToggle<cr>

" Git
map <leader>gw  :Gwrite<cr>
map <leader>gd  :Gdiff<cr>
map <leader>gs  :Gstatus<cr>
map <leader>gc  :Gcommit -v<cr>

" Python
" Switch arguments/parameters
map <leader>xp F(l"wdt,xxf)i, <esc>"wp<esc>

" }}}

" Filetype specific -------------------------------------------------------- {{{
augroup ft_ruby
  au!
  au Filetype ruby nnoremap <buffer> <leader>r :!clear<cr>:!ruby %<cr>
  au Filetype ruby nnoremap <buffer> <leader>t :w<cr>:!clear<cr>:!rspec %<cr>
  au Filetype ruby nnoremap <buffer> <leader>T :w<cr>:!clear<cr>:call RunNearestTest()<cr>
augroup END

augroup ft_python
  au!
  au Filetype python nnoremap <buffer> <leader>r :w<cr>:!clear<cr>:!python %<cr>
  au Filetype python nnoremap <buffer> <leader>t :w<cr>:!clear<cr>:!pytest<cr>
augroup END

augroup ft_php
  au!
  au Filetype php nnoremap <buffer> <leader>r :w<cr>:!clear<cr>:!php %<cr>
  au Filetype php nnoremap <buffer> <leader>t :w<cr>:!clear<cr>:!vendor/bin/phpunit<cr>
augroup END
" }}}
