----------------------------------------------------------------------------------------------------------------------
-- Busted tests for the `scribe` module.
--
-- SPDX-FileCopyrightText:  2025 Nessan Fitzmaurice <nzznfitz+gh@icloud.com>
-- SPDX-License-Identifier: MIT
-----------------------------------------------------------------------------------------------------------------------

-- Add "." and ".." to the package path for relative requires.
local dot = debug.getinfo(1, 'S').source:match [[^@?(.*[\/])[^\/]-$]] or "./"
package.path = dot .. "?.lua;" .. dot .. "../?.lua;" .. package.path

local busted = require('busted')
local describe, it = busted.describe, busted.it
local assert = require('luassert')

local scribe = require 'scribe'

describe('scribe', function()
    describe('basic functionality', function()
        it('should handle nil values', function()
            assert.are.equal('nil', scribe(nil))
        end)

        it('should handle numbers', function()
            assert.are.equal('42', scribe(42))
            assert.are.equal('-42', scribe(-42))
            assert.are.equal('3.14', scribe(3.14))
        end)

        it('should handle booleans', function()
            assert.are.equal('true', scribe(true))
            assert.are.equal('false', scribe(false))
        end)

        it('should handle strings', function()
            assert.are.equal('"hello"', scribe('hello'))
            assert.are.equal('"hello world"', scribe('hello world'))
        end)

        it('should handle empty tables', function()
            assert.are.equal('{}', scribe({}))
        end)

        it('should handle simple arrays', function()
            assert.are.equal('[ 1, 2, 3 ]', scribe({ 1, 2, 3 }))
        end)

        it('should handle simple key-value tables', function()
            assert.are.equal('{ a = 1, b = 2 }', scribe({ a = 1, b = 2 }))
        end)
    end)

    describe('nested structures', function()
        it('should handle nested arrays', function()
            local input = { 1, { 2, 3 }, 4 }
            assert.are.equal('[ 1, [ 2, 3 ], 4 ]', scribe(input))
        end)

        it('should handle nested tables', function()
            local input = { a = 1, b = { c = 2, d = 3 } }
            assert.are.equal('{ a = 1, b = { c = 2, d = 3 } }', scribe(input))
        end)

        it('should handle mixed nested structures', function()
            local input = { a = 1, b = { 2, 3 }, c = { d = 4 } }
            assert.are.equal('{ a = 1, b = [ 2, 3 ], c = { d = 4 } }', scribe(input))
        end)
    end)

    describe('shared references', function()
        it('should handle shared table references', function()
            local shared = { x = 1 }
            local input = { a = shared, b = shared }
            local expected = '{\n    a = { x = 1 },\n    b = <a>\n}'
            assert.are.equal(expected, scribe.pretty(input))
        end)

        it('should handle nested shared references', function()
            local shared = { x = 1 }
            local input = { a = { b = shared }, c = { d = shared } }
            local expected = '{\n    a = {\n        b = { x = 1 }\n    },\n    c = { d = <a.b> }\n}'
            assert.are.equal(expected, scribe.pretty(input))
        end)
    end)

    describe('formatting options', function()
        it('should support inline format', function()
            local input = { a = 1, b = { 2, 3 } }
            assert.are.equal('{ a = 1, b = [ 2, 3 ] }', scribe.inline(input))
        end)

        it('should support pretty format', function()
            local input = { a = 1, b = { 2, 3 } }
            local expected = [[
{
    a = 1,
    b = [ 2, 3 ]
}]]
            assert.are.equal(expected, scribe.pretty(input))
        end)

        it('should support classic format', function()
            local input = { a = 1, b = { 2, 3 } }
            local expected = [[
{
    a = 1,
    b = {
        2,
        3
    }
}]]
            assert.are.equal(expected, scribe.classic(input))
        end)

        it('should support alt format', function()
            local input = { a = 1, b = 22 }
            local expected = [[
a: 1,
b: 22]]
            assert.are.equal(expected, scribe.alt(input))
        end)

        it('should support JSON format', function()
            local input = { a = 1, b = { 2, 3 } }
            local expected = [[
{
    "a": 1,
    "b": [
        2,
        3
    ]
}]]
            assert.are.equal(expected, scribe.json(input))
        end)

        it('should support inline JSON format', function()
            local input = { a = 1, b = { 2, 3 } }
            assert.are.equal('{"a":1,"b":[2,3]}', scribe.inline_json(input))
        end)
    end)

    describe('format string functionality', function()
        it('should handle basic format strings', function()
            assert.are.equal('Hello, world!', scribe.format('Hello, %s!', 'world'))
        end)

        it('should handle table format specifiers', function()
            local tbl = { 1, 2, 3 }
            assert.are.equal('Table: [ 1, 2, 3 ]', scribe.format('Table: %t', tbl))
        end)

        it('should handle multiple table format specifiers', function()
            local tbl1 = { 1, 2, 3 }
            local tbl2 = { a = 1, b = 2 }
            assert.are.equal('Arrays: [ 1, 2, 3 ], Table: { a = 1, b = 2 }',
                scribe.format('Arrays: %t, Table: %t', tbl1, tbl2))
        end)

        it('should handle JSON format specifiers', function()
            local tbl = { a = 1, b = 2 }
            assert.are.equal('{"a":1,"b":2}', scribe.format('%j', tbl))
        end)
    end)

    describe('edge cases', function()
        it('should handle empty format strings', function()
            assert.are.equal('', scribe.format(''))
        end)

        it('should handle nil format strings', function()
            assert.are.equal('', scribe.format(nil))
        end)

        it('should handle tables with function values', function()
            local input = { f = function() end }
            assert.are.equal('{ f = <function> }', scribe(input))
        end)

        it('should handle tables with userdata values', function()
            local input = { u = io.stdout }
            assert.are.equal('{ u = <userdata> }', scribe(input))
        end)

        it('should handle tables with thread values', function()
            local input = { t = coroutine.create(function() end) }
            assert.are.equal('{ t = <thread> }', scribe(input))
        end)
    end)
end)
