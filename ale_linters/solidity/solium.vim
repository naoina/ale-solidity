call ale#linter#Define('solidity', {
\   'name': 'solium',
\   'executable_callback': 'ale#handlers#solium#GetExecutable',
\   'command_callback': 'ale#handlers#solium#GetCommand',
\   'callback': 'ale#handlers#gcc#HandleGCCFormat',
\})
