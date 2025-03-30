package = "scribe"
version = "1.0.0-1"
source = {
  url = "git://github.com/nessan/scribe",
}
description = {
  summary = "Scribe converts Lua objects to readable strings and has output methods to output tables in many different formats.",
  detailed = [[
    Scribe provides functions to convert Lua objects to readable strings and output methods that make printing Lua tables in various formats easy.
    For example, if `arr = {1, 2, 3}` then `scribe.put("Array: %t", arr)` will print "Array: [ 1, 2, 3 ]" to `stdout`.
    Scribe gracefully handles complex tables, including ones with shared and cyclical references.
    The strings returned for those tables show the underlying structure in a way that is as readable as possible.
  ]],
  homepage = "https://nessan.github.io/scribe/",
  license = "MIT <http://opensource.org/licenses/MIT>"
}
dependencies = {
  "lua >= 5.1"
}
build = {
  type = "builtin",
  modules = {
    scribe = "scribe.lua"
  }
}
