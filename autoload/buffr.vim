" ==============================================================
" Description:  Vim plugin for easy buffer creation
" Author:       Alexander Skachko <alexander.skachko@gmail.com>
" Homepage:     https://github.com/lucerion/vim-buffr
" Version:      0.1
" Licence:      MIT
" ==============================================================

let s:positions = {
  \ 'top': 'leftabove',
  \ 'bottom': 'rightbelow',
  \ 'left': 'vertical leftabove',
  \ 'right': 'vertical rightbelow',
  \ 'tab': 'tab'
  \ }
let s:default_position = 'leftabove'
let s:buffers_positions = {}

func! buffr#open(name, ...)
  if len(a:000)
    call s:set_buffer_position(a:name, a:1)
  endif
  let l:position = s:get_buffer_position(a:name)

  if bufnr(a:name) == -1
    call s:create_buffer(a:name, l:position)
  else
    call s:open_buffer(a:name, l:position)
  end
endfunc

func! s:create_buffer(name, position)
  call s:build_buffer('new', a:name, a:position)
endfunc

func! s:open_buffer(name, position)
  let l:buffer_number = bufnr(a:name)
  let l:window_number = bufwinnr(l:buffer_number)

  if l:window_number == -1
    call s:build_buffer('split', '+buffer' . l:buffer_number, a:position)
  else
    call s:change_focus(l:window_number)
  endif
endfunc

func! s:build_buffer(action, buffer, position)
  exec a:position . ' ' . a:action . ' ' . a:buffer
endfunc

func! s:change_focus(window_number)
  if winnr() != a:window_number
    exec a:window_number . 'wincmd w'
  endif
endfunc

func! s:set_buffer_position(buffer, position)
  let l:position = get(s:positions, a:position, s:default_position)
  let s:buffers_positions[a:buffer] = l:position
endfunc

func! s:get_buffer_position(buffer)
  return get(s:buffers_positions, a:buffer, s:default_position)
endfunc
