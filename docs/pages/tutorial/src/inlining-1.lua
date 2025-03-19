-----------------------------------------------------------------------------------------------------------------------
-- Scribe Tutorial: Inline "simple" tables.
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

local function compare(a, b)
    local ta, tb = type(a), type(b)
    if ta ~= tb then
        return ta < tb
    elseif ta == 'table' or ta == 'boolean' or ta == 'function' then
        return tostring(a) < tostring(b)
    else
        return a < b
    end
end

local function ordered_pairs(comparator)
    if comparator == false then return pairs end
    comparator = comparator or compare
    return function(tbl)
        local keys = {}
        for k, _ in pairs(tbl) do table.insert(keys, k) end
        table.sort(keys, comparator)
        local i = 0
        return function()
            i = i + 1
            return keys[i], tbl[keys[i]]
        end
    end
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
    show_indices  = false,
    comparator    = compare,
    inline_size   = math.huge
}

options.inline = table_clone(options.pretty)
options.inline.indent = ''

options.classic = table_clone(options.pretty)
options.classic.array_begin = '{'
options.classic.array_end = '}'
options.classic.inline_size = 0

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

options.debug = table_clone(options.pretty)
options.debug.indent        = ' INDENT '
options.debug.table_begin   = 'TABLE_BEGIN'
options.debug.table_end     = 'TABLE_END'
options.debug.array_begin   = 'ARRAY_BEGIN'
options.debug.array_end     = 'ARRAY_END'
options.debug.key_begin     = ' KEY_BEGIN "'
options.debug.key_end       = '" KEY_END = '
options.debug.sep           = ' SEP '
options.debug.show_indices  = true
options.debug.inline_size   = 0

local function empty_table_string(opts)
    local retval = (opts.table_begin .. opts.table_end):gsub('%s+', '')
    return retval
end

local function metadata(tbl)
    local size = 0
    local array = true
    local subs = 0
    for _, v in pairs(tbl) do
        size = size + 1
        if array and tbl[size] == nil then array = false end
        if type(v) == 'table' then subs = subs + 1 end
    end
    local md = { size = size, array = array, subs = subs }
    return md
end

function table_string(tbl, opts)
    opts = opts or options.pretty

    local md = metadata(tbl)
    local size = md.size
    local array = md.array
    local simple = md.subs == 0 and size < opts.inline_size

    if size == 0 then return empty_table_string(opts) end
    local show_keys = not array and true or opts.show_indices

    local tb = array and opts.array_begin or opts.table_begin
    local te = array and opts.array_end or opts.table_end
    local kb, ke = opts.key_begin, opts.key_end
    local sep = opts.sep
    local indent = simple and '' or opts.indent
    local nl = indent == '' and opts.inline_spacer or '\n'
    local delims = tb ~= ''

    sep = sep .. nl
    if delims then tb, te = tb .. nl, nl .. te else indent = '' end

    local content = ''
    local i = 0
    local iter = array and ipairs or ordered_pairs(opts.comparator)
    for k, v in iter(tbl) do
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
print(pretty(user))
print(alt(user))

matrix = {
    { 1, 2, 3 },
    { 4, 5, 6 },
    { 7, 8, 9 }
}
print(classic(matrix))
print(pretty(matrix))
print(alt(matrix))
print(debug(matrix))
