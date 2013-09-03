function! airline#extensions#weather#init(ext)
  call a:ext.add_statusline_funcref(function('airline#extensions#weather#apply'))
endfunction

function! airline#extensions#weather#apply(...)
  let w:airline_section_c = get(w:, 'airline_section_c', g:airline_section_c)
  let w:airline_section_c .= g:airline_left_sep . ' %{weather#get()}'
endfunction
