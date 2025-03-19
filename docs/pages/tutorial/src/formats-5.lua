-----------------------------------------------------------------------------------------------------------------------
-- Scribe Tutorial: Fixed JSON formatting by adding the `simple_string` function.
--
-- Full Documentation:      https://nessan.github.io/scribe
-- Source Repository:       https://github.com/nessan/scribe
-- SPDX-FileCopyrightText:  2025 Nessan Fitzmaurice <nessan.fitzmaurice@me.com>
-- SPDX-License-Identifier: MIT
-----------------------------------------------------------------------------------------------------------------------

local function simple_string(obj)
    if obj == nil then return 'nil' end
    local obj_type = type(obj)
    if obj_type == 'number' or obj_type == 'boolean' or obj_type == nil then
        return tostring(obj)
    elseif obj_type == 'string' then
        return string.format("%q", obj)
    elseif obj_type == 'table' then
        return string.format("%p", obj)
    elseif obj_type == 'function' then
        return '<function>'
    elseif obj_type == 'userdata' then
        return '<userdata>'
    elseif obj_type == 'thread' then
        return '<thread>'
    else
        return '<UNKNOWN type: ' .. tostring(obj) .. '>'
    end
end

local function indent_string(str, indent, ignore_first_line)
    ignore_first_line = ignore_first_line or false
    if not indent or indent == "" or not str or str == "" then return str end
    local ends_with_newline = str:sub(-1) == "\n"
    local indented_str = ""
    local first_line = true
    for line in str:gmatch("([^\n]*)\n?") do
        if not first_line then indented_str = indented_str .. '\n' end
        local tab = first_line and ignore_first_line and '' or indent
        indented_str = indented_str .. tab .. line
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

options.alt = table_clone(options.pretty)
options.alt.table_begin = ''
options.alt.table_end = ''
options.alt.array_begin = ''
options.alt.array_end = ''
options.alt.key_end = ': '

options.json = table_clone(options.pretty)
options.json.key_begin = '"'
options.json.key_end = '": '

options.inline_json = table_clone(options.json)
options.inline_json.indent = ''
options.inline_json.key_end = '":'
options.inline_json.inline_spacer = ''

local function empty_table_string(opts)
    local retval = (opts.table_begin .. opts.table_end):gsub('%s+', '')
    return retval
end

local function metadata(tbl)
    local size = 0
    local array = true
    for _, _ in pairs(tbl) do
        size = size + 1
        if array and tbl[size] == nil then array = false end
    end
    return size, array
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
    local delims = tb ~= ''

    sep = sep .. nl
    if delims then tb, te = tb .. nl, nl .. te else indent = '' end

    local content = ''
    local i = 0
    for k, v in pairs(tbl) do
        i = i + 1
        local k_string = show_keys and kb .. tostring(k) .. ke or ''
        local v_string = ''
        if type(v) == 'table' then
            v_string = table_string(v, opts)
            v_string = indent_string(v_string, opts.indent, delims)
            if delims == false and show_keys then v_string = nl .. v_string end
        else
            v_string = simple_string(v)
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

function alt(tbl)
    return table_string(tbl, options.alt)
end

function json(tbl)
    return table_string(tbl, options.json)
end

function inline_json(tbl)
    return table_string(tbl, options.inline_json)
end

function debug(tbl)
    return table_string(tbl, options.debug)
end

local user =
{
    first = "Minnie",
    last = "Mouse",
    friends = { "Mickey", "Goofy" } -- <1>
}
print(json(user))
print(inline_json(user))


local stars =
{
    c1 = { first = "Mickey", last = "Mouse" },
    c2 = { first = "Minnie", last = "Mouse" },
}
stars.c1.next = stars.c2
-- stars.c2.prev = stars.c1
print(pretty(stars))
