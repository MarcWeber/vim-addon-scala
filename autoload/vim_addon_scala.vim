fun! vim_addon_scala#CompileRHS(...)
  let target = a:0 > 0 ? a:1 : ""
  let ef= 
        \  '%f:%l:\ characters\ %c-%*[^\ ]\ %m,'
        \ .'%f:%l:\ %m'

  if target == ""
    return "call bg#RunQF(['haxe',".string(haxe#BuildHXMLPath())."], 'c', ".string(ef).")"
  endif

  let class = expand('%:r')

  if target[-4:] == "neko"
    let nekoFile = class.'.n'

    if target == "target-neko"
      let args = actions#VerifyArgs(['haxe','-main',class,'-neko',nekoFile])
      return "call bg#RunQF(".string(args).", 'c', ".string(ef).")"
    elseif target == "run-neko"
      let args = actions#VerifyArgs(['neko',nekoFile])
      return "call bg#RunQF(".string(args).", 'c', ".string("none").")"
    endif
  endif

  if target[-3:] == "php"
    let phpFront = "index.php"
    let phpDir = "php-target"

    if target == "target-php"
      let args = actions#VerifyArgs(['haxe','-main',class,'--php-front',phpFront,'-php', phpDir])
      return "call bg#RunQF(".string(args).", 'c', ".string(ef).")"
    elseif target == "run-php"
      let args = actions#VerifyArgs(['php',phpDir.'/'.phpFront])
      return "call bg#RunQF(".string(args).", 'c', ".string("none").")"
    endif
  endif

endfun

" returns "" if no package line is found
fun! vim_addon_scala#PackageName(append)
  let lines_with_package = filter(getline(1,line('$')),'v:val =~ '.string('^\s*package\>'))
  if len(lines_with_package) > 1
    throw "multiple lines containing '^ package'"
  elseif len(lines_with_package) == 1
    return matchstr(lines_with_package[0],'^\s*package\s*\zs\<[^ \n\r\t]*\ze').a:append
  else
    return ""
  endif
endf
