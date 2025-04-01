-----------------------------------------------------------------------------------------------------------------------
-- Scribe Tutorial: Add `indent` as a parameter and use it to trigger inline vs. multiline table formatting
--
-- Full Documentation:      https://nessan.github.io/scribe
-- Source Repository:       https://github.com/nessan/scribe
-- SPDX-FileCopyrightText:  2025 Nessan Fitzmaurice <nessan.fitzmaurice@me.com>
-- SPDX-License-Identifier: MIT
-----------------------------------------------------------------------------------------------------------------------
function table_string(tbl, indent)
    indent = indent or '    '
    
    local nl = indent == '' and '' or '\n'
    local retval = '{' .. nl
    for k, v in pairs(tbl) do
        retval = retval .. indent
        retval = retval .. tostring(k) .. ' = '
        if type(v) ~= 'table' then
            retval = retval .. tostring(v)
        else
            retval = retval .. table_string(v)
        end
        retval = retval .. ',' .. nl
    end
    retval = retval .. nl .. '}'
    return retval
end

local mouse = { first = 'Minnie', last = 'Mouse' }
print(table_string(mouse))
print(table_string(mouse, ''))
