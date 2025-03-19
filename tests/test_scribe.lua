
-- Add the current & parent directories to the `package.path` so that the `scribe` module can be found.
local cwd = debug.getinfo(1, 'S').source:match [[^@?(.*[\/])[^\/]-$]]
package.path = cwd .. "?.lua;" .. cwd .. "../?.lua;" .. package.path

local luaunit = require('luaunit')
local scribe = require('scribe')

TestScribe = {}

function TestScribe:testSimpleString()
    luaunit.assertEquals(scribe.scribe(123), "123")
    luaunit.assertEquals(scribe.scribe(true), "true")
    luaunit.assertEquals(scribe.scribe("hello"), "\"hello\"")
end

function TestScribe:testInlineTable()
    local tbl = { 1, 2, 3 }
    luaunit.assertEquals(scribe.inline(tbl), "[ 1, 2, 3 ]")
end

function TestScribe:testPrettyTable()
    local tbl = { a = 1, b = 2 }
    local expected = "{ a = 1, b = 2 }"
    luaunit.assertEquals(scribe.pretty(tbl), expected)
end

function TestScribe:testClassicTable()
    local tbl = { 1, 2, 3 }
    local expected = [[
{
    1,
    2,
    3
}]]
    luaunit.assertEquals(scribe.classic(tbl), expected)
end

function TestScribe:testJsonTable()
    local tbl = { a = 1, b = 2 }
    local expected = [[
{
    "a": 1,
    "b": 2
}]]
    luaunit.assertEquals(scribe.json(tbl), expected)
end

function TestScribe:testInlineJsonTable()
    local tbl = { a = 1, b = 2 }
    luaunit.assertEquals(scribe.inline_json(tbl), '{"a":1,"b":2}')
end

function TestScribe:testFormat()
    local tbl = { 1, 2, 3 }
    luaunit.assertEquals(scribe.format("Table: %t", tbl), "Table: [ 1, 2, 3 ]")
end

os.exit(luaunit.LuaUnit.run())
