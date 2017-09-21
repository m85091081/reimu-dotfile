"restore
    autocmd BufReadPost *
                \ if line("'\"") > 1 && line("'\"") <= line("$") |
                \   execute "normal! g`\"" |
                \ endif

    autocmd BufReadPre *
                \   if getfsize(expand("%")) > 10000000 |
                \   syntax off |
                \   endif
    
    au BufEnter * call MyLastWindow()
    function! MyLastWindow()
        " if the window is quickfix/locationlist go on
        if &buftype=='quickfix' || &buftype == 'locationlist'
            " if this window is last on screen quit without warning
            if winbufnr(2) == -1
                quit!
            endif
        endif
    endfunction
"for plug
set nocompatible 
filetype off   
call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'Valloric/YouCompleteMe'
Plug 'ervandew/supertab'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'scrooloose/nerdtree'
Plug 'Raimondi/delimitMate'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'vim-airline/vim-airline-themes'
Plug 'w0rp/ale'
call plug#end()

"UI_Setting
set tabstop=4
set shiftwidth=4
set expandtab
set history=1000
set backspace=2
set laststatus=2
set number
set display=lastline           " Show as much as possible of the last line
set relativenumber
"Vim_Encoding_Setting
set encoding=utf-8  
set termencoding=utf-8

"Vim_Env_Setting
set autowrite      " Automatically write a file when leaving a modified buffer
set ignorecase     " Case sensitive search
set smartcase      " Case sensitive when uc present
let s:save_cpo = &cpo
set cpo&vim
set undofile             " Persistent undo
set undolevels=1000      " Maximum number of changes that can be undone
set undoreload=10000     " Maximum number lines to save for undo on a buffer reload
set ttyfast                    " Faster redrawing
set wildmenu                   " Show list instead of just completing
set autoindent                 " Indent at the same level of the previous line
set autoread                   " Automatically read a file changed outside of vim
set history=10000              " Maximum history record
set showmatch
set cursorline
set cursorcolumn
set wildmode=list:longest,full
set wildignore+=*swp,*.class,*.pyc,*.png,*.jpg,*.gif,*.zip
set wildignore+=*/tmp/*,*.o,*.obj,*.so     " Unix
set backup
filetype plugin indent on
syntax on

"Vim_Colorscheme (Use molokai)
colorscheme molokai
set t_Co=256
hi Normal  ctermfg=252 ctermbg=none
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme = 'powerlineish'
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#syntastic#enabled = 1
let g:airline_section_a = airline#section#create([''])
let g:airline_section_b = airline#section#create(['ReimuVim'])
let g:airline_section_c = airline#section#create(['%f','(','filetype',')'])
let g:airline_section_x = airline#section#create(['ffenc'])
let g:airline_section_y = airline#section#create([''])
let g:airline_section_z = airline#section#create_right(['Line:%l','Row:%c'])
set nofoldenable

"YCM
let g:ycm_complete_in_comments=1
let g:ycm_complete_in_strings =1
let g:ycm_use_ultisnips_completer = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_collect_identifiers_from_tags_files=1
inoremap <leader>; <C-x><C-o>
set completeopt-=preview
let g:ycm_min_num_of_chars_for_completion=1
let g:ycm_cache_omnifunc=0
let g:ycm_seed_identifiers_with_syntax=1
 let g:ycm_key_invoke_completion=''
let g:ycm_global_ycm_extra_conf = "~/.vim/plugged/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py"

"Snip
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

"NERD
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

let g:ale_linters = {
			\   'sh' : ['shellcheck'],
			\   'vim' : ['vint'],
    		\   'html' : ['tidy'],
			\   'python' : ['pylint'],
			\   'markdown' : ['mdl'],
			\   'javascript' : ['eslint'],
			\}

let g:ale_sign_error = '•'
let g:ale_sign_warning = '•'
let g:ale_echo_msg_format = '[#%linter%#] %s [%severity%]'
let g:ale_echo_msg_error_str = '✹ Error'
let g:ale_echo_msg_warning_str = '⚠ Warning'
let g:ale_statusline_format = ['Ⓔ •%d ', 'Ⓦ •%d ', ' ✔ •OK ']
