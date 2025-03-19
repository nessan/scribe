-----------------------------------------------------------------------------------------------------------------------
-- Scribe Tutorial: Make a module
--
-- Full Documentation:      https://nessan.github.io/scribe
-- Source Repository:       https://github.com/nessan/scribe
-- SPDX-FileCopyrightText:  2025 Nessan Fitzmaurice <nessan.fitzmaurice@me.com>
-- SPDX-License-Identifier: MIT
-----------------------------------------------------------------------------------------------------------------------

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

local function empty_table_string(opts)
    local retval = (opts.table_begin .. opts.table_end):gsub('%s+', '')
    return retval
end

local function metadata(root_tbl)
    local md = {}
    md[root_tbl] = { refs = 1 }

    local function process(tbl)
        local size, array, subs = 0, true, 0
        local children = {}
        for _, v in pairs(tbl) do
            size = size + 1
            if array and tbl[size] == nil then array = false end
            if type(v) == 'table' then
                if md[v] then
                    md[v].refs = md[v].refs + 1
                else
                    subs = subs + 1
                    table.insert(children, v)
                    md[v] = { refs = 1 }
                end
            end
        end
        md[tbl].size, md[tbl].array, md[tbl].subs = size, array, subs
        for _, child in ipairs(children) do process(child) end
    end

    process(root_tbl)
    return md
end

local function table_string(root_tbl, opts)
    local md = metadata(root_tbl)

    local kb, ke = opts.key_begin, opts.key_end
    local pb, pe = opts.path_begin, opts.path_end

    local function process(tbl, path)
        if opts.use_metatable then
            local mt = getmetatable(tbl)
            if mt and mt.__tostring then return mt.__tostring(tbl) end
        end

        md[tbl].path = path
        local path_prefix = path == opts.path_root and '' or path .. opts.path_sep

        local size = md[tbl].size
        if size == 0 then return empty_table_string(opts) end

        local array = md[tbl].array
        local show_keys = not array and true or opts.show_indices

        local simple = md[tbl].subs == 0 and size < opts.inline_size
        local indent = simple and '' or opts.indent

        local tb = array and opts.array_begin or opts.table_begin
        local te = array and opts.array_end or opts.table_end
        local nl = indent == '' and opts.inline_spacer or '\n'
        local sep = opts.sep .. nl

        local delims = tb ~= ''
        if delims then tb, te = tb .. nl, nl .. te else indent = '' end

        local children = {}
        local content = ''
        local i = 0
        local iter = array and ipairs or ordered_pairs(opts.comparator)
        for k, v in iter(tbl) do
            i = i + 1
            local show_key = show_keys -- <1>
            local v_string = ''
            if type(v) == 'table' then
                if md[v].path then
                    v_string = pb .. md[v].path .. pe
                else
                    if md[v].refs > 1 then show_key = true end -- <2>
                    local v_path = path_prefix .. tostring(k)
                    v_string = simple_string(v)
                    md[v].path = v_path
                    children[v] = v_path
                    if delims == false and show_key then v_string = nl .. v_string end
                end
            else
                v_string = v_string .. simple_string(v)
            end
            local k_string = show_key and kb .. tostring(k) .. ke or '' -- <3>
            content = content .. indent .. k_string .. v_string
            if i < size then content = content .. sep end
        end
        local retval = tb .. content .. te

        for child_table, child_path in pairs(children) do
            local child_string = process(child_table, child_path)
            child_string = indent_string(child_string, opts.indent, delims)
            retval = retval:gsub(simple_string(child_table), child_string)
        end
        return retval
    end

    local retval = process(root_tbl, opts.path_root)
    if md[root_tbl].refs > 1 then
        retval = pb .. opts.path_root .. pe .. ' = ' .. retval
    end
    return retval
end

local function table_clone(tbl)
    local retval = {}
    for k, v in pairs(tbl) do retval[k] = v end
    return retval
end

local function complete_options_table(options, from)
    for k, v in pairs(from) do
        if options[k] == nil then options[k] = v end
    end
end

-----------------------------------------------------------------------------------------------------------------------
--- The public API as a module.
-----------------------------------------------------------------------------------------------------------------------
local M = {}
M.options = {}

M.options.pretty = {
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
    inline_size   = math.huge,
    path_root     = 'table',
    path_sep      = '.',
    path_begin    = '<',
    path_end      = '>',
    use_metatable = true,
    COMPLETE      = true
}

M.options.inline = table_clone(M.options.pretty)
M.options.inline.indent = ''

M.options.classic = table_clone(M.options.pretty)
M.options.classic.array_begin = '{'
M.options.classic.array_end = '}'
M.options.classic.inline_size = 0

M.options.alt = table_clone(M.options.pretty)
M.options.alt.table_begin = ''
M.options.alt.table_end = ''
M.options.alt.array_begin = ''
M.options.alt.array_end = ''
M.options.alt.key_end = ': '
M.options.alt.inline_size = 0

M.options.json = table_clone(M.options.pretty)
M.options.json.key_begin = '"'
M.options.json.key_end = '": '
M.options.json.inline_size = 0

M.options.inline_json = table_clone(M.options.json)
M.options.inline_json.indent = ''
M.options.inline_json.key_end = '":'
M.options.inline_json.inline_spacer = ''

M.options.debug = table_clone(M.options.pretty)
M.options.debug.indent = ' INDENT '
M.options.debug.table_begin = 'TABLE_BEGIN'
M.options.debug.table_end = 'TABLE_END'
M.options.debug.array_begin = 'ARRAY_BEGIN'
M.options.debug.array_end = 'ARRAY_END'
M.options.debug.key_begin = ' KEY_BEGIN "'
M.options.debug.key_end = '" KEY_END = '
M.options.debug.sep = ' SEP '
M.options.debug.show_indices = true
M.options.debug.inline_size = 0

M.options.default = M.options.inline

function M.scribe(obj, opts, overrides)
    if type(obj) ~= 'table' then return simple_string(obj) end

    if opts == nil then return table_string(obj, M.options.default) end

    if not opts.COMPLETE then
        local from = opts.indent == '' and M.options.inline or M.options.pretty
        complete_options_table(opts, from)
    end
    if overrides == nil then return table_string(obj, opts) end

    if not overrides.COMPLETE then complete_options_table(overrides, opts) end
    return table_string(obj, overrides)
end

function M.pretty(tbl, overrides)
    return M.scribe(tbl, M.options.pretty, overrides)
end

function M.inline(tbl, overrides)
    return M.scribe(tbl, M.options.inline, overrides)
end

function M.classic(tbl, overrides)
    return M.scribe(tbl, M.options.classic, overrides)
end

function M.alt(tbl, overrides)
    return M.scribe(tbl, M.options.alt, overrides)
end

function M.json(tbl, overrides)
    return M.scribe(tbl, M.options.json, overrides)
end

function M.inline_json(tbl, overrides)
    return M.scribe(tbl, M.options.inline_json, overrides)
end

function M.debug(tbl, overrides)
    return M.scribe(tbl, M.options.debug, overrides)
end

-- return M

local user =
{
    first = "Minnie",
    last = "Mouse",
    friends = { "Mickey", "Goofy" }
}
print(M.classic(user))
print(M.classic({ a = 1, b = 2 }))
