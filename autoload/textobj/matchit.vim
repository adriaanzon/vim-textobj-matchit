" TODO: Get skip pattern like matchit's s:ParseSkip() does.
" If b:endwise_syngroups is available, use that because it's more reliable.
function! s:skip() abort
  return exists('b:match_skip')
        \ ? b:match_skip
        \ : 'synIDattr(synID(line("."),col("."),1),"name") =~? "comment\\|string"'
endfunction

function! s:closest_pair() abort
  if !exists('g:loaded_matchit')
    throw 'This plugin requires matchit.vim to be enabled'
  endif

  let skip = s:skip()
  let candidates = {}

  for pairs in map(filter(split(b:match_words, ','), 'v:val =~ "\\w"'), 'split(v:val, ":")')
    let [lnum, col] = searchpairpos(pairs[0], '', pairs[-1:][0], 'nW', skip)
    if lnum
      let candidates[lnum] = [0, lnum, col, 0]
    endif
  endfor

  if empty('candidates')
    return 0
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

function! textobj#matchit#select_a() abort
  let end = s:closest_pair()

  if type(end) == v:t_list
    call setpos('.', end)

    normal %
    let start = getpos('.')

    return ['V', start, end]
  else
    return 0
  endif
endfunction

function! textobj#matchit#select_i() abort
  let end = s:closest_pair()

  if type(end) == v:t_list
    call setpos('.', end)

    normal %j
    let start = getpos('.')
    let end[1] = l:end[1] - 1

    return ['V', start, end]
  else
    return 0
  endif
endfunction
