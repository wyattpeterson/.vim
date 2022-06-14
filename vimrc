" make sure vundle plays nice
filetype off
syntax off

"set rtp+=~/.vim/bundle/vundle/
"call vundle#rc()

" let Vundle manage Vundle
" required! 
"Bundle 'gmarik/vundle'

" my bundles
"Bundle 'Lokaltog/vim-easymotion'
" pig syntax
"Bundle "motus/pig.vim"
"Bundle 'Valloric/YouCompleteMe'


" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" golang plugin
Plugin 'faith/vim-go'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line


" set things back to normal
syntax on
filetype on
filetype plugin indent on

let mapleader=","

"" use spaces instead of tabs
set tabstop=4
set shiftwidth=4
set expandtab
set shiftround

"" better window movement
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

"" unix files are better
set fileformat=unix

"turn off beeping and flashing
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

" setup tab completion
au FileType python set omnifunc=pythoncomplete#Complete
let g:SuperTabDefaultCompletionType = "context"
set completeopt=menuone,longest,preview

" Fix backspace on FreeBSD
set backspace=indent,eol,start
""""""""""""""""""""""

" An easier mapping for "redo".
map U <C-R>

highlight Search   ctermfg=NONE  ctermbg=magenta guifg=NONE    guibg=yellow

set noautoindent
set autowrite
set nobackup
set nobinary
set noexrc
set hidden
set hlsearch
set ignorecase
set incsearch
set infercase
set joinspaces
set ruler
set secure
set shortmess=at
set number
set noshowmatch
set nosmartindent
set smartcase
set textwidth=0
set ttyfast
set undolevels=200
set wrapmargin=0
set wrapscan
set nowritebackup
set matchpairs+=<:>
set wildmode=longest:list

"" Show character undercursor
set statusline=%<%f%h%m%r%=%b\ 0x%B\ \ %l,%c%V\ %P
"" always show status line
set laststatus=2


"" move blocks of code around
"nnoremap <C-j> :m+<CR>==
"nnoremap <C-k> :m-2<CR>==
"inoremap <C-j> <Esc>:m+<CR>==gi
"inoremap <C-k> <Esc>:m-2<CR>==gi
"vnoremap <C-j> :m'>+<CR>gv=gv
"vnoremap <C-k> :m-2<CR>gv=gv

set nocompatible

" Font / colors
colorscheme desert

" Twig template syntax
au BufRead,BufNewFile *.tml set filetype=htmldjango

" Hive Query Files
au BufRead,BufNewFile *.hql set filetype=sql


set iskeyword=a-z,A-Z,48-57,_

" Show buffer list.
map + :buffers<CR>

" Cycle forward and backward through buffers.
map <C-N> :bn<CR>
map <C-P> :bp<CR>


" Turns of highsearch, once I've found what I'm looking for.
map ` :nohls<C-M>


set shellcmdflag=-ic

"delete the buffer; keep windows; create a scratch buffer if no buffers left
" credit: http://vim.wikia.com/wiki/Deleting_a_buffer_without_closing_the_window
function s:Kwbd(kwbdStage)
  if(a:kwbdStage == 1)
    if(!buflisted(winbufnr(0)))
      bd!
      return
    endif
    let s:kwbdBufNum = bufnr("%")
    let s:kwbdWinNum = winnr()
    windo call s:Kwbd(2)
    execute s:kwbdWinNum . 'wincmd w'
    let s:buflistedLeft = 0
    let s:bufFinalJump = 0
    let l:nBufs = bufnr("$")
    let l:i = 1
    while(l:i <= l:nBufs)
      if(l:i != s:kwbdBufNum)
        if(buflisted(l:i))
          let s:buflistedLeft = s:buflistedLeft + 1
        else
          if(bufexists(l:i) && !strlen(bufname(l:i)) && !s:bufFinalJump)
            let s:bufFinalJump = l:i
          endif
        endif
      endif
      let l:i = l:i + 1
    endwhile
    if(!s:buflistedLeft)
      if(s:bufFinalJump)
        windo if(buflisted(winbufnr(0))) | execute "b! " . s:bufFinalJump | endif
      else
        enew
        let l:newBuf = bufnr("%")
        windo if(buflisted(winbufnr(0))) | execute "b! " . l:newBuf | endif
      endif
      execute s:kwbdWinNum . 'wincmd w'
    endif
    if(buflisted(s:kwbdBufNum) || s:kwbdBufNum == bufnr("%"))
      execute "bd! " . s:kwbdBufNum
    endif
    if(!s:buflistedLeft)
      set buflisted
      set bufhidden=delete
      set buftype=nofile
      setlocal noswapfile
    endif
  else
    if(bufnr("%") == s:kwbdBufNum)
      let prevbufvar = bufnr("#")
      if(prevbufvar > 0 && buflisted(prevbufvar) && prevbufvar != s:kwbdBufNum)
        b #
      else
        bn
      endif
    endif
  endif
endfunction

command! Kwbd call <SID>Kwbd(1)
nnoremap <silent> <Plug>Kwbd :<C-u>Kwbd<CR>

" Create a mapping (e.g. in your .vimrc) like this:
nmap Q <Plug>Kwbd
