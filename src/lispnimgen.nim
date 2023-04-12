import lispnim, os, strutils, nuance/tosexp

proc generateFile(path: string) =
  let lisp = parseLisp(readFile(path), path)
  let ast = toNim(lisp)
  let sexp = toSexp(ast)
  let (d, n, _) = splitFile(path)
  let templ = """import nuance/[fromsexp, comptime]

load(parseSexp(""" & "\"\"\"" & sexp & "\"\"\"" & "))"
  writeFile(d / n & ".nim", templ)

proc generateFilesInDir(dir: string, ext = ".lispnim") =
  for p in walkDirRec(dir):
    if p.endsWith(ext):
      generateFile(p)

proc commandLine() =
  let params = commandLineParams()
  if params.len > 0:
    let a = params[0]
    if fileExists(a): generateFile(a)
    elif dirExists(a): generateFilesInDir(a)
    else: echo "cannot find path ", a
  else:
    echo "provide a file or directory"
  
commandLine()
