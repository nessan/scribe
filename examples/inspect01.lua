-----------------------------------------------------------------------------------------------------------------------
-- scribe: Compare `scribe` output to that from `inspect`.
-- To run this, you need to have `inspect` installed --- see: https://github.com/kikito/inspect.lua
--
-- Full Documentation:     https://nessan.github.io/scribe
-- Source Repository:      https://github.com/nessan/scribe
-- SPDX-FileCopyrightText: 2025 Nessan Fitzmaurice <nessan.fitzmaurice@me.com>
-- SPDX-License-Identifier: MIT
-----------------------------------------------------------------------------------------------------------------------

-- Add the current & parent directories to the `package.path` so that the `scribe` module can be found.
local cwd = debug.getinfo(1, 'S').source:match [[^@?(.*[\/])[^\/]-$]]
package.path = cwd .. "?.lua;" .. cwd .. "../?.lua;" .. package.path

local scribe = require("scribe")
local inspect = require("inspect")
local pretty = scribe.pretty
local putln = scribe.putln

local tbl = { 
    names = { "tom", "dick", "harry" }, 
    ages = { 21, 24, 23 }, 
    grades = {}, 
    more = { 
        teachers = { 'alison', 'james', 'liz' }, 
        subjects = { 'math', 'history', 'music' },
        yet_more = {
            insturments = { "drums", "piano", "viola" },
            sports = { "swimming", "gymnastics", "soccer" }
        }
    }
}

print("inspect")
print(inspect(tbl))
print("pretty")
print(scribe.pretty(tbl))
print("inline")
print(scribe.inline(tbl))
print("debug")
print(scribe.debug(tbl))
