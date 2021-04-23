let mapleader=" "

let g:ale_diable_lsp = 1
let g:godot_executable = '/mnt/d/dev/game/godot/bin/godot.windows.opt.tools.64.exe'
call plug#begin('/home/n4tus/.local/share/nvim/site/plugins')
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'itchyny/lightline.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': {-> coc#util#install()}}
Plug 'dense-analysis/ale'
Plug 'dag/vim-fish'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'cespare/vim-toml'
Plug 'habamax/vim-godot'
Plug 'LucHermitte/lh-vim-lib'
Plug 'skywind3000/asyncrun.vim'
Plug 'sbdchd/neoformat'
" Plug 'posva/vim-vue'
"Plug 'machakann/vim-highlightedyank'
"Plug 'andymass/vim-matchup'
"Plug 'joshdick/onedark.vim'
"Plug 'iCyMind/NeoSolarized'

"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'
" Fuzzy finder
"Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-gitgutter'
" Plug 'jceb/emmet.snippets'

" Plug 'honza/vim-snippets'
call plug#end()
set relativenumber	
set number
syntax on
filetype plugin indent on
set showcmd
set tabstop=4
set softtabstop=4
set shiftwidth=4
set copyindent
set autoindent
set expandtab
set shell=sh
set nohlsearch
vnoremap p "_dP
nnoremap Y y$
nnoremap K kJ


nnoremap <leader>p "*p
vnoremap <leader>p "_d"*P
nnoremap <leader>yy "*yy
nnoremap <leader>Y "*y$
nnoremap <M-Down> :m .+1<CR> 
nnoremap <M-Up> :m .-2<CR> 
nnoremap <C-S> :t .<CR>
vnoremap <leader>y "*y

vnoremap > >gv
vnoremap < <gv

let g:ale_fixers = {
            \ 'javascript': ['prettier'],
            \ 'css': ['prettier'],
            \ 'vue': ['prettier'],
            \ 'typescript': ['prettier'],
            \}
let g:ale_linters = {'rust': ['analyzer']}
let g:ale_lint_on_save = 1
let g:ale_linters_explicit = 1
let g:ale_sign_column_always = 1
call ale#linter#Define("gdscript", {
            \ 'name': 'godot',
            \ 'lsp': 'socket',
            \ 'address': '192.168.178.23:8081',
            \ 'project_root': 'project.godot',
            \})

nnoremap <leader>nn :NERDTreeFocusToggle<CR>
nnoremap <leader>nf :NERDTreeTabsFind<CR>

augroup stuff
    autocmd!
    autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

    " Highlight the symbol and its references when holding the cursor.
    autocmd CursorHold * silent call CocActionAsync('highlight')
augroup END

let g:NERDTreeGitStatusUseNerdFonts = 1
let g:NERDTreeGitStatusShowIgnored = 1
let g:NERDTreeGitStatusConcealBrackets = 1
let g:NERDTreeGitStatusShowClean = 1

nnoremap <C-F> :GFiles .<CR>
nnoremap <silent><S-F> :ALEFix <CR>
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <leader>rn <Plug>(coc-rename)
nmap <silent> gf <Plug>(coc-fix-current)

nnoremap zuzu :CocAction<CR>
inoremap <silent><expr> <C-Space> coc#refresh()


" Use K to show documentation in preview window.
nnoremap <silent> <C-Q> :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction



" alt + / to toggle comment
augroup comment_type_detection
    autocmd!
    autocmd BufRead *.vim let b:comment_type = '" '
    autocmd BufRead *.rs,*.java,*.go,*.js,*.ts,*.vue let b:comment_type = '// '
    autocmd BufRead *.py,*.gd let b:comment_type = '# '
    autocmd BufRead *.html let b:comment_type = "<!-- " | let b:comment_type_end = ' -->'

    autocmd BufRead *.gd set ff=dos
augroup end

" augroup format_on_save
"     autocmd!
"     autocmd BufWrite *.vue,*.ts,*.js :ALEFix
" augroup end

function! GetCommentType()
    if exists('b:comment_type')
        let b = b:comment_type
    else
        let b = ""
    endif
    if exists('b:comment_type_end')
        let e = b:comment_type_end
    else
        let e = ""
    endif
    return [b, e]
endfunction

function! MatchLine(line)
    let [b, e] = GetCommentType()
    let pattern = "^\\s*" . b . ".*" . e . "\\s*$"
    return a:line =~# pattern
endfunction

function! CommentLine()
    let [b, e] = GetCommentType()
    call setline('.', b . getline('.') . e)
endfunction

function! RemoveExistingComment(line, b, e)
    let b_idx = stridx(a:line, a:b)
    let b_len = strlen(a:b)
    let len = strlen(a:line)
    if a:e ==# ""
        call setline('.', a:line[b_idx+b_len:])
    else
        let e_idx = strridx(a:line, a:e)
        call setline('.', a:line[b_idx+b_len:e_idx-1])
    endif
