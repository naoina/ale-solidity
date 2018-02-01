function! ale#fixers#solium#Fix(buffer) abort
  let l:executable = ale#handlers#solium#GetExecutable(a:buffer)

  if !executable(l:executable)
    return 0
  endif

  let l:config = ale#handlers#solium#FindConfig(a:buffer)

  if empty(l:config)
    return 0
  endif

  let l:command = l:executable . ' --config ' . l:config

  return {
  \   'command': l:command
  \       . ' --config ' . ale#Escape(l:config)
  \       . ' --fix'
  \       . ' --file %t',
  \   'read_temporary_file': 1,
  \}
endfunction
