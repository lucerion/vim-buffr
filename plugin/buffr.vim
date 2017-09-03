" ==============================================================
" Description:  Vim plugin for working with buffers
" Author:       Alexander Skachko <alexander.skachko@gmail.com>
" Homepage:     https://github.com/lucerion/vim-buffr
" Version:      1.0.0 (2017-09-03)
" Licence:      BSD-3-Clause
" ==============================================================

if exists('g:loaded_buffr') || &compatible || v:version < 700
  finish
endif
let g:loaded_buffr = 1

if !exists('g:buffr_default_position')
  let g:buffr_default_position = 'top'
endif

let s:allowed_args = ['-top', '-bottom', '-left', '-right', '-tab']

func! s:autocompletion(A, L, C)
  return s:allowed_args
endfunc

func! s:open_buffer(...)
  let l:name_args_filter = 'index(s:allowed_args, v:val) < 0'
  let l:name = join(filter(copy(a:000), l:name_args_filter))
  if len(l:name)
    let l:args = { 'name': l:name }
  endif

  let l:position_args_filter = 'index(s:allowed_args, v:val) >= 0'
  let l:position = get(filter(copy(a:000), l:position_args_filter), -1)
  let l:args = { 'position': substitute(l:position, '-', '', 'g') }

  call buffr#open_or_create_buffer(l:args)
endfunc

comm! -nargs=* -complete=customlist,s:autocompletion Buffr call s:open_buffer(<f-args>)