endfunction

function! ToggleComment()
    let line = getline('.')
    let [b, e] = GetCommentType()
    if MatchLine(line)
        call RemoveExistingComment(line, b, e)
    else
        call setline('.', b . line . e)
    endif
endfunction

function! UndoComment()
    let line = getline('.')
    if MatchLine(line)
        let [b, e] = GetCommentType()
        call RemoveExistingComment(line, b, e)
    endif
endfunction

nnoremap <silent> <M-/> :call ToggleComment()<CR>j
vnoremap <silent> <M-/> :call ToggleComment()<CR>gv
nnoremap <silent> <M-*> :call CommentLine()<CR>j
vnoremap <silent> <M-*> :call CommentLine()<CR>gv
nnoremap <silent> <M--> :call UndoComment()<CR>j
vnoremap <silent> <M--> :call UndoComment()<CR>gv


if has('nvim-0.4.0') || has('patch-8.2.0750')
    inoremap <silent><nowait><expr> <C-Down> coc#float#has_scroll() ? "\<C-R>=coc#float#scroll(1, 2)<CR>" : "\<C-Down>"
    inoremap <silent><nowait><expr> <C-Up> coc#float#has_scroll() ? "\<C-R>=coc#float#scroll(0, 2)<CR>" : "\<C-Up>"
    nnoremap <silent><nowait><expr> <C-Down> coc#float#has_scroll() ? coc#float#scroll(1, 2) : "\<C-Down>"
    nnoremap <silent><nowait><expr> <C-Up> coc#float#has_scroll() ? coc#float#scroll(0, 2) : "\<C-Up>"
endif

" augroup views_storage
"     autocmd!
"     autocmd BufWinLeave *.rs,*.java,*.go,*.js,*.ts mkview
"     autocmd BufWinEnter *.rs,*.java,*.go,*.js,*.ts silent loadview
" augroup END

onoremap ip :<c-u>normal! f(vi(<cr>

highlight CocFloating ctermbg=235
highlight Pmenu ctermfg=white ctermbg=238
highlight PmenuSel ctermfg=yellow

function! GdSelect()
    let f = coc#_select_confirm()
    let y= "\<ESC>a"
    return f.y
endfunction

" inoremap <expr><silent> <CR> pumvisible() ? GdSelect() : "\<CR>"

function! OpenFileInBuffer(file)
    let cwd = getcwd() . "/"
    if a:file =~# "^" . cwd . ".*$"
        let buf_name = a:file[strlen(cwd):]
    else
        let buf_name = a:file
    endif
	let buf_nr = bufnr(buf_name)
	let win_nr = win_findbuf(buf_nr)
    if empty(win_nr)
	    exe "tabedit " . a:file
    else
        call win_gotoid(win_nr[0])
    endif
endfunction

function! s:RecieveGodotCmd(id, data, event) dict
    let msg = "/mnt/d" . join(a:data, "\n")[2:-2]
    call OpenFileInBuffer(msg)
endfunction
" let godot_chan_id = jobstart(['/mnt/d/dev/rust/godot_opener/target/release/godot_opener.exe'], {'on_stdout': function('s:RecieveGodotCmd')})
"

function! GetCurrentFileEnding()
    let file = bufname("%")
    let last_dot_pos = strridx(file, ".")
    if last_dot_pos ==# -1
        throw "no file ending found on path: " . file
    endif
    return [file[last_dot_pos:], last_dot_pos]
endfunction

function! SwitchAngular(ng_type)
    let [ending, last_dot_pos] = GetCurrentFileEnding()
    echom file
    if a:ng_type ==# 0 && ending !=# ".ts"
        call OpenFileInBuffer(file[:last_dot_pos] . "ts")
    elseif a:ng_type ==# 1 && ending !=# ".html"
        call OpenFileInBuffer(file[:last_dot_pos] . "html")
    elseif a:ng_type ==# 2 && ending !=# ".scss"
        call OpenFileInBuffer(file[:last_dot_pos] . "scss")
    endif
endfunction

function! NgOpenComponent()
    let [ending, ldp] = GetCurrentFileEnding()
    let component = bufname("%")[:ldp]
    let html = component . "html"
    let style = component . "scss"
    exec "rightbelow vsplit " . html
    exec "rightbelow split " . style
    call OpenFileInBuffer(component . "ts")
endfunction

function! NgGenerateComponent()
    call inputsave()
    let name = input("Enter component name: ")
    call inputrestore()
    call system("ng g c " . name)
endfunction

nnoremap <leader>ngt :call SwitchAngular(0)<CR>
nnoremap <leader>ngh :call SwitchAngular(1)<CR>
nnoremap <leader>ngs :call SwitchAngular(2)<CR>
nnoremap <leader>ngo :call NgOpenComponent()<CR>
" nnoremap <leader>nggc :call NgGenerateComponent()<CR>



