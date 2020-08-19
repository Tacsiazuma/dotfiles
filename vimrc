set nocompatible              " be 
syntax enable
" turn on linenumbers
set number
set ttimeout
set ttimeoutlen=100
set relativenumber
let mapleader=' '
set guifont=Hack:h20
set nobackup
set colorcolumn=121
set noswapfile
set nowritebackup
set cmdheight=2
set hidden
filetype off                  " required
set clipboard+=unnamedplus " use system clipboard
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300
nnoremap : .
nnoremap . :
set autowrite " save when buffer changed
noremap <c-s> :w<CR> " normal mode: save
inoremap <c-s> <Esc>:w<CR>l " insert mode: escape to normal and save
vnoremap <c-s> <Esc>:w<CR> " visual mode: escape to normal and save
" movement between panes
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>l :wincmd l<CR>
" terminal escape
tnoremap <expr> <Esc> (&filetype == "fzf") ? "<Esc>" : "<c-\><c-n>"
" spell checking hungarian
augroup markdownSpell
    autocmd!
    autocmd FileType markdown setlocal spell spelllang=hu
    autocmd BufRead,BufNewFile *.md setlocal spell spelllang=hu
augroup END
" to convert 4 spaces to tabs and vice-versa
set tabstop=4
set shiftwidth=4
set expandtab
" showing tabs
exec "set listchars=tab:\uBB\uBB,trail:\uB7,nbsp:~"
set list
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'neoclide/coc.nvim', {'branch': 'release'}
" vim outlines from coc
Plugin 'liuchengxu/vista.vim'
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
" file tree
Plugin 'preservim/nerdtree'
" java debugging
Plugin 'brookhong/jdb.vim'
" git plugin
Plugin 'tpope/vim-fugitive'
" git merge plugin
Plugin 'idanarye/vim-merginal'
" see registers before using them
Plugin 'junegunn/vim-peekaboo'
" linter
Plugin 'dense-analysis/ale'
" dispatch tasks async
Plugin 'tpope/vim-dispatch'
" auto pair brackets
Plugin 'jiangmiao/auto-pairs'
" close buffer without window
Plugin 'moll/vim-bbye'
" buffers as tabs
Plugin 'vim-airline/vim-airline'
" airline themes
Plugin 'vim-airline/vim-airline-themes'
" horizontal jump helper
Plugin 'unblevable/quick-scope'
" testing plugin
Plugin 'vim-test/vim-test'
" semicolon and colon addition to the end of the lines, etc.
Plugin 'lfilho/cosco.vim'
Plugin 'tpope/vim-commentary'
" vim practice plugin
Plugin 'ThePrimeagen/vim-be-good'
" fuzzy finder
"Plugin 'kien/ctrlp.vim'
" markdown preview
Plugin 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
" git changes
Plugin 'airblade/vim-gitgutter'
" java stuff
Plugin 'tacsiazuma/easyjava.vim'
Plugin 'morhetz/gruvbox'
Plugin 'Shougo/vimproc.vim'
" vim leader key mapping helper
Plugin 'liuchengxu/vim-which-key'
" undo local changes
Plugin 'mbbill/undotree'
" FZF integration
Plugin 'junegunn/fzf', { 'do': './install --bin' }
Plugin 'junegunn/fzf.vim'
" if you want ultisnips to be synced by dotfiles, create a symlink from
" .ultisnips to .vim/UltiSnips because we cant read outside the .vim directory
"Plugin 'SirVer/ultisnips'
call vundle#end()            " required
filetype plugin indent on    " required

" =====================================================
" Gruvbox theme config
" =====================================================
colorscheme gruvbox

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" enter triggers completion on COC
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" =====================================================
" Vista config
" =====================================================
" The default icons can't be suitable for all the filetypes, you can extend it as you wish.
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
let g:vista#renderer#icons = {
            \   "function": "\uf794",
            \   "variable": "\uf71b",
            \  }
let g:vista#renderer#enable_icon = 1
let g:vista_default_executive = 'coc'
" =====================================================
" vim test to run with maven toggles
nnoremap <C-t> :TestFile -DfailIfNoTests=false -am -Dskip.npm -Dpmd.skip=true -Dcheckstyle.skip=true -Pnofrontend<CR>
" buftabline helpers
set hidden

