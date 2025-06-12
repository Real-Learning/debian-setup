" Fix some security vulnerability by disabling some vulnerable feature which you don't need anyway
set modelines=0		" CVE-2007-2438

" Normally we use vim-extensions. If you want true vi-compatibility
" remove change the following statements
set nocompatible	" Use Vim defaults instead of 100% vi compatibility
set backspace=2		" more powerful backspacing

" Don't write backup file if vim is being called by "crontab -e"
au BufWrite /private/tmp/crontab.* set nowritebackup nobackup
" Don't write backup file if vim is being called by "chpass"
au BufWrite /private/etc/pw.* set nowritebackup nobackup

" do not try to load a default vimrc config since it may conflict with the current one
let skip_defaults_vim=1

" on a new line, automatically put leading spaces as were on your previous line
set autoindent
" show line numbers
set number
" highlight column 121 to show if your code is waay too wide
set colorcolumn=121
" always be in the same directory as the file you edit
set autochdir
" do not show a long line as multiple lines - it is confusing and annoying
set nowrap
" highlight the current line for better visibility
set cursorline
" show vim tabs if there are more than a single tab open
set showtabline=2

" move around the file as you type your search query
set incsearch
" once the search done, highlight all the search matches
set hlsearch
" hotkey to stop highlighting search matches
nmap ` :nohl<CR>

" enable syntax highlighting
syn on
" parse files for syntax highlighting from the start. This is the most correct method. Can potentially be slow on really big files.
autocmd BufEnter * :syntax sync fromstart

colorscheme desertink

" enable vim plugin allowing to detect file types based on the extensions and shebang
filetype plugin on
" different languages have different indentation styles. These settings enable different configurations based on the file type and configure each file type appropriately
" tabstop is how many spaces long a single tab is, softtabstop should be always the same (generally useless feature otherwise), and expandtab determines whether we automatically convert tabs to spaces or not.
autocmd FileType py setlocal tabstop=4 softtabstop=4 expandtab
autocmd FileType bzl setlocal tabstop=4 softtabstop=4 expandtab
autocmd FileType vim setlocal tabstop=4 softtabstop=4 expandtab
autocmd FileType go setlocal tabstop=4 noexpandtab
autocmd FileType java setlocal tabstop=2 softtabstop=2 expandtab
autocmd FileType sh,bash,zsh setlocal tabstop=2 softtabstop=2 expandtab
autocmd FileType sql setlocal tabstop=2 softtabstop=2 expandtab
autocmd FileType yaml,yml setlocal tabstop=2 softtabstop=2 expandtab
autocmd FileType json setlocal tabstop=2 softtabstop=2 expandtab
" disable another useless feature you shouldn't care about
autocmd BufEnter setlocal shiftwidth=0

" type :T2<Enter> command to force 2-space tab expanded to spaces
command T2 :setlocal tabstop=2 softtabstop=2 expandtab <bar>
" or just hit ,2
autocmd VimEnter * nmap ,2 :T2<CR>
" type :T4<Enter> command to force 4-space tab not expanded to spaces
command T4 :setlocal tabstop=4 noexpandtab <bar>
" or just hit ,4
autocmd VimEnter * nmap ,4 :T4<CR>
" type :TE4<Enter> command to force 4-space tab expanded to spaces
command TE4 :setlocal tabstop=4 softtabstop=4 expandtab <bar>

" allow to fold blocks of code into a single line. Use line indentations for folding borders - fastest and the most reliable method, but leaves up to a couple of extra lines behind (just 1 line for Python)
set foldmethod=indent
" keep everything unfolded when just opening a file
set foldlevel=100
" put a single column on the left showing what can be folded and what will be folded together
set foldcolumn=1

" allow to open up to 30 files at once.
set tabpagemax=30
" ctrl-l to move to the next tab
nmap <C-L> :tabnext<CR>
" ctrl-l to move to the next tab even from the insert mode
imap <C-L> <Esc>:tabnext<CR>
" ctrl-h to move to the previous tab
nmap <C-H> :tabprev<CR>
" ctrl-h to move to the previous tab even from the insert mode
imap <C-H> <Esc>:tabprev<CR>

" ,p to enable 'paste' mode, where vim disable autoindent and other shenanigans and allows you to paste text as-is
nnoremap ,p :set invpaste paste?<CR>
" ,c to enable homebrew 'copy' mode, where vim removes any extra columns on the left, allowing you to just copy text with your mouse
nnoremap ,c :setlocal invnumber<CR>:call FoldColumnToggle()<CR>
" a helper function for the copy mode
function! FoldColumnToggle()
    if &foldcolumn
        setlocal foldcolumn=0
        NoShowMarks!
    else
        setlocal foldcolumn=1
        DoShowMarks!
    endif
endfunction

" type :RP<Enter> command to see the current file's real path
command RP :!realpath %
" type :SHA<Enter> duting selection to replace selection with your current git commit hash
command -range SHA '<,'>s/\%V.*\%V./\=system('git rev-parse HEAD | tr -d "\n"')/

" enable showmarks plugin, letting you see your vim bookmarks on the left column
autocmd VimEnter * DoShowMarks!

" Return to last edit position when opening files (You want this, it is awesome!)
set updatetime=1
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" Use Xorg clipboard to copy-paste in vim
set clipboard=unnamedplus

" make the last line not jitter up and down by always showing the last action taken
set laststatus=2
" set custom status line in the end:
" reset status line to define it from scratch
set statusline=
" file name
set statusline+=\ %f
" a [+] indicator if the file was modified, but not saved
set statusline+=%m
" /\  /\  on the left  /\  /\
set statusline+=%=
" \/  \/  on the right \/  \/
" slightly highlight data on the right
set statusline+=%#CursorColumn#
" file encoding in square brackets
set statusline+=\ [%{&fileencoding?&fileencoding:&encoding}]
" percentage of file above the cursor
set statusline+=\ %p%%
" line number and column
set statusline+=\ %l:%c
