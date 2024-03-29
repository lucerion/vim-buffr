" ==============================================================
" Description:  Vim plugin for working with buffers
" Author:       Alexander Skachko <alexander.skachko@gmail.com>
" Homepage:     https://github.com/lucerion/vim-buffr
" Version:      2.0.0 (2022-06-21)
" Licence:      BSD-3-Clause
" ==============================================================

if exists('g:loaded_buffr') || &compatible || v:version < 700
  finish
endif
let g:loaded_buffr = 1

comm! -nargs=* Buffr call buffr#open_or_create_buffer(<q-args>, <q-mods>)
