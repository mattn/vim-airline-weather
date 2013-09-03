scriptencoding utf-8

let g:weather#area = get(g:, 'weather#area', 'tokyo')

function! weather#get() abort
  try
    let file = expand("~/.weather-vim")
    let content = ""
    if filereadable(file)
      if localtime() - getftime(file) < 60*60
        let content = join(readfile(file), "\n")
      endif
    endif
    if content == ""
      let content = webapi#http#get(printf("http://openweathermap.org/data/2.1/find/name?q=%s", g:weather#area)).content
      call writefile(split(content, "\n"), file)
    endif
    let json = webapi#json#decode(content)
    let g:hoge = json
    return printf("%s: %s",
    \ json.list[0].name,
    \ json.list[0].weather[0].main)
  catch
  endtry
  return ''
endfunction
