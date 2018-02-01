let s:sep = has('win32') ? '\' : '/'

call ale#Set('solidity_solium_executable', 'solium')
call ale#Set('solidity_solium_use_global', 0)

function! ale#handlers#solium#FindConfig(buffer) abort
  for l:path in ale#path#Upwards(expand('#' . a:buffer . ':p:h'))
    let l:config = ale#path#Simplify(join([l:path, '.soliumrc.json'], s:sep))
    if filereadable(l:config)
      return l:config
    endif
  endfor
endfunction

function! ale#handlers#solium#GetExecutable(buffer) abort
  return ale#node#FindExecutable(a:buffer, 'solidity_solium', [
  \    'node_modules/.bin/solium',
  \])
endfunction

function! ale#handlers#solium#GetCommand(buffer) abort
  let l:executable = ale#handlers#solium#GetExecutable(a:buffer)
  let l:config = ale#handlers#solium#FindConfig(a:buffer)
  return ale#node#Executable(a:buffer, l:executable)
  \   . (!empty(l:config) ? ' --config ' . l:config : '')
  \   . ' --reporter gcc --file %t'
endfunction
