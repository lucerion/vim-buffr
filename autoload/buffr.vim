" ==============================================================
" Description:  Vim plugin for working with buffers
" Author:       Alexander Skachko <alexander.skachko@gmail.com>
" Homepage:     https://github.com/lucerion/vim-buffr
" Version:      1.0.0 (2017-09-03)
" Licence:      BSD-3-Clause
" ==============================================================

let s:buffers = {}
let s:positions = {
  \ 'tab':          'tab',
  \ 'top':          'leftabove',
  \ 'bottom':       'rightbelow',
  \ 'left':         'leftabove vertical',
  \ 'right':        'rightbelow vertical',
  \ 'top-full':     'topleft',
  \ 'bottom-full':  'botright',
  \ 'left-full':    'topleft vertical',
  \ 'right-full':   'botright vertical'
  \ }
let s:default_name = 'buffr'

func! buffr#positions()
  return keys(s:positions)
endfunc

func! buffr#open_or_create_buffer(...) abort
  let l:buffer_options = s:buffer_options(a:000)

  if buffer_exists(s:buffer_name(a:000))
    call buffr#open_buffer(l:buffer_options)
  else
    call buffr#create_buffer(l:buffer_options)
  endif
endfunc

func! buffr#create_buffer(...) abort
  let l:buffer_position = s:buffer_position(a:000)
  let l:buffer_name = s:buffer_name(a:000)
  let l:action = 'new'

  call s:open_buffer(l:buffer_position, l:action, l:buffer_name)
endfunc

func! buffr#open_buffer(...) abort
  let l:buffer_number = bufnr(s:buffer_name(a:000))
  let l:window_number = bufwinnr(l:buffer_number)

  if l:window_number == -1
    let l:buffer_position = s:buffer_position(a:000)
    let l:buffer_name = '+buffer'.l:buffer_number
    let l:action = 'split'

    call s:open_buffer(l:buffer_position, l:action, l:buffer_name)
  else
    call s:change_focus_to_buffer(l:window_number)
  endif
endfunc

func! s:open_buffer(position, action, name) abort
  let l:command = a:position . ' ' . a:action

  if a:name != s:default_name
    let l:command .= ' ' . escape(a:name, ' ')
  endif

  silent exec l:command
endfunc

func! s:change_focus_to_buffer(window_number) abort
  if winnr() != a:window_number
    exec a:window_number . 'wincmd w'
  endif
endfunc

func! s:buffer_options(args)
  return get(a:args, 0, {})
endfunc

func! s:buffer_name(args)
  return get(s:buffer_options(a:args), 'name', s:default_name)
endfunc

func! s:buffer_position(args) abort
  let l:buffer_name = s:buffer_name(a:args)
  let l:current_position = get(s:buffer_options(a:args), 'position', '')

  let l:split = get(s:positions, l:current_position, '')
  if len(l:current_position) && len(l:split)
    let s:buffers[l:buffer_name] = l:split
    return l:split
  endif

  let l:previous_split = get(s:buffers, l:buffer_name, '')
  if len(l:previous_split)
    return l:previous_split
  endif

  return s:positions.top
endfunc
