" Download vim-plug if it's not installed yet
if empty(glob("~/.vim/autoload/plug.vim"))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  auto VimEnter * PlugInstall
endif

if !empty(glob("~/.fzf/bin/fzf"))
  if empty(glob("~/.fzf/bin/rg"))
    silent !curl -fLo /tmp/rg.tar.gz
          \ https://github.com/BurntSushi/ripgrep/releases/download/0.4.0/ripgrep-0.4.0-x86_64-unknown-linux-musl.tar.gz
    silent !tar xzvf /tmp/rg.tar.gz --directory /tmp
    silent !cp /tmp/ripgrep-0.4.0-x86_64-unknown-linux-musl/rg ~/.fzf/bin/rg
  endif
endif

set history=700             " Sets how many lines vim has to remember
set autoread                " Set to auto read when a file is changed from the outside
set ignorecase
set smartcase
set hidden
let mapleader=","           " Leader is comma
set backspace=indent,eol,start
set confirm
set encoding=UTF-8
map Y yy

" :W sudo saves the file
" (useful for handling the permission-denied error)
command W w !sudo tee % > /dev/null

cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev Q q
cnoreabbrev Qall qall

" Opens a tab edit command with the path of the currently edited file filled
noremap <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

" Opens a tab edit command with the path of the currently edited file filled
imap jj <Esc>
imap kk <Esc>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spaces & Tabs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set tabstop=4               " Number of visual spaces per TAB
set softtabstop=4           " Number of spaces in tab when editing
set expandtab               " Tabs are spaces

autocmd FileType javascript setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd FileType php setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd FileType yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd FileType yml setlocal tabstop=2 softtabstop=2 shiftwidth=2

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => UI
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set number                  " Add line numbers
set showcmd                 " Show command in bottom bar
set cursorline              " Highlight current line
filetype indent on          " Load filetype-specific indent files
set wildmenu                " Visual autocomplete for command menu
set lazyredraw              " Redraw only when needed
set showmatch               " Highlight matching brackets
set foldcolumn=0            " Add a margin to the left
set laststatus=2            " Size for the status bar
set noshowmode              " Hides the mode below the status line

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
        set wildignore+=.git\*,.hg\*,.svn\*
else
        set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

" Colour correction or something
if (empty($TMUX))
        if (has("nvim"))
                let $NVIM_TUI_ENABLE_TRUE_COLOR=1
        endif
        if (has("termguicolors"))
                set termguicolors
        endif
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax enable               " Syntax theme
" colorscheme dracula         " awesome colorscheme
color onedark

" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
        set t_Co=256
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Searching
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set incsearch               " Search as characters are typed
set hlsearch                " Hightlight matches
" Turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>

" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Movement
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Move vertically by visual line
nnoremap j gj
nnoremap k gk
" Move to beginning/end of line
nnoremap B ^
nnoremap E $

" $/^ doesn't do anything
" nnoremap $ <nop>
" nnoremap ^ <nop>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Use tab to switch tabs
" nnoremap <Tab> gt

" Vmap for maintain Visual Mode after shifting > and <
vmap < <gv
vmap > >gv

" Split
noremap <Leader>h :<C-u>split<CR>
noremap <Leader>v :<C-u>vsplit<CR>

" Return to last edit position when opening files
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pasting shortcut
set pastetoggle=<F3>

" Toggle between number and relativenumber
function! ToggleNumber()
        if(&relativenumber == 1)
                set norelativenumber
                set number
        else
                set relativenumber
        endif
endfunc

" Strips trailing whitespace at the end of files. This
" is called on buffer write in the autogroup above.
function! <SID>StripTrailingWhitespaces()
        " save last search & cursor position
        let _s=@/
        let l = line(".")
        let c = col(".")
        %s/\s\+$//e
        let @/=_s
        call cursor(l, c)
endfunction

autocmd VimEnter * call ToggleNumber()

let g:rg_command = '
\ rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --color "always"
\ -g "*.{ts,js,json,php,md,styl,pug,jade,html,config,py,cpp,c,go,hs,rb,conf,fa,lst}"
\ -g "!{.config,.git,**/node_modules,**/vendor,**/build,yarn.lock,*.sty,*.bst,*.coffee,**/dist,**/cordova}/*" '

command! -bang -nargs=* F call fzf#vim#grep(g:rg_command .shellescape(<q-args>), 1, <bang>0)

function! s:repeat_block(key) abort
  if a:key ==# '.'
    return get(s:, 'v_repeat_count', '').get(s:, 'v_repeat_key', '')
  endif

  let s:v_repeat_count = v:count1
  let s:v_repeat_key = a:key
  return a:key
endfunction

for k in ['w', 'W', 's', 'p', '[', ']', '(', ')', 'b', '<', '>', 't', '{', '}', 'B', '"', "'", '`']
  execute printf('vnoremap <expr> a%s <sid>repeat_block(''a%s'')', k, k)
  execute printf('vnoremap <expr> i%s <sid>repeat_block(''i%s'')', k, k)
endfor

unlet! k

vnoremap <expr> . <sid>repeat_block('.')

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

call plug#begin('~/.vim/bundle')

" Workflow
Plug 'scrooloose/nerdtree'                  " A tree explorer plugin for vim
Plug 'tpope/vim-commentary'                 " Comment stuff
Plug 'Chiel92/vim-autoformat'               " Autoformat
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " Fuzy file finder
Plug 'junegunn/fzf.vim'                     " Fuzy file finder
Plug 'w0rp/ale'                             " Linter/formatter
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'terryma/vim-expand-region'            " Expand selection

"" Appearance
Plug 'itchyny/lightline.vim'                " A light and configurable statusline/tabline plugin for Vim
Plug 'jistr/vim-nerdtree-tabs'              " Nerdtree tabs
Plug 'sheerun/vim-polyglot'                 " Syntax pack

"" Snippets
Plug 'SirVer/ultisnips'                     " Snippet engine
Plug 'honza/vim-snippets'                   " General snippets
Plug 'isRuslan/vim-es6'                     " Snippets for ES6

"" Colorschemes
Plug 'dracula/vim', {'as': 'dracula'}       " Dracula theme

call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Plugin Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype plugin on              " Enable plugin

" nerdtree
map <C-n> :NERDTreeTabsToggle<CR>
let g:NERDTreeIgnore=['\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__']
let g:NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$', '\.bak$', '\~$']
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite

" Open a NERDTree automatically if no file is specified
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" ALE settings
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['prettier', 'eslint'],
\}

" Snippet trigger key
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<S-Tab>"
let g:UltiSnipsEditSplit="vertical"

" FZF settings
nnoremap <C-b> :Buffers<CR>
nnoremap <C-g> :GFiles<CR>
nnoremap <leader><leader> :Commands<CR>
nnoremap <space> :PrettierAsync<CR>
