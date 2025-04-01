-----------------------------------------------------------------------------------------------------------------------
-- Scribe Tutorial: First Cut
--
-- Full Documentation:      https://nessan.github.io/scribe
-- Source Repository:       https://github.com/nessan/scribe
-- SPDX-FileCopyrightText:  2025 Nessan Fitzmaurice <nessan.fitzmaurice@me.com>
-- SPDX-License-Identifier: MIT
-----------------------------------------------------------------------------------------------------------------------
function table_string(tbl)
    local indent = '    '
    local retval = '{\n'
    for k, v in pairs(tbl) do
        retval = retval .. indent
        retval = retval .. tostring(k) .. ' = '
        if type(v) ~= 'table' then
            retval = retval .. tostring(v)
        else
            retval = retval .. table_string(v)
        end
        retval = retval .. ',\n'
    end
    retval = retval .. '\n}'
    return retval
end

local mouse = { first = 'Minnie', last = 'Mouse' }
print(table_string(mouse))
