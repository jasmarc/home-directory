syntax on
filetype on
filetype plugin on

set nocompatible        " Use Vim defaults (much better!)
set nobackup            " I can back up my own files, thank you very much
set noswapfile
set bs=2                " Allow backspacing over everything in insert mode
set backspace=indent,eol,start
set ai                  " Always set auto-indenting on
set viminfo='20,\"50    " read/write a .viminfo file -- limit to only 50
set history=50          " keep 50 lines of command history
set ruler               " Show the cursor position all the time
set ts=4                " 4 space wide tabs
set sw=4                
set softtabstop=4       "makes backspacing over spaced out tabs work real nice
set expandtab           "expand tabs to spaces
set ignorecase          
set background=dark     "awesome for terminals with crappy colors (putty!)
set tagstack            "lets you push and pop your jumps with ctrl+]
set pastetoggle=<C-p>   "when you're pasting stuff this keeps it from getting
                        "all whacked out with indentation
set foldmethod=manual   "enable code folding"
set list
set listchars=trail:█,nbsp:·,tab:»»
