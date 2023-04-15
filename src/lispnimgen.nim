import lispnim, os, strutils, nuance/tosexp

proc toNimFile*(path: string): string =
  let lisp = parseLisp(readFile(path), path)
  let ast = toNim(lisp)
  let sexp = toSexp(ast)
  result = """import nuance/[fromsexp, comptime]

load(parseSexp(""" & "\"\"\"" & sexp & "\"\"\"" & "))"

proc generateFile*(path: string) =
  let (d, n, _) = splitFile(path)
  let templ = toNimFile(path)
  writeFile(d / n & ".nim", templ)

proc generateFilesInDir*(dir: string, ext = ".lispnim") =
  for p in walkDirRec(dir):
    if p.endsWith(ext):
      generateFile(p)

proc commandLine*(params: seq[string]) =
  if params.len > 0:
    let a = params[0]
    if fileExists(a): generateFile(a)
    elif dirExists(a): generateFilesInDir(a)
    else: raise newException(ValueError, "cannot find path ")
  else:
    raise newException(ValueError, "provide a file or directory")

when isMainModule and appType == "console":
  commandLine(commandLineParams())
