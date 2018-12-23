call textobj#matchit#map('d')

if g:textobj#matchit#can_map_surround
  let b:surround_{char2nr('m')} = "@\1Blade directive: @\1 \r @end\1\r\[( \]\\+.*\r\1"

  " Some aliases for convenience
  let b:surround_{char2nr('d')} = b:surround_{char2nr('m')}
  let b:surround_{char2nr('D')} = b:surround_{char2nr('m')}
  let b:surround_{char2nr('@')} = b:surround_{char2nr('m')}
endif
