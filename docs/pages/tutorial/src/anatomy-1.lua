-----------------------------------------------------------------------------------------------------------------------
-- Scribe Tutorial: Make the table anatomy more explicit.
--
-- Full Documentation:      https://nessan.github.io/scribe
-- Source Repository:       https://github.com/nessan/scribe
-- SPDX-FileCopyrightText:  2025 Nessan Fitzmaurice <nessan.fitzmaurice@me.com>
-- SPDX-License-Identifier: MIT
-----------------------------------------------------------------------------------------------------------------------
function table_string(tbl, indent)
    indent = indent or '    '

    local nl          = indent == '' and '' or '\n'
    local table_begin = '{' .. nl
    local table_end   = nl .. '}'
    local key_begin   = ''
    local key_end     = ' = '
    local sep         = ',' .. nl

    local content = ''
    for k, v in pairs(tbl) do
        local k_string = key_begin .. tostring(k) .. key_end
        local v_string = type(v) ~= 'table' and tostring(v) or table_string(v, indent)
        content = content .. indent .. k_string .. v_string .. sep
    end
    return table_begin .. content .. table_end
end

local mouse = { first = 'Minnie', last = 'Mouse' }
print(table_string(mouse))
print(table_string(mouse, ''))
