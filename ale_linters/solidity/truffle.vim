let s:sep = has('win32') ? '\' : '/'

call ale#Set('solidity_truffle_executable', 'truffle')
call ale#Set('solidity_truffle_use_global', 0)

function! ale_linters#solidity#truffle#FindConfig(buffer) abort
  for l:path in ale#path#Upwards(expand('#' . a:buffer . ':p:h'))
    for l:basename in ['truffle.js', 'truffle-config.js']
      let l:config = ale#path#Simplify(join([l:path, l:basename], s:sep))
      if filereadable(l:config)
        return l:config
      endif
    endfor
  endfor

  return 0
endfunction

function! ale_linters#solidity#truffle#GetExecutable(buffer) abort
  let l:config = ale_linters#solidity#truffle#FindConfig(a:buffer)
  if empty(l:config)
    return 0
  endif

  let l:executable = ale#node#FindExecutable(a:buffer, 'solidity_truffle', [
        \ 'node_modules/.bin/truffle',
        \ ])
  if empty(l:executable)
    return 0
  endif

  return l:executable
endfunction

function! ale_linters#solidity#truffle#GetCommand(buffer) abort
  let l:executable = ale_linters#solidity#truffle#GetExecutable(a:buffer)

  return l:executable . ' compile'
endfunction

function! ale_linters#solidity#truffle#Handle(buffer, lines) abort
  "Error parsing /path/to/truffle/project/contracts/HelloWorld.sol: ParsedContract.sol:1:2: ParserError: Expected token LBrace got 'bool'
  let l:pattern = '^Error parsing \(.\+\): .\+:\(\d\+\):\(\d\+\): \(.\+\)$'

  let l:output = []
  for l:match in ale#util#GetMatches(a:lines, [l:pattern])
    let l:obj = {
          \ 'filename': l:match[1],
          \ 'lnum': l:match[2],
          \ 'col': l:match[3],
          \ 'text': l:match[4],
          \ 'type': 'E',
          \ }
    call add(l:output, l:obj)
  endfor

  return l:output
endfunction

call ale#linter#Define('solidity', {
      \ 'name': 'truffle',
      \ 'executable_callback': 'ale_linters#solidity#truffle#GetExecutable',
      \ 'command_callback': 'ale_linters#solidity#truffle#GetCommand',
      \ 'callback': 'ale_linters#solidity#truffle#Handle',
      \ 'read_buffer': 0,
      \ })
