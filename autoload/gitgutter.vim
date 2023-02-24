" get sign ctrembg color
function! s:get_hl(group, what, mode) abort
    let r = synIDattr(synIDtrans(hlID(a:group)), a:what, a:mode)
    if empty(r) || r == -1
        return 'NONE'
    endif
    return r
endfunction
                    
                            

" initialization
function! s:init()
    if !exists('g:gittergut_signbg')
        let ctermbg = s:get_hl('SignColumn', 'bg', 'cterm')
    else
        let ctermbg = g:gittergut_signbg
    endif
     let guibg   = s:get_hl('SignColumn', 'bg', 'gui')
    for type in ["Add", "Change", "Delete"]
        if type == 'Delete'
            let ctermfg = 88 "s:get_hl('DiffDelete', 'fg', 'cterm')
        elseif type == 'Add'
            let ctermfg = 78
        else        
            let ctermfg = s:get_hl('WarningMsg', 'fg', 'cterm')
        endif
        let guifg = s:get_hl('WarningMsg', 'fg', 'gui')
        "let ctermfg = 88
        exec 'hi gitGutter'.type . ' ctermfg=' . ctermfg . ' guifg=' . guifg . ' ctermbg=' . ctermbg . ' guibg=' . guibg . ' cterm=bold gui=bold'
    endfor
    sign define change        text=! texthl=gitGutterChange
    sign define add           text=+ texthl=gitGutterAdd
    sign define delete_top    text=^ texthl=gitGutterDelete
    sign define delete_bottom text=_ texthl=gitGutterDelete
endfunction

" mark a gutter
" name:  sign name
" begin: mark begin line number
" end:   mark end line number
function! s:mark(name, begin, end)
    let i = str2nr(a:begin)
    let end = str2nr(a:end)
    while (i <= end)
        " reset
        call s:reset_mark(i)

        " set
        exe ":sign place " . i . " line=" . i . " name=" . a:name . " file=" . expand("%:p")
        let b:marked_lines[i] = a:name

        let i += 1
    endwhile
endfunction


" reset mark
function! s:reset_mark(i)
    if has_key(b:prev_marked_lines, a:i)
        exe ":sign unplace " . a:i . " file=" . expand("%:p")
        call remove(b:prev_marked_lines, a:i)
    endif
endfunction


" get a path of temporary file for current file
function! s:get_current_file_path()
    return substitute(tempname(), '\', '/', 'g')
endfunction


" check for a git repository
function! s:is_git_repos()
    let path = shellescape(expand("%:r"))
    let ret = system('git status ' . path . ' 2> /dev/null; echo $?')

    if ret
        return 0
    endif

    return 1
endfunction


" check for a file status
function! s:is_modified()
    redir => ret
        silent se modified?
    redir END

    let ret = ret[1: ] " 改行を削除
    if (ret == 'nomodified')
        return 0
    endif

    return 1
endfunction


" get different between HEAD and current
" current: current file path 
function! s:get_diff(current)
    let current = shellescape(a:current)
    let filename = expand("%:t")
    let filedir = shellescape(expand("%:p:h"))
    let prefix = system('cd ' . filedir . '; git rev-parse --show-prefix; cd - > /dev/null')[ :-2] "[ :-2]
    let path = prefix . filename "shellescape(prefx . filename)
    "echom 'prefix:' . prefix
    let diff = system('cd ' . filedir . '; git show HEAD:' . path . ' | diff - ' . current . '; cd - > /dev/null' )
    return split(diff, '\n')
endfunction

" show and hide bufferwise
function! gitgutter#git_gutter_toggle()
    if !exists("b:gitgutter_show")
        let b:gitgutter_show = 0
    else
        let b:gitgutter_show = !b:gitgutter_show
    endif
    if (!b:gitgutter_show)
        exe 'set scl=no'
    else    
        exe 'set scl=auto'
    endif    
endfunction

" git gutter main function
function! gitgutter#git_gutter()
    " check for a git repo
    if (!s:is_git_repos())
        return
    endif

    " check for a file stat
    if (!s:is_modified())
       "return
    endif
    " get diff
    let current = s:get_current_file_path()
    silent execute 'write! ' . escape(current, ' ')
    let diff = s:get_diff(current)

    " init marked lines
    if !exists('b:marked_lines')
        let b:marked_lines = {}
    endif
    let b:prev_marked_lines = b:marked_lines
    let b:marked_lines = {}

    " parse diff
    for line in diff
        " pattern match (e.g. '12c24,25')
        let head_pattern = '^\([0-9]\+\),\?\([0-9]*\)\([acd]\)\([0-9]\+\),\?\([0-9]*\)$'
        if (match(line, head_pattern) >= 0)
            let [origin,before_begin,before_end,ope,after_begin,after_end;_] = matchlist(line, head_pattern)

            " mark only one line when end is empty
            if (after_end == '')
                let after_end = after_begin
            endif

            " when added
            if (ope == 'a')
                call s:mark('add', after_begin, after_end)
            " when changed
            elseif (ope == 'c')
                call s:mark('change', after_begin, after_end)
            " when deleted
            elseif (ope == 'd')
                if after_begin > 0
                    call s:mark('delete_bottom', after_begin, after_end)
                endif
                call s:mark('delete_top', after_begin + 1, after_end + 1)
            endif
        endif
    endfor

    for i in keys(b:prev_marked_lines)
        call s:reset_mark(i)
    endfor
endfunction


" main entry
call s:init()
