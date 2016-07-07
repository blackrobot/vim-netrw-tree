" Make netrw open in a slim side window, mapped to <leader>n like the vim
" NerdTree plugin.

" If already loaded, bail out
if exists('g:loaded_netrwtree')
  finish
endif

let g:loaded_netrwtree = 1

command!
  \ -nargs=* -bar -bang -complete=dir
  \ Lexplore call netrw#Lexplore(<q-args>, <bang>0)

function! Lexplore(dir, right)
  if exists('t:netrw_lexbufnr')
    " close down netrw explorer window
    let lexwinnr = bufwinnr(t:netrw_lexbufnr)

    if lexwinnr != -1
      let curwin = winnr()
      execute lexwinnr . "wincmd w"
      close
      execute curwin . "wincmd w"
    endif

    unlet t:netrw_lexbufnr
  else
    " open netrw explorer window in the dir of current file
    " (even on remote files)
    let path = substitute(
        \ exists("b:netrw_curdir") ? b:netrw_curdir : expand("%:p"),
        \ '^\(.*[/\\]\)[^/\\]*$',
        \ '\1',
        \ 'e'
    \ )

    execute (a:right ? "botright" : "topleft") . " vertical "
      \ . (g:netrw_winsize > 0 ?
             \ g:netrw_winsize * winwidth(0) / 100 : -g:netrw_winsize)
      \ . " new"

    if a:dir != ""
      execute "Explore " . a:dir
    else
      execute "Explore " . path
    endif

    setlocal winfixwidth
    let t:netrw_lexbufnr = bufnr("%")
  endif
endfun

" Mapped to <leader>n
map <silent> <leader>n :Lexplore<CR>

" absolute width of netrw window
let g:netrw_winsize = -28

" do not display info on the top of window
let g:netrw_banner = 0

" tree-view
let g:netrw_liststyle = 3

" sort is affecting only: directories on the top, files below
let g:netrw_sort_sequence = '[\/]$,*'

" use the previous window to open file
let g:netrw_browse_split = 4
