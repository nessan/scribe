-----------------------------------------------------------------------------------------------------------------------
-- scribe: Example -- dumps a simple table to stdout in various formats.
--
-- Full Documentation:     https://nessan.github.io/scribe
-- Source Repository:      https://github.com/nessan/scribe
-- SPDX-FileCopyrightText: 2025 Nessan Fitzmaurice <nessan.fitzmaurice@me.com>
-- SPDX-License-Identifier: MIT
-----------------------------------------------------------------------------------------------------------------------

-- Add the current & parent directories to the `package.path` so that the `scribe` module can be found.
local cwd = debug.getinfo(1, 'S').source:match [[^@?(.*[\/])[^\/]-$]]
package.path = cwd .. "?.lua;" .. cwd .. "../?.lua;" .. package.path

local putln = require("scribe").putln

local tbl = {
    names  = { "tom", "dick", "harry" },
    ages   = { 21, 24, 23 },
    grades = {}
}

putln("Inline Format:%t\n",      tbl)
putln("Pretty Format:%T\n",      tbl)
putln("Classic Format:%2T\n",    tbl)
putln("Alternate Format:%3T\n",  tbl)
putln("Inline JSON Format:%j\n", tbl)
putln("JSON Format:%J\n",        tbl)
putln("Debug Format:%9T\n",      tbl)
