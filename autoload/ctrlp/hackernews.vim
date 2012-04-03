if exists('g:loaded_ctrlp_hackernews') && g:loaded_ctrlp_hackernews
	finish
endif
let g:loaded_ctrlp_hackernews = 1

let s:hackernews_var = {
\  'init':   'ctrlp#hackernews#init()',
\  'exit':   'ctrlp#hackernews#exit()',
\  'accept': 'ctrlp#hackernews#accept',
\  'lname':  'hackernews',
\  'sname':  'hackernews',
\  'type':   'feed',
\  'sort':   0,
\}

if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
	let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:hackernews_var)
else
	let g:ctrlp_ext_vars = [s:hackernews_var]
endif

function! ctrlp#hackernews#init()
  let dom = webapi#xml#parseURL("http://news.ycombinator.com/rss")
	let s:feed = map(dom.childNode().childNodes('item'), '[
  \ v:val.childNode("title").value(),
  \ v:val.childNode("link").value()
	\]')
	return map(copy(s:feed), 'v:val[0]')
endfunc

function! ctrlp#hackernews#accept(mode, str)
	silent call openbrowser#open(filter(copy(s:feed), 'v:val[0] == a:str')[0][1])
	call ctrlp#exit()
endfunction

function! ctrlp#hackernews#exit()
  if exists('s:feed')
    unlet! s:feed
  endif
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#hackernews#id()
	return s:id
endfunction

" vim:fen:fdl=0:ts=2:sw=2:sts=2
