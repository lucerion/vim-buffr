" ==============================================================
" Description:  Vim plugin for working with buffers
" Author:       Alexander Skachko <alexander.skachko@gmail.com>
" Homepage:     https://github.com/lucerion/vim-buffr
" Version:      2.0.0 (2022-06-21)
" Licence:      BSD-3-Clause
" ==============================================================

let s:mods = {}
let s:default_buffer_name = 'buffr'

func! buffr#open_or_create_buffer(buffer_name, mods) abort
  if buffer_exists(a:buffer_name)
    call buffr#open_buffer(a:buffer_name, a:mods)
  else
    call buffr#create_buffer(a:buffer_name, a:mods)
  endif
endfunc

func! buffr#create_buffer(buffer_name, mods) abort
  call s:open_buffer(a:buffer_name, a:mods)
endfunc

func! buffr#open_buffer(buffer_name, mods) abort
  let l:buffer_number = bufnr(a:buffer_name)
  let l:window_number = bufwinnr(l:buffer_number)

  if l:window_number == -1
    let l:buffer_name = '+buffer'.l:buffer_number
    call s:open_buffer(l:buffer_name, a:mods)
  else
    call s:change_focus_to_buffer(l:window_number)
  endif
endfunc

func! s:open_buffer(buffer_name, mods) abort
  let l:buffer_name = empty(a:buffer_name) ? s:default_buffer_name : escape(a:buffer_name, ' ')

  silent exec s:buffer_position(l:buffer_name, a:mods) . ' split ' . l:buffer_name
endfunc

func! s:change_focus_to_buffer(window_number) abort
  if winnr() != a:window_number
    exec a:window_number . 'wincmd w'
  endif
endfunc

func! s:buffer_position(buffer_name, mods) abort
  if !empty(a:mods)
    let s:mods[a:buffer_name] = a:mods
  endif

  return get(s:mods, a:buffer_name, '')
endfunc
