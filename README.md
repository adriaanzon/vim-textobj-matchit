# vim-textobj-matchit [![CircleCI](https://circleci.com/gh/adriaanzon/vim-textobj-matchit.svg?style=svg)](https://circleci.com/gh/adriaanzon/vim-textobj-matchit)

A Vim plugin that creates text objects from matchit patterns, to be used with:

* Ruby (`if…end`, `def…end`)
* Blade (`@section…@endsection`)
* Shell (`if…fi`, `for…done`)
* Vim script (`if…endif`, `for…endfor`)
* Any other filetype that has matchit definitions like these...

## :package: Installation

Depends on [vim-textobj-user][textobj-user] and [matchit][matchit].

```vim
Plug 'kana/vim-textobj-user'
Plug 'adriaanzon/vim-textobj-matchit'

runtime macros/matchit.vim
```

It's likely that matchit is already enabled. You can check so by running
`:echo g:loaded_matchit`. It will return `1` when it's enabled.

## :sparkles: Usage

(TODO: usage summary)

See `:h textobj-matchit` for more details.

## :man_teacher: History

This plugin derives from [vim-textobj-rubyblock][textobj-rubyblock] and
[vim-textobj-blade-directive][textobj-blade-directive]. I wanted something
similar that works for every filetype, so that is why I created this plugin.

## :page_facing_up: License

Copyright © Adriaan Zonnenberg. Distributed under the same terms as Vim itself.
See `:help license`.

[matchit]: http://www.vim.org/scripts/script.php?script_id=39
[textobj-blade-directive]: https://github.com/adriaanzon/vim-textobj-blade-directive
[textobj-rubyblock]: https://github.com/nelstrom/vim-textobj-rubyblock
[textobj-user]: https://github.com/kana/vim-textobj-user
