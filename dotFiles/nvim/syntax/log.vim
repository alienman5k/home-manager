" Vim syntax file
" Language:         Generic log file
" Maintainer:       MTDL9 <https://github.com/MTDL9>
" Latest Revision:  2020-08-23

if exists('b:current_syntax')
  finish
endif

let s:cpo_save = &cpoptions
set cpoptions&vim

"TimeStamp
syn match logDate '\d\{2,4}[-\/]\(\d\{2}\|Jan\|Feb\|Mar\|Apr\|May\|Jun\|Jul\|Aug\|Sep\|Oct\|Nov\|Dec\)[-\/]\d\{2,4}T\?'
" syn region logDateReg start="\[" end="T" contained nextgroup=logDate

" syn match logTime '\d\{2}:\d\{2}:\d\{2}\(\.\d\{2,6}\)\?\(\s\?[-+]\d\{2,4}\|Z\)\?\>'
syn match logTime '\d\{2}:\d\{2}:\d\{2}'


syn match logServer '\(\|UI\|Service\|ESS_SOA\)Server_\d\+'
" syn region logSource start="APPS_SOURCE"ms=e+2 end="APPS_TERRITORY"me=s-4
syn region logSource start="\[APPS_SOURCE"ms=e+2 end="\]"me=s-1
syn region logMsg start="SRC_METHOD\: publish"ms=e+2 end="\n"

" Message Levels
syn keyword logLevelError ERROR 
syn keyword logLevelException EXCEPTION
syn keyword logLevelWarning WARNING
syn keyword logLevelTrace FINE FINER FINEST DEBUG
syn match logLevelTrace "TRACE:\d\+"
syn match logLevelTrace "NOTIFICATION:\d\+"

" Start and End of methods
" syn match logStartMethod "\(Start of Method\|Entering Method\)"
syn match logStartMethod 'Start of method'
" syn match logEndMethod "\(End of Method\|Exiting Method\)"

""""""""""""""""""""""""""""""""""""""
"" Highlights
""""""""""""""""""""""""""""""""""""""
hi def link logDate Type
" hi def link logDateReg Type
hi def link logTime Constant

hi def link logServer Identifier
hi def link logSource StorageClass
hi def link logMsg String
hi def link logStartMethod Function
" hi def link logEndMethod Function
" hi def link logMsg Comment

hi def link logLevelError WarningMsg
hi def link logLevelWarning WarningMsg
hi def link logLevelTrace MoreMsg
" hi def link String String


let b:current_syntax = 'log'

let &cpoptions = s:cpo_save
unlet s:cpo_save

