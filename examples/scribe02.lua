-----------------------------------------------------------------------------------------------------------------------
-- scribe: Example that reads lots of tables from a samples.lua file and dumps them in many formats to output files.
--
-- Full Documentation:     https://nessan.github.io/scribe
-- Source Repository:      https://github.com/nessan/scribe
-- SPDX-FileCopyrightText: 2025 Nessan Fitzmaurice <nessan.fitzmaurice@me.com>
-- SPDX-License-Identifier: MIT
-----------------------------------------------------------------------------------------------------------------------

-- Add the current & parent directories to the `package.path` so that the `scribe` module can be found.
local cwd = debug.getinfo(1, 'S').source:match [[^@?(.*[\/])[^\/]-$]]
package.path = cwd .. "?.lua;" .. cwd .. "../?.lua;" .. package.path

local putln   = require("scribe").putln
local samples = require("samples")

-- Put all the output files in a subdirectory called `output` of the current working directory.
local output_dir = cwd .. 'output'
local exists = os.rename(output_dir, output_dir)
if not exists then
    -- Directory does not exist, create it
    print("Creating output directory: " .. output_dir)
    local success, err = os.execute("mkdir -p " .. output_dir)
    if not success then
        error("Failed to create output directory: " .. err)
    end
end

-- Run through all the tables in the `samples` module and dump them in various formats to files in the `output` directory.
for _, tbl in pairs(samples) do
    if type(tbl.value) == 'table' and type(tbl.name) == 'string' then
        local filename = output_dir .. '/' .. tbl.name .. ".txt"
        putln("Dumping the table `%s` in various formats to the file %q", tbl.name, filename)
        local f = assert(io.open(filename, "w"), "Could not open output file: " .. filename)
        f:putln("Inline Format for %q:\n%t\n", tbl.name, tbl.value)
        f:putln("Pretty Format for %q:\n%T\n", tbl.name, tbl.value)
        f:putln("Classic Format for %q:\n%2T\n", tbl.name, tbl.value)
        f:putln("Alternate Format for %q:\n%3T\n", tbl.name, tbl.value)
        f:putln("Inline JSON Format for %q:\n%j\n", tbl.name, tbl.value)
        f:putln("JSON Format for %q:\n%J\n", tbl.name, tbl.value)
        f:putln("Debug Format for %q:\n%9T\n", tbl.name, tbl.value)
    end
end
