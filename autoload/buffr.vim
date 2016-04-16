" ==============================================================
" Description:  Vim plugin and functions for working with buffers
" Author:       Alexander Skachko <alexander.skachko@gmail.com>
" Homepage:     https://github.com/lucerion/vim-buffr
" Version:      0.3
" Licence:      BSD-3-Clause
" ==============================================================

let s:buffers = {}
let s:positions = {
  \ 'top': 'leftabove',
  \ 'bottom': 'rightbelow',
  \ 'left': 'vertical leftabove',
  \ 'right': 'vertical rightbelow',
  \ 'tab': 'tab'
  \ }
let s:default_name = 'buffr'
let s:default_position = 'leftabove'

func! buffr#open_or_create_buffer(...)
  let l:name = s:name(a:000)

  if buffer_exists(l:name)
    call buffr#open_buffer(s:params(a:000))
  else
    call buffr#create_buffer(s:params(a:000))
  endif
endfunc

func! buffr#create_buffer(...)
  let l:name = s:name(a:000)
  let l:position = s:position(a:000)

  call s:open_buffer('new', l:name, l:position)
endfunc

func! buffr#open_buffer(...)
  let l:name = s:name(a:000)
  let l:position = s:position(a:000)

  let l:buffer_number = bufnr(l:name)
  let l:window_number = bufwinnr(l:buffer_number)

  if l:window_number == -1
    call s:open_buffer('split', '+buffer' . l:buffer_number, l:position)
  else
    call s:change_focus(l:window_number)
  endif
endfunc

func! s:open_buffer(action, name, position)
  let l:command = a:position . ' ' . a:action

  if a:name != s:default_name
    let l:command .= ' ' . escape(a:name, ' ')
  endif

  silent exec l:command
endfunc

func! s:change_focus(window_number)
  if winnr() != a:window_number
    exec a:window_number . 'wincmd w'
  endif
endfunc

func! s:params(args)
  return get(a:args, 0, {})
endfunc

func! s:name(args)
  return get(s:params(a:args), 'name', s:default_name)
endfunc

func! s:position(args)
  let l:name = s:name(a:args)
  let l:position = get(s:params(a:args), 'position', '')

  let l:current_position = get(s:buffers, l:name, '')
  if !len(l:position) && len(l:current_position)
    return l:current_position
  endif

  let l:new_position = get(s:positions, l:position, '')
  if len(l:new_position)
    let s:buffers[l:name] = l:new_position
    return l:new_position
  endif

  if len(l:current_position)
    return l:current_position
  endif

  return get(s:positions, g:buffr_default_position, s:default_position)
endfunc