function! MavenTest(cmd) abort
    let var=system('wc -l',join(getline(1,'$'),"\n"))
    if match(var, "IntegrationTest") > 0
        return 'echo "Integration test, must be run from suite"'
    else
        return a:cmd
    endif
endfunction

" ==============================================
" nerdtree config
" ==============================================
" nerdree cd to directory opened automatically
let g:NERDTreeChDirMode = 2
"open nerdtree automatically
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

nnoremap <leader>t :NERDTreeFind<CR>
nnoremap <leader>n :NERDTreeToggle<CR>
" ==============================================
" undotree   config
" ==============================================
nnoremap <leader>u :UndotreeToggle<CR>
" ==============================================
" airline config
" ==============================================
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
" ==============================================
" CoC config
" ==============================================
" format selected buffer
command! -nargs=0 Format :call CocAction('format')<Paste>
" format selected section
"xmap <leader>f  <Plug>(coc-format-selected)<CR>
nmap <leader>rn  <Plug>(coc-rename)<CR>
nmap <leader>f  <Plug>(coc-format)<CR>
" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)<CR>
nmap <leader>a  <Plug>(coc-codeaction-selected)<CR>
" fix current position
nmap <leader>qf  <Plug>(coc-fix-current)
" organizeImport
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
" highlight selection on cursorhold
autocmd CursorHold * silent call CocActionAsync('highlight')
" rename symbol shorthand
nmap <leader>rn <Plug>(coc-rename)
" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-type-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Show commands.
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    else
        call CocAction('doHover')
    endif
endfunction
" ==============================================
" Cosco config
" ==============================================
autocmd FileType javascript,css,java nmap <silent> <Leader>, <Plug>(cosco-commaOrSemiColon)
" cycle through buffers
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>
" ==============================================
" BBye config
" ==============================================
nnoremap <Leader>q :Bdelete<CR>
" ==============================================
" vim which key config
" ==============================================
nnoremap <silent> <leader> :silent WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :silent <c-u> :silent WhichKeyVisual '<Space>'<CR>
" Create map to add keys to
let g:which_key_map =  {}
" Define a separator
let g:which_key_sep = '→'
" set timeoutlen=100


" Not a fan of floating windows for this
let g:which_key_use_floating_win = 0

" Change the colors if you want
highlight default link WhichKey          Operator
highlight default link WhichKeySeperator DiffAdded
highlight default link WhichKeyGroup     Identifier
highlight default link WhichKeyDesc      Function

" Hide status line
autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 noshowmode ruler
" ==============================================
" Auto pairs config
" ==============================================
let g:AutoPairsMapSpace = 0
" ==============================================
" FZF config
" ==============================================
nnoremap <silent> <expr> <C-p> (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":Files\<cr>"
nnoremap <leader>b :Buffers<CR>
nnoremap <C-f> :RG<CR>
" Border color
let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5, 'highlight': 'Todo', 'border': 'sharp' } }

let $FZF_DEFAULT_OPTS = '--layout=reverse --info=inline'
let $FZF_DEFAULT_COMMAND="rg --files --hidden"


" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
" Ripgrep advanced
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

" Git grep
command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)
" ==============================================
" ALE config
" ==============================================
let g:ale_linters = {
            \   'javascript': ['eslint'],
            \   'java': ['checkstyle']
            \}
let g:ale_java_checkstyle_config= '/home/tacsiazuma/work/videoportal/build-tools/src/main/resources/checkstyle.xml'

" ==============================================
" vebugger config
" ==============================================
let g:vebugger_leader='<leader>d'
" ==============================================
" CtrlP config
" ==============================================
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.class,*.jar

let g:ctrlp_custom_ignore = {
            \ 'dir': '\v[\/](\.(git|hg|svn)|Pictures|node_modules|Downloads|Movies|Videos|target)$',
            \ 'file': '\v\.(png|gif|jpg|wav|torrent|flv|zip|exe|so|dll|class|jar)$',
            \ 'link': 'some_bad_symbolic_links'
            \}
let g:ctrlp_max_files=10000
