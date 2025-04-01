-----------------------------------------------------------------------------------------------------------------------
-- Scribe Tutorial: Simple example of the `__tostring` metamethod.
--
-- Full Documentation:      https://nessan.github.io/scribe
-- Source Repository:       https://github.com/nessan/scribe
-- SPDX-FileCopyrightText:  2025 Nessan Fitzmaurice <nessan.fitzmaurice@me.com>
-- SPDX-License-Identifier: MIT
-----------------------------------------------------------------------------------------------------------------------

local count = 0
local mt = {}
function mt.__tostring(tbl)
    count = count + 1
    return 'This is print number: ' .. tostring(count) .. ' for an array of size: ' .. #tbl -- <4>
end

local arr = { 1, 2, 3 }
setmetatable(arr, mt)

print(arr) -- This is print number: 1 for an array of size: 3
print(arr) -- This is print number: 2 for an array of size: 3
print(arr) -- This is print number: 3 for an array of size: 3

