-----------------------------------------------------------------------------------------------------------------------
-- Scribe Tutorial: Indent sub-tables.
--
-- Full Documentation:      https://nessan.github.io/scribe
-- Source Repository:       https://github.com/nessan/scribe
-- SPDX-FileCopyrightText:  2025 Nessan Fitzmaurice <nessan.fitzmaurice@me.com>
-- SPDX-License-Identifier: MIT
-----------------------------------------------------------------------------------------------------------------------

local function indent_string(str, indent)
    if not indent or indent == "" or not str or str == "" then return str end
    local ends_with_newline = str:sub(-1) == "\n"
    local indented_str = ""
    local first_line = true
    for line in str:gmatch("([^\n]*)\n?") do
        if not first_line then indented_str = indented_str .. "\n" end
        indented_str = indented_str .. indent .. line
        first_line = false
    end
    if ends_with_newline then indented_str = indented_str .. "\n" end
    return indented_str
end

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
    array_begin   = '[',
    array_end     = ']',
    key_begin     = '',
    key_end       = ' = ',
    sep           = ',',
    inline_spacer = ' ',
    show_indices  = false
}

options.inline = table_clone(options.pretty)
options.inline.indent = ''

options.classic = table_clone(options.pretty)
options.classic.array_begin = '{'
options.classic.array_end = '}'

local function empty_table_string(opts)
    local retval = (opts.table_begin .. opts.table_end):gsub('%s+', '')
    return retval
end

local function metadata(tbl)
    local size = 0
    local array = true -- <1>
    for _, _ in pairs(tbl) do
        size = size + 1
        if array and tbl[size] == nil then array = false end -- <2>
    end
    return size, array                                       -- <3>
end

function table_string(tbl, opts)
    opts = opts or options.pretty

    local size, array = metadata(tbl)
    if size == 0 then return empty_table_string(opts) end
    local show_keys = not array and true or opts.show_indices

    local tb = array and opts.array_begin or opts.table_begin
    local te = array and opts.array_end or opts.table_end
    local kb, ke = opts.key_begin, opts.key_end
    local sep = opts.sep
    local indent = opts.indent

    local nl = indent == '' and opts.inline_spacer or '\n'
    sep = sep .. nl
    tb = tb .. nl
    te = nl .. te

    local content = ''
    local i = 0
    for k, v in pairs(tbl) do
        i = i + 1
        local k_string = show_keys and kb .. tostring(k) .. ke or ''
        local v_string = ''
        if type(v) == 'table' then
            v_string = table_string(v, opts)
            v_string = indent_string(v_string, indent)
        else
            v_string = tostring(v)
        end
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

function classic(tbl)
    return table_string(tbl, options.classic)
end

local user =
{
    first = "Minnie",
    last = "Mouse",
    friends = { "Mickey", "Goofy" } -- <1>
}
print(pretty(user))
print(inline(user))
