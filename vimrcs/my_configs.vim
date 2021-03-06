""""""""""""""""""""""""""""""
" => VIM related
""""""""""""""""""""""""""""""
set relativenumber
syntax enable
let g:solarized_termcolors=256
"colorscheme solarized
colorscheme gruvbox
"if &diff
"    colorscheme pyte
"endif

set fileformat=unix
set fileformats=unix,dos
set number
map <leader>wo :only<cr>
map <leader>bo :w \| %bd \| e#<cr>
map <silent> <leader>l :bnext<cr>
map <silent> <leader>h :bprevious<cr>
"nnoremap <c-a> ggVG

"hi Search ctermfg=8
"light
hi Search ctermfg=7
set wildignore+=**/node_modules/**
set foldmethod=manual
vnoremap <space>y "*y
nnoremap <space>P "0p
vnoremap <space>P "0p
nnoremap vv <c-v>

function! TabCloseRight(bang)
    let cur=tabpagenr()
    while cur < tabpagenr('$')
        exe 'tabclose' . a:bang . ' ' . (cur + 1)
    endwhile
endfunction

function! TabCloseLeft(bang)
    while tabpagenr() > 1
        exe 'tabclose' . a:bang . ' 1'
    endwhile
endfunction

function! DeleteEmptyBuffers()
    let [i, n; empty] = [1, bufnr('$')]
    while i <= n
        if bufexists(i) && bufname(i) == ''
            call add(empty, i)
        endif
        let i += 1
    endwhile
    if len(empty) > 0
        exe 'bdelete' join(empty)
    endif
endfunction

" Delete trailing white space on save, useful for some filetypes ;)
function! TrimTrailingWhitespace()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfunction

command! -bang Tabcloseright call TabCloseRight('<bang>')
command! -bang Tabcloseleft call TabCloseLeft('<bang>')
command! -bang Trimtrailingwhitespace call TrimTrailingWhitespace()
command! DeleteEmptyBuffers call DeleteEmptyBuffers()

map <leader>tcl :Tabcloseleft<cr>
map <leader>tcr :Tabcloseright<cr>
map <leader>bde :DeleteEmptyBuffers<cr>

nnoremap <silent> <leader>s1 : call CreateSession('s1') <cr>
nnoremap <silent> <leader>s2 : call CreateSession('s2') <cr>
nnoremap <silent> <leader>s3 : call CreateSession('s3') <cr>
nnoremap <silent> <leader>s4 : call CreateSession('s4') <cr>
nnoremap <silent> <leader>s5 : call CreateSession('s5') <cr>

function! CreateSession(sessionName)
    exe "mks! ". a:sessionName
    echo "created session ". a:sessionName
endfunction

nnoremap <silent> <leader>1 :b1 <cr>
nnoremap <silent> <leader>2 :b2 <cr>
nnoremap <silent> <leader>3 :b3 <cr>
nnoremap <silent> <leader>4 :b4 <cr>
nnoremap <silent> <leader>5 :b5 <cr>
nnoremap <silent> <leader>6 :b6 <cr>
nnoremap <silent> <leader>7 :b7 <cr>
nnoremap <silent> <leader>8 :b8 <cr>
nnoremap <silent> <leader>9 :b9 <cr>
nnoremap <silent> <leader>0 :b# <cr>
nmap <leader>bl <c-^><cr>

:tnoremap <Esc> <C-\><C-n>
:tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'"'
set foldnestmax=10
set foldlevel=2

" Tabe *.py *.txt
command! -complete=file -nargs=* Tabe call Tabe(<f-args>)
function! Tabe(...)
  let t = tabpagenr()
  let i = 0
  for f in a:000
    for g in glob(f, 0, 1)
      exe "tabe " . fnameescape(g)
      let i = i + 1
    endfor
  endfor
  if i
    exe "tabn " . (t + 1)
  endif
endfunction


function! CscopeDone()
	exe "cs add cscope.out"
endfunc

function! CscopeUpdate()
	try | exe "cs kill cscope.out" | catch | endtry
	exe "AsyncRun -post=call\\ g:CscopeDone() ".
                \ "git ls-files >cscope.files && ".
				\ "cscope -bi cscope.files"
endfunction

command! CscopeUpdate call CscopeUpdate()
""""""""""""""""""""""""""""""
" => CTRL-P
""""""""""""""""""""""""""""""
let g:ctrlp_prompt_mappings = {
    \ 'AcceptSelection("e")': ['<2-LeftMouse>'],
    \ 'AcceptSelection("t")': ['<cr>'],
    \ }
let g:ctrlp_max_files = 0
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
"nnoremap <Leader>b :CtrlPBuffer<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Syntastic (syntax checker)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'typescript': ['tsserver', 'eslint', 'typecheck'],
\   'python': ['pylint', 'flake8', 'mypy'],
\   'go': ['go', 'golint', 'errcheck']
\}
let g:ale_javascript_prettier_eslint_use_global = 1
let g:ale_javascript_eslint_use_global = 1

""""""""""""""""""""""""""""""
" => FZF
""""""""""""""""""""""""""""""
set rtp+=~/.vim_runtime/my_plugins/fzf
"nnoremap <leader>j :GFiles<CR>
nnoremap <leader>j :FZF<CR>
nnoremap <leader>J :Files<CR>
nmap <Leader>L :Lines<CR>
"nmap <Leader>bb  :buffers<CR>
nmap <Leader>bb  :Buffers<CR>
nmap <Leader>t :Tags<CR>
"nmap <C-i> :History:<CR>


" rg: ripgrep
if executable('rg')
  let g:ackprg = 'rg --vimgrep --smart-case'
endif

""""""""""""""""""""""""""""""
" => Nerd Tree
""""""""""""""""""""""""""""""
let g:NERDTreeChDirMode=2
let g:NERDTreeWinSize = 60
let g:NERDTreeWinPos = "left"
"let NERDTreeQuitOnOpen=1
autocmd FileType nerdtree setlocal relativenumber


set tabpagemax=50


"let g:ctrlp_custom_ignore = '\v[\/](node_modules|target|dist)|(\.(swp|ico|git|svn))$'

"if executable('ag')
"    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
"endif

"if isdirectory(".git")
"    let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
"endif

"--------------------------------------------------------------------------------

"git clone --depth 1 https://github.com/junegunn/fzf.git ~/.vim_runtime/my_plugins/fzf
"git clone --depth 1 https://github.com/junegunn/fzf.git ~/.vim_runtime/my_plugins/fzf.vim

filetype plugin on
autocmd FileType python setlocal expandtab shiftwidth=4 softtabstop=4

"set backup
"set wb
"set swapfile
let g:deoplete#enable_at_startup = 1


let g:ranger_map_keys = 0

nmap <silent> \f :Ranger<CR><CR>



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CSCOPE settings for vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" This file contains some boilerplate settings for vim's cscope interface,
" plus some keyboard mappings that I've found useful.
"
" USAGE:
" -- vim 6:     Stick this file in your ~/.vim/plugin directory (or in a
"               'plugin' directory in some other directory that is in your
"               'runtimepath'.
"
" -- vim 5:     Stick this file somewhere and 'source cscope.vim' it from
"               your ~/.vimrc file (or cut and paste it into your .vimrc).
"
" NOTE:
" These key maps use multiple keystrokes (2 or 3 keys).  If you find that vim
" keeps timing you out before you can complete them, try changing your timeout
" settings, as explained below.
"
" Happy cscoping,
"
" Jason Duell       jduell@alumni.princeton.edu     2002/3/7
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" This tests to see if vim was configured with the '--enable-cscope' option
" when it was compiled.  If it wasn't, time to recompile vim...
if has("cscope")

    """"""""""""" Standard cscope/vim boilerplate

    " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
    set cscopetag

    " check cscope for definition of a symbol before checking ctags: set to 1
    " if you want the reverse search order.
    set csto=0

    " add any cscope database in current directory
    if filereadable("cscope.out")
        cs add cscope.out
    " else add the database pointed to by environment variable
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif

    " show msg when any other cscope db added
    set cscopeverbose


    """"""""""""" My cscope/vim key mappings
    "
    " The following maps all invoke one of the following cscope search types:
    "
    "   add  : Add a new database             (Usage: add file|dir [pre-path] [flags])
    "    find : Query for a pattern            (Usage: find a|c|d|e|f|g|i|s|t name)
    "           a: Find assignments to this symbol
    "           c: Find functions calling this function
    "           d: Find functions called by this function
    "           e: Find this egrep pattern
    "           f: Find this file
    "           g: Find this definition
    "           i: Find files #including this file
    "           s: Find this C symbol
    "           t: Find this text string
    "    help : Show this message              (Usage: help)
    "    kill : Kill a connection              (Usage: kill #)
    "    reset: Reinit all connections         (Usage: reset)
    "    show : Show connections               (Usage: show)
    "    Press ENTER or type command to continue

    "
    " Below are three sets of the maps: one set that just jumps to your
    " search result, one that splits the existing vim window horizontally and
    " diplays your search result in the new window, and one that does the same
    " thing, but does a vertical split instead (vim 6 only).
    "
    " I've used CTRL-\ and CTRL-Space as the starting keys for these maps, as it's
    " unlikely that you need their default mappings (CTRL-\'s default use is
    " as part of CTRL-\ CTRL-N typemap, which basically just does the same
    " thing as hitting 'escape': CTRL-Space doesn't seem to have any default use).
    " If you don't like using 'CTRL-Space' or CTRL-\, , you can change some or all
    " of these maps to use other keys.  One likely candidate is 'CTRL-_'
    " (which also maps to CTRL-/, which is easier to type).  By default it is
    " used to switch between Hebrew and English keyboard mode.
    "
    " All of the maps involving the <cfile> macro use '^<cfile>$': this is so
    " that searches over '#include <time.h>" return only references to
    " 'time.h', and not 'sys/time.h', etc. (by default cscope will return all
    " files that contain 'time.h' as part of their name).


    " To do the first type of search, hit 'CTRL-\', followed by one of the
    " cscope search types above (s,g,c,t,e,f,i,d).  The result of your cscope
    " search will be displayed in the current window.  You can use CTRL-T to
    " go back to where you were before the search.
    "

    nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>


    "Messy way to get this working in gvim and vim on linux, not sure about
    "other platforms.
    "TODO neaten
    if has("gui_running")
        " Using 'CTRL-spacebar' (intepreted as CTRL-Space by vim) then a search type
        " makes the vim window split horizontally, with search result displayed in
        " the new window.
        "
        " (Note: earlier versions of vim may not have the :scs command, but it
        " can be simulated roughly via:
        "    nmap <C-Space>s <C-W><C-S> :cs find s <C-R>=expand("<cword>")<CR><CR>

        nmap <C-Space>s :scs find s <C-R>=expand("<cword>")<CR><CR>
        nmap <C-Space>g :scs find g <C-R>=expand("<cword>")<CR><CR>
        nmap <C-Space>c :scs find c <C-R>=expand("<cword>")<CR><CR>
        nmap <C-Space>t :scs find t <C-R>=expand("<cword>")<CR><CR>
        nmap <C-Space>e :scs find e <C-R>=expand("<cword>")<CR><CR>
        nmap <C-Space>f :scs find f <C-R>=expand("<cfile>")<CR><CR>
        nmap <C-Space>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
        nmap <C-Space>d :scs find d <C-R>=expand("<cword>")<CR><CR>


        " Hitting CTRL-space *twice* before the search type does a vertical
        " split instead of a horizontal one (vim 6 and up only)
        "
        " (Note: you may wish to put a 'set splitright' in your .vimrc
        " if you prefer the new window on the right instead of the left

        nmap <C-Space><C-Space>s :tab cs find s <C-R>=expand("<cword>")<CR><CR>
        nmap <C-Space><C-Space>g :tab cs find g <C-R>=expand("<cword>")<CR><CR>
        nmap <C-Space><C-Space>c :tab cs find c <C-R>=expand("<cword>")<CR><CR>
        nmap <C-Space><C-Space>t :tab cs find t <C-R>=expand("<cword>")<CR><CR>
        nmap <C-Space><C-Space>e :tab cs find e <C-R>=expand("<cword>")<CR><CR>
        nmap <C-Space><C-Space>f :tab cs find f <C-R>=expand("<cfile>")<CR><CR>
        nmap <C-Space><C-Space>i :tab cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
        nmap <C-Space><C-Space>d :tab cs find d <C-R>=expand("<cword>")<CR><CR>
    else
        " Using 'CTRL-spacebar' (intepreted as CTRL-@ by vim) then a search type
        " makes the vim window split horizontally, with search result displayed in
        " the new window.
        "
        " (Note: earlier versions of vim may not have the :scs command, but it
        " can be simulated roughly via:
        "    nmap <C-@>s <C-W><C-S> :cs find s <C-R>=expand("<cword>")<CR><CR>

        nmap <C-@>s :scs find s <C-R>=expand("<cword>")<CR><CR>
        nmap <C-@>g :scs find g <C-R>=expand("<cword>")<CR><CR>
        nmap <C-@>c :scs find c <C-R>=expand("<cword>")<CR><CR>
        nmap <C-@>t :scs find t <C-R>=expand("<cword>")<CR><CR>
        nmap <C-@>e :scs find e <C-R>=expand("<cword>")<CR><CR>
        nmap <C-@>f :scs find f <C-R>=expand("<cfile>")<CR><CR>
        nmap <C-@>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
        nmap <C-@>d :scs find d <C-R>=expand("<cword>")<CR><CR>


        " Hitting CTRL-space *twice* before the search type does a vertical
        " split instead of a horizontal one (vim 6 and up only)
        "
        " (Note: you may wish to put a 'set splitright' in your .vimrc
        " if you prefer the new window on the right instead of the left

        nmap <C-@><C-@>s :tab cs find s <C-R>=expand("<cword>")<CR><CR>
        nmap <C-@><C-@>g :tab cs find g <C-R>=expand("<cword>")<CR><CR>
        nmap <C-@><C-@>c :tab cs find c <C-R>=expand("<cword>")<CR><CR>
        nmap <C-@><C-@>t :tab cs find t <C-R>=expand("<cword>")<CR><CR>
        nmap <C-@><C-@>e :tab cs find e <C-R>=expand("<cword>")<CR><CR>
        nmap <C-@><C-@>f :tab cs find f <C-R>=expand("<cfile>")<CR><CR>
        nmap <C-@><C-@>i :tab cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
        nmap <C-@><C-@>d :tab cs find d <C-R>=expand("<cword>")<CR><CR>
    endif


    """"""""""""" key map timeouts
    "
    " By default Vim will only wait 1 second for each keystroke in a mapping.
    " You may find that too short with the above typemaps.  If so, you should
    " either turn off mapping timeouts via 'notimeout'.
    "
    "set notimeout
    "
    " Or, you can keep timeouts, by uncommenting the timeoutlen line below,
    " with your own personal favorite value (in milliseconds):
    "
    "set timeoutlen=4000
    "
    " Either way, since mapping timeout settings by default also set the
    " timeouts for multicharacter 'keys codes' (like <F1>), you should also
    " set ttimeout and ttimeoutlen: otherwise, you will experience strange
    " delays as vim waits for a keystroke after you hit ESC (it will be
    " waiting to see if the ESC is actually part of a key code like <F1>).
    "
    "set ttimeout
    "
    " personally, I find a tenth of a second to work well for key code
    " timeouts. If you experience problems and have a slow terminal or network
    " connection, set it higher.  If you don't set ttimeoutlen, the value for
    " timeoutlent (default: 1000 = 1 second, which is sluggish) is used.
    "
    "set ttimeoutlen=100

endif



augroup autoformat_settings
"  autocmd FileType bzl AutoFormatBuffer buildifier
"  autocmd FileType c,cpp,proto,javascript AutoFormatBuffer clang-format
"  autocmd FileType dart AutoFormatBuffer dartfmt
"  autocmd FileType go AutoFormatBuffer gofmt
"  autocmd FileType gn AutoFormatBuffer gn
"  autocmd FileType html,css,sass,scss,less,json AutoFormatBuffer js-beautify
"  autocmd FileType java AutoFormatBuffer google-java-format
"  autocmd FileType python AutoFormatBuffer yapf
"  " Alternative: autocmd FileType python AutoFormatBuffer autopep8
    autocmd FileType rust AutoFormatBuffer rustfmt
    "autocmd FileType vue AutoFormatBuffer prettier
augroup END
set nofoldenable

" vim-peekaboo
let g:peekaboo_window = "vert bo 50new"
let g:peekaboo_delay = 700

"===========ycm===================
nmap gd :YcmCompleter GoToDefinition<CR>
nmap gD :YcmCompleter GoToDeclaration<CR>
nmap gr :YcmCompleter GoToReferences<CR>
nnoremap K :YcmCompleter GetDoc<CR>

"==========gitgutter==============
nmap ]c <Plug>(GitGutterNextHunk)
nmap [c <Plug>(GitGutterPrevHunk)
let g:gitgutter_map_keys = 0



"lightline-buffer
set hidden  " allow buffer switching without saving
set showtabline=2  " always show tabline

" use lightline-buffer in lightline
"'bufnum'
let g:lightline = {
    \ 'active': {
    \   'left': [ ['mode', 'paste'],
    \             ['fugitive', 'readonly', 'filename', 'modified'] ],
    \   'right': [ [ 'lineinfo' ], ['percent'] ]
    \ },
    \ 'tabline': {
    \   'left': [ [ 'bufferinfo' ],
    \             [ 'separator' ],
    \             [ 'bufferbefore', 'buffercurrent', 'bufferafter' ], ],
    \   'right': [ [ 'close' ], ],
    \ },
    \ 'component_expand': {
    \   'buffercurrent': 'lightline#buffer#buffercurrent',
    \   'bufferbefore': 'lightline#buffer#bufferbefore',
    \   'bufferafter': 'lightline#buffer#bufferafter',
    \ },
    \ 'component_type': {
    \   'buffercurrent': 'tabsel',
    \   'bufferbefore': 'raw',
    \   'bufferafter': 'raw',
    \ },
    \ 'component_function': {
    \   'bufferinfo': 'lightline#buffer#bufferinfo',
    \ },
    \ 'component': {
    \   'separator': '',
    \   'readonly': '%{&filetype=="help"?"":&readonly?"🔒":""}',
    \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
    \   'fugitive': '%{exists("*FugitiveHead")?FugitiveHead():""}'
    \ },
    \ }

" remap arrow keys
"nnoremap <Left> :bprev<CR>
"nnoremap <Right> :bnext<CR>

" lightline-buffer ui settings
" replace these symbols with ascii characters if your environment does not support unicode
let g:lightline_buffer_logo = ' '
let g:lightline_buffer_readonly_icon = ''
let g:lightline_buffer_modified_icon = '✭'
let g:lightline_buffer_git_icon = ' '
let g:lightline_buffer_ellipsis_icon = '..'
let g:lightline_buffer_expand_left_icon = '◀ '
let g:lightline_buffer_expand_right_icon = ' ▶'
let g:lightline_buffer_active_buffer_left_icon = ''
let g:lightline_buffer_active_buffer_right_icon = ''
let g:lightline_buffer_separator_icon = '  '

" enable devicons, only support utf-8
" require <https://github.com/ryanoasis/vim-devicons>
let g:lightline_buffer_enable_devicons = 1

" lightline-buffer function settings
let g:lightline_buffer_show_bufnr = 1

" :help filename-modifiers
let g:lightline_buffer_fname_mod = ':t'

" hide buffer list
let g:lightline_buffer_excludes = ['vimfiler']

" max file name length
let g:lightline_buffer_maxflen = 30

" max file extension length
let g:lightline_buffer_maxfextlen = 3

" min file name length
let g:lightline_buffer_minflen = 16

" min file extension length
let g:lightline_buffer_minfextlen = 3

" reserve length for other component (e.g. info, close)
let g:lightline_buffer_reservelen = 20

""""""""""""""""""""""""""""""""""""""
