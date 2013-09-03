scriptencoding utf-8

let g:weather#area = get(g:, 'weather#area', 'tokyo')

let s:status = get(g:, 'weather#status_map', {
\ "01": "sky is clear",
\ "02": "few clouds",
\ "03": "scattered clouds",
\ "04": "broken clouds",
\ "09": "shower rain",
\ "10": "Rain",
\ "11": "Thunderstorm",
\ "13": "snow",
\ "50": "mist",
\})

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
    let area = json.list[0].name
    let status = json.list[0].weather[0].icon[:1]
    return printf("%s: %s",
    \ json.list[0].name,
    \ has_key(s:status, status) ? s:status[status] : '?')
  catch
  endtry
  return ''
endfunction
