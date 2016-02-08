" ==============================================================
" Description:  Vim plugin for easy buffer creation
" Author:       Alexander Skachko <alexander.skachko@gmail.com>
" Homepage:     https://github.com/lucerion/vim-buffr
" Version:      0.2
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

func! buffr#open_or_create_buffer(name, ...)
  let l:position = s:position(a:name, a:000)

  if buffer_exists(a:name)
    call buffr#open_buffer(a:name, l:position)
  else
    call buffr#create_buffer(a:name, l:position)
  end
endfunc

func! buffr#create_buffer(name, ...)
  let l:position = s:position(a:name, a:000)
  call s:open_buffer('new', a:name, l:position)
endfunc

func! buffr#open_buffer(name, ...)
  if !buffer_exists(a:name)
    return
  end

  let l:position = s:position(a:name, a:000)
  let l:buffer_number = bufnr(a:name)
  let l:window_number = bufwinnr(l:buffer_number)

  if l:window_number == -1
    call s:open_buffer('split', '+buffer' . l:buffer_number, l:position)
  else
    call s:change_focus(l:window_number)
  endif
endfunc

func! s:open_buffer(action, name, position)
  silent exec a:position . ' ' . a:action . ' ' . escape(a:name, ' ')
endfunc

func! s:change_focus(window_number)
  if winnr() != a:window_number
    exec a:window_number . 'wincmd w'
  endif
endfunc

func! s:position(name, position)
  if len(a:position) && has_key(s:positions, a:position[0])
    let s:buffers_positions[a:name] = get(s:positions, a:position[0])
  endif
  return get(s:buffers_positions, a:name, s:default_position)
endfunc
