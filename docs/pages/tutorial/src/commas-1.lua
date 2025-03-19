-----------------------------------------------------------------------------------------------------------------------
-- Scribe Tutorial: Fix the trailing comma issue by doing an extra pass to compute the size of the table.
--
-- Full Documentation:      https://nessan.github.io/scribe
-- Source Repository:       https://github.com/nessan/scribe
-- SPDX-FileCopyrightText:  2025 Nessan Fitzmaurice <nessan.fitzmaurice@me.com>
-- SPDX-License-Identifier: MIT
-----------------------------------------------------------------------------------------------------------------------

local function table_clone(tbl)
    local retval = {}
    for k, v in pairs(tbl) do retval[k] = v end
    return retval
end

local options = {}
options.pretty = {
    indent        = '    ',
    table_begin   = '{',
    table_end     = '}',
    key_begin     = '',
    key_end       = ' = ',
    sep           = ',',
    inline_spacer = ' ' -- <1>
}

options.inline = table_clone(options.pretty)
options.inline.indent = ''

local function table_size(tbl)
    local size = 0
    for _, _ in pairs(tbl) do size = size + 1 end
    return size
end

function table_string(tbl, opts)
    opts = opts or options.pretty

    local tb, te = opts.table_begin, opts.table_end
    local kb, ke = opts.key_begin, opts.key_end
    local sep = opts.sep
    local indent = opts.indent

    local nl = indent == '' and opts.inline_spacer or '\n'
    sep = sep .. nl
    tb = tb .. nl
    te = nl .. te

    local content = ''
    local i, size = 0, table_size(tbl)
    for k, v in pairs(tbl) do
        i = i + 1
        local k_string = kb .. tostring(k) .. ke
        local v_string = type(v) ~= 'table' and tostring(v) or table_string(v, opts)
        content = content .. indent .. k_string .. v_string
        if i < size then content = content .. sep end
    end
    return tb .. content .. te
end

function pretty(tbl)
    return table_string(tbl, options.pretty)
end

function inline(tbl)
    return table_string(tbl, options.inline)
end

local mouse = { first = 'Minnie', last = 'Mouse' }
print(pretty(mouse))
print(inline(mouse))
