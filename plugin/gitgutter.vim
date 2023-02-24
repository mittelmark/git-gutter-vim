command! -nargs=0 GitGutter :call gitgutter#git_gutter()
command! -nargs=0 GitGutterToggle :call gitgutter#git_gutter_toggle() 
" let's write some more comments"
if has("autocmd")
    augroup gitgutter
        autocmd BufRead  * :GitGutter
        autocmd BufWrite * :GitGutter
        autocmd ShellCmdPost * :GitGutter " after `!git commit -m 'message' %` for instance
    augroup END
endif
