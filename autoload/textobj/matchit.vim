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

function! s:closest_pair() abort
  if !exists('g:loaded_matchit')
    call s:throw('This plugin requires matchit.vim to be enabled')
  elseif !exists('b:match_words')
    call s:throw('No match found')
  endif

  let skip = s:skip()
  let candidates = {}

  for [start, end] in s:parse_match_words()
    let [lnum, col] = searchpairpos(start, '', end, 'nW', skip)
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
    let end = s:closest_pair()
    call setpos('.', end)
    normal %
    let start = getpos('.')
    let start[1] = start[1] + a:start_adjustment
    let end[1] = end[1] + a:end_adjustment

    return ['V', start, end]
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
