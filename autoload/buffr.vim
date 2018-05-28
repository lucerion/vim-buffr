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
  \ 'left':         'vertical leftabove',
  \ 'right':        'vertical rightbelow',
  \ 'top-full':     'topleft split',
  \ 'bottom-full':  'botright split',
  \ 'left-full':    'vertical topleft split',
  \ 'right-full':   'vertical botright split'
  \ }
let s:default_name = 'buffr'

func! buffr#positions()
  return keys(s:positions)
endfunc

func! buffr#open_or_create_buffer(...) abort
  if buffer_exists(s:name(a:000))
    call buffr#open_buffer(s:params(a:000))
  else
    call buffr#create_buffer(s:params(a:000))
  endif
endfunc

func! buffr#create_buffer(...) abort
  call s:open_buffer(s:position(a:000), 'new', s:name(a:000))
endfunc

func! buffr#open_buffer(...) abort
  let l:buffer_number = bufnr(s:name(a:000))
  let l:window_number = bufwinnr(l:buffer_number)

  if l:window_number == -1
    call s:open_buffer(s:position(a:000), 'split', '+buffer'.l:buffer_number)
  else
    call s:change_focus(l:window_number)
  endif
endfunc

func! s:open_buffer(position, action, name) abort
  let l:command = a:position . ' ' . a:action

  if a:name != s:default_name
    let l:command .= ' ' . escape(a:name, ' ')
  endif

  silent exec l:command
endfunc

func! s:change_focus(window_number) abort
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

func! s:position(args) abort
  let l:name = s:name(a:args)
  let l:current_position = get(s:params(a:args), 'position', '')

  let l:split = get(s:positions, l:current_position, '')
  if len(l:current_position) && len(l:split)
    let s:buffers[l:name] = l:split
    return l:split
  endif

  let l:previous_split = get(s:buffers, l:name, '')
  if len(l:previous_split)
    return l:previous_split
  endif

  return s:positions.top
endfunc
