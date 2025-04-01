-----------------------------------------------------------------------------------------------------------------------
-- Scribe Tutorial: Package the user-configurable parameters as an `opts` table.
--
-- Full Documentation:      https://nessan.github.io/scribe
-- Source Repository:       https://github.com/nessan/scribe
-- SPDX-FileCopyrightText:  2025 Nessan Fitzmaurice <nessan.fitzmaurice@me.com>
-- SPDX-License-Identifier: MIT
-----------------------------------------------------------------------------------------------------------------------

local options = {}
options.pretty = {
    indent      = '    ',
    table_begin = '{',
    table_end   = '}',
    key_begin   = '',
    key_end     = ' = ',
    sep         = ','
}

function table_string(tbl, opts)
    opts = opts or options.pretty

    local indent = opts.indent
    local nl = indent == '' and '' or '\n'
    local tb = opts.table_begin .. nl
    local te = nl .. opts.table_end
    local kb, ke = opts.key_begin, opts.key_end
    local sep = opts.sep .. nl

    local content = ''
    for k, v in pairs(tbl) do
        local k_string = kb .. tostring(k) .. ke
        local v_string = type(v) ~= 'table' and tostring(v) or table_string(v, opts)
        content = content .. indent .. k_string .. v_string .. sep
    end
    return tb .. content .. te
end

local mouse = { first = 'Minnie', last = 'Mouse' }
print(table_string(mouse, options.pretty))
