set nocompatible              " be iMproved, required
syntax enable
" turn on linenumbers
set number
let mapleader=','
set guifont=Hack:h20
set nobackup
set nowritebackup
set cmdheight=2
filetype off                  " required
set clipboard+=unnamedplus " use system clipboard

set autowrite " save when buffer changed
noremap <c-s> :w<CR> " normal mode: save
inoremap <c-s> <Esc>:w<CR>l " insert mode: escape to normal and save
vnoremap <c-s> <Esc>:w<CR> " visual mode: escape to normal and save
" terminal escape
tnoremap <Esc> <C-\><C-n>
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

"Plugin 'Sirver/ultisnips'
Plugin 'neoclide/coc.nvim', {'branch': 'release'}
" vim outlines from coc
Plugin 'liuchengxu/vista.vim'
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'preservim/nerdtree'
Plugin 'Chiel92/vim-autoformat'
" git markdown table mode
Plugin 'dhruvasagar/vim-table-mode'
" git plugin
Plugin 'tpope/vim-fugitive'
" see registers before using them
Plugin 'junegunn/vim-peekaboo'
" linter
Plugin 'dense-analysis/ale'
" dispatch tasks async
Plugin 'tpope/vim-dispatch'
" auto pair brackets
Plugin 'jiangmiao/auto-pairs'
" buffers as tabs
Plugin 'vim-airline/vim-airline'
" airline themes
Plugin 'vim-airline/vim-airline-themes'
" testing plugin
Plugin 'janko/vim-test'
" semicolon and colon addition to the end of the lines, etc.
Plugin 'lfilho/cosco.vim'
" fuzzy finder
Plugin 'kien/ctrlp.vim'
" markdown preview
Plugin 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
" git changes
Plugin 'airblade/vim-gitgutter'
" vim search in files
Plugin 'mileszs/ack.vim'
" editorconfig support
Plugin 'editorconfig/editorconfig-vim'
" remove unused imports in java
Plugin 'akhaku/vim-java-unused-imports'
" java debugging
Plugin 'idanarye/vim-vebugger'
Plugin 'morhetz/gruvbox'
Plugin 'Shougo/vimproc.vim'
Plugin 'SirVer/ultisnips'
call vundle#end()            " required
filetype plugin indent on    " required

" =====================================================
" Gruvbox theme config
" =====================================================
colorscheme gruvbox

inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ coc#refresh()

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" enter triggers completion on COC
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

let g:UltiSnipsSnippetDirectories=[$HOME.'/.ultisnips']
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
" own commands
" =====================================================
" vim test to run with maven toggles
nnoremap <C-t> :TestFile -DfailIfNoTests=false -am -q<CR>
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

let g:test#custom_transformations = {
            \ 'maven_integration_aware_test': function('MavenTest')
            \ }
let g:test#transformation = 'maven_integration_aware_test'

" vim-test config
let test#strategy = "dispatch"

"open nerdtree automatically
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" close vim when nerdtree is the last window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" nerdtree cd into dir when opening it
let g:NERDTreeChDirMode = 2
"if more than one window and previous buffer was NERDTree, go back to it.
autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" && winnr('$') > 1 | b# | endif
" airline configs
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" ==============================================
" CoC config
" ==============================================
noremap <F3> :exec 'UnusedImportsRemove'<bar>Autoformat<CR>
" format selected buffer
command! -nargs=0 Format :call CocAction('format')<Paste>
" format selected section
xmap <leader>f  <Plug>(coc-format-selected)<CR>
nmap <leader>f  <Plug>(coc-format-selected)<CR>
nmap <silent> [g <Plug>(coc-diagnostic-prev)<CR>
nmap <silent> ]g <Plug>(coc-diagnostic-next)<CR>
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
nmap <silent> gd <Plug>(coc-definition)<CR>
nmap <silent> gy <Plug>(coc-type-definition)<CR>
nmap <silent> gi <Plug>(coc-implementation)<CR>
nmap <silent> gr <Plug>(coc-references)<CR>

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
" cycle through buffers
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>
" ==============================================
" ACK config
" ==============================================
" ACK hotkey
nnoremap <C-F> :Ack<space>
" ==============================================
" ALE config
" ==============================================
let g:ale_linters = {
            \   'javascript': ['eslint'],
            \   'java': ['checkstyle']
            \}
let g:ale_java_checkstyle_config= '/home/tacsiazuma/work/videoportal/build-tools/src/main/resources/checkstyle.xml'

" ==============================================
" CtrlP config
" ==============================================
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.class,*.jar

let g:ctrlp_custom_ignore = {
            \ 'dir': '\v[\/](\.(git|hg|svn)|Pictures|node_modules|Downloads|Movies|Videos|target)$',
            \ 'file': '\v\.(png|gif|jpg|wav|torrent|flv|zip|exe|so|dll|class|jar)$',
            \ 'link': 'some_bad_symbolic_links',
            \ }
let g:ctrlp_max_files=10000
