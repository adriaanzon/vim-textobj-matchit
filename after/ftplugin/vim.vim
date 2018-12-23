if g:textobj#matchit#can_map_surround
  let b:surround_{char2nr('m')} = "\1Vim matchpair\1 \r end\1\r\\>.*\r\1"
endif
