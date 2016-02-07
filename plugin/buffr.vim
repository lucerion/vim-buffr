" ==============================================================
" Description:  Vim plugin for easy buffer creation
" Author:       Alexander Skachko <alexander.skachko@gmail.com>
" Homepage:     https://github.com/lucerion/vim-buffr
" Version:      0.1
" Licence:      MIT
" ==============================================================

if exists('g:loaded_buffr') || &compatible || (v:version < 700)
  finish
endif

let s:allowed_arguments = ['-top', '-bottom', '-left', '-right', '-tab']
let s:default_position_argument = '-top'

func! s:autocompletion(A, L, C)
  return s:allowed_arguments
endfunc

func! s:open_buffer(...)
  let l:position_arguments = filter(copy(a:000), 'index(s:allowed_arguments, v:val) >= 0')
  if len(l:position_arguments) > 1
    echo 'Only one position argument is allowed!'
    return
  endif

  let l:name_arguments = filter(copy(a:000), 'index(s:allowed_arguments, v:val) < 0')
  if len(l:name_arguments) == 0
    echo 'Buffer name is required!'
    return
  endif

  let l:name = join(l:name_arguments)
  let l:position = substitute(get(l:position_arguments, -1, '-top'), '-', '', 'g')

  call buffr#open_or_create_buffer(l:name, l:position)
endfunc

comm! -nargs=+ -complete=customlist,s:autocompletion Buffr
  \ call s:open_buffer(<f-args>)

let g:loaded_buffr = 1
