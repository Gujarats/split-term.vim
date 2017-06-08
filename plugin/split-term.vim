
let s:force_vertical = exists('g:split_term_vertical') ? 1 : 0
let s:map_keys = exists('g:disable_key_mappings') ? 0 : 1

" utilities around neovim's :term

" Remaps specifically a few keys for a better terminal buffer experience.
" - Rebind <Esc> to switch to normal mode
" - Bind Ctrl+hjkl navigate through windows 
fun! s:defineMaps()
  " Allow hitting <Esc> to switch to normal mode
  tnoremap <buffer> <Esc> <C-\><C-n>
endfunction

" Opens up a new buffer, either vertical or horizontal. Count can be used to
" specify the number of visible columns or rows.
fun! s:openBuffer(count, vertical)
  let cmd = a:vertical ? 'vnew' : 'new'
  let cmd = a:count ? a:count . cmd : cmd
  exe cmd
endf

" Opens a new terminal buffer, but instead of doing so using 'enew' (same
" window), it uses :vnew and :new instead. Usually, I want to open a new
" terminal and not replace my current buffer.
fun! s:openTerm(args, count, vertical)
  let params = split(a:args)
  let direction = s:force_vertical ? 1 : a:vertical

  call s:openBuffer(a:count, direction)
  exe 'terminal' a:args
  exe 'startinsert'
  if s:map_keys
    call s:defineMaps()
  endif
endf

command! -count -nargs=* Term call s:openTerm(<q-args>, <count>, 0)
command! -count -nargs=* VTerm call s:openTerm(<q-args>, <count>, 1)
