sign define change        text=! texthl=SignColumn
sign define add           text=+ texthl=SignColumn
sign define delete_top    text=^ texthl=SignColumn
sign define delete_bottom text=_ texthl=SignColumn


" init window variables
if !exists('w:marked_lines')
	let w:marked_lines = []
endif


" mark a gutter
" name:  sign name
" begin: mark begin line number
" end:   mark end line number
function! s:mark(name, begin, end)
	let i = str2nr(a:begin)
	let end = str2nr(a:end)
	while (i <= end)
		exe ":sign place " . i . " line=" . i . " name=" . a:name . " file=" . expand("%:p")
        call add(w:marked_lines, i)
		let i += 1
	endwhile
endfunction


" reset all marks
function! s:reset_marks()
	if exists('w:marked_lines')
		for i in w:marked_lines
			exe ":sign unplace " . i . " file=" . expand("%:p")
		endfor
	endif
	let w:marked_lines = []
endfunction


" get a path of temporary file for current file
function! s:get_current_file_path()
	return substitute(tempname(), '\', '/', 'g')
endfunction


" check for a git repository
function! s:is_git_repos()
	let path = expand("%:r")
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
	let filename = expand("%")	" NOTE: %:p だとフルパス

	let diff = system('git show HEAD:' . filename . ' | diff - ' . a:current)
    return split(diff, '\n')
endfunction


" git gutter
function! gitgutter#git_gutter()
	" check for a git repo
	if (!s:is_git_repos())
		return
	endif

	" check for a file stat
	if (!s:is_modified())
"		return
	endif

	" get diff
	let current = s:get_current_file_path()
	silent execute 'write! ' . escape(current, ' ')
	let diff = s:get_diff(current)

	" reset all marks
	call s:reset_marks()

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
endfunction
