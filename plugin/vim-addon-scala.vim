augroup SCALA
  autocmd BufRead,BufNewFile *.scala if &ft == '' | setlocal ft=scala |endif
augroup end

" although this works I recommend using the vim-addon-sbt (simple build tool)

call actions#AddAction('scala current file', {'action': funcref#Function('actions#CompileRHSSimple',
      \ {'args': [   ['set ef=set errorformat=(fragment\ of\ %f):%l:\ %m']
                 \ , ["scalac", funcref#Function('return expand("%")')]
                 \ ]})})

" pass the word behind object to scala because the .class file will be named
" that way by default
call actions#AddAction('scala run compiled current file', {'action': funcref#Function('actions#CompileRHSSimple',
  \ {'args': [ [], ["scala", funcref#Function("return matchstr(filter(getline(0,line('$')),'v:val=~ '.string('^\\s*object '))[0],'object \\zs\\S*\\ze')")] ]})})

" TODO write an interface for maven search?
command ScalaVersions exec "sp | new | r! curl -q 'http://nexus.scala-tools.org/service/local/data_index?_dc=1276701638718&from=0&count=50&q=scala-lib' 2>/dev/null | sed -n 's@\\s*<version>\\([^<]*\\)</version>.*@\\1@p' | sort"
