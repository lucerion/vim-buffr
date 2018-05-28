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

if !exists('g:buffr_position')
  let g:buffr_position = 'top'
endif

comm! -nargs=? Buffr call buffr#open_or_create_buffer({ 'name': <q-args>, 'position': g:buffr_position })
