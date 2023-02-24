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
plug#begin('/home/groth/.vim/autoload')
Plug 'mittelmark/git-gutter-vim'
call plug#end()
```

2. Run this command on vim.

```vim
:PlugInstall
```

For other plugin managers check the documentation.

## License

  The MIT License. See `LICENSE`.
