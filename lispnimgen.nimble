# Package

version       = "0.1.0"
author        = "metagn"
description   = "nim file generator for lispnim"
license       = "MIT"
srcDir        = "src"
bin           = @["lispnimgen"]


# Dependencies

requires "nim >= 1.6.12"
requires "nuance"
requires "https://github.com/metagn/lispnim"
