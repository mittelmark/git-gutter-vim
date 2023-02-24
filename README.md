git-gutter-vim
==============


## About

`git-gutter.vim` is a vim plugin version which just inserts git marks in the sign column of vim.
The  plugin updates gutter when you save a file. It is a fork of  
[akiomik's repository](https://github.com/akiomik/git-gutter-vim) with bug-fixes and adding `GitGutterToggle` functionality.

![screenshot](https://raw.githubusercontent.com/mittelmark/git-gutter-vim/master/screenshot.png)

There are two commands:

- `GitGutter` - automatically executed if you open or save a file, it does not
  show anything in the sign column if you are not in a git repository, if your file is in
  a repository folder but not added, you will see a lot of plus signs on the
  left 
- `GitGutterToggle` - allows you to hide the sign column on a per buffer base,
  executing it again will make the sign column again visible

This is a small plugin - you still have to execute your git commands as usually like this:

```
:!git commit -m "updating README fork details" %
```

If you need more than this you can have a look at great plugins like
[vim-fugative](https://github.com/tpope/vim-fugitive) or
[vim-gitgutter](https://github.com/airblade/vim-gitgutter) which
offer much more than this simple plugin.

## History

The original author was
[akiomik](https://github.com/akiomik/git-gutter-vim), but the plugin does not
worked anymore with newer versions of git and vim.

## Quick installation 

### Using Git only

We just clone the repository into the vim plugins folder:

```
mkdir -p ~/.vim/pack/vendor/start
git clone https://github.com/mittelmark/git-gutter-vim.git \
  ~/.vim/pack/vendor/start/git-gutter-vim
```

### Using vim-plug

With [vim-plug](https://github.com/junegunn/vim-plug) you need to add this to
your `.vimrc` file.

1. Add the following line to your `.vimrc`.

```vim
call plug#begin('/home/groth/.vim/autoload')
Plug 'mittelmark/git-gutter-vim'
call plug#end()
```

2. Run therafter thie command on vim.

```vim
:PlugInstall
```

For other plugin managers check the documentation.

## FAQ

- I am not happy with the background color for the sign column, how can I change
  this:
- Usually the sign colors are taken from the SignColor settings but sometimes
  they do not match the background of the text editor, try something like his in your
  `.vimrc`:

```vim
" ~/.vimrc
" for colors see here: https://www.ditig.com/256-colors-cheat-sheet
set t_Co=256
set background=dark
colorscheme=default
" setting a slightly grey background for 
" gitter symbols and the sign column which should fit with most colorschemes
let g:gittergut_signbg=234
hi SignColumn ctermbg=234
```

## TODO's

- manual color declaration with variables in `.vimrc`
- extracting the right colors from a schema automatically if possible

## License

The MIT License. See `LICENSE`.
