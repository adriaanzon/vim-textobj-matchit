function! s:throw(exception)
  throw 'textobj-matchit: ' . a:exception
endfunction

" TODO: Get skip pattern like matchit's s:ParseSkip() does.
" If b:endwise_syngroups is available, use that because it's more reliable.
function! s:skip() abort
  return exists('b:match_skip')
        \ ? b:match_skip
        \ : 'synIDattr(synID(line("."),col("."),1),"name") =~? "comment\\|string"'
endfunction

function! s:parse_match_words() abort
  return map(
        \   map(
        \     filter(split(b:match_words, '\\\@<!,'), 'v:val =~ ''\w'''),
        \     'split(v:val, ''\\\@<!:'')'
        \   ),
        \   '[v:val[0], v:val[-1:][0]]'
        \ )
endfunction

" Position the cursor to prepare for a searchpair(), and get the necessary
" flags according to the context of the cursor position.
function! s:flags(start, end)
  let cursor_col = getpos('.')[2]
  let end_match_col = match(getline('.'), a:end) + 1

  if end_match_col && end_match_col <= cursor_col
    call cursor('.', end_match_col)
    return 'cnW'
  endif

  let start_match_col = match(getline('.'), a:start) + 1
  if start_match_col >= cursor_col
    call cursor('.', start_match_col)
  endif

  return 'nW'
endfunction

function! s:closest_pair() abort
  if !exists('g:loaded_matchit')
    call s:throw('This plugin requires matchit.vim to be enabled')
  elseif !exists('b:match_words')
    call s:throw('No match found')
  endif

  let candidates = {}

  for [start, end] in s:parse_match_words()
    let [lnum, col] = searchpairpos(start, '', end, s:flags(start, end), s:skip())
    if lnum
      let candidates[lnum] = [0, lnum, col, 0]
    endif
  endfor

  if empty(candidates)
    call s:throw('No match found')
  endif

  let closest = keys(candidates)[0]
  if len(candidates) > 1
    for lnum in keys(candidates)[1:]
      if abs(lnum - line('.')) > closest
        let closest = lnum
      endif
    endfor
  endif

  return candidates[closest]
endfunction

function! s:select(start_adjustment, end_adjustment) abort
  try
    let end_pos = s:closest_pair()
    call setpos('.', end_pos)
    normal %
    let start_pos = getpos('.')

    " Cancel when the cursor doesn't move after invoking matchit
    if start_pos == end_pos
      return 0
    endif

    let start_pos[1] = start_pos[1] + a:start_adjustment
    let end_pos[1] = end_pos[1] + a:end_adjustment

    return ['V', start_pos, end_pos]
  catch /^textobj-matchit: No match found/
    return 0
  endtry
endfunction

function! textobj#matchit#select_a() abort
  return s:select(0, 0)
endfunction

function! textobj#matchit#select_i() abort
  return s:select(1, -1)
endfunction
