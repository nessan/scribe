-----------------------------------------------------------------------------------------------------------------------
-- Scribe Tutorial: Sample tables we test our evolving code against.
--
-- To load this file you must first set Lua's `package.path` to include the directory containing this file.
-- The following magic code snippet will grab the current working directory and add it to the package path:
--
--     local cwd = debug.getinfo(1, 'S').source:match [[^@?(.*[\/])[^\/]-$]]
--     package.path = cwd .. "?.lua;"  .. package.path
--     require("samples")
--
-- Full Documentation:      https://nessan.github.io/scribe
-- Source Repository:       https://github.com/nessan/scribe
-- SPDX-FileCopyrightText:  2025 Nessan Fitzmaurice <nessan.fitzmaurice@me.com>
-- SPDX-License-Identifier: MIT
-----------------------------------------------------------------------------------------------------------------------

-- Simple name-value table:
mouse = { first = 'Minnie', last = 'Mouse' }

-- Simple array:
friends = { 'Mickey', 'Goofy' }

-- Empty table:
empty = {}

-- Nested table:
local user =
{
    first = "Minnie",
    last = "Mouse",
    friends = { "Mickey", "Goofy" }
}

-- Nested array:
matrix = {
    { 1, 2, 3 },
    { 4, 5, 6 },
    { 7, 8, 9 }
}

-- Linked list table:
local stars_v1 =
{
    c1 = { first = "Mickey", last = "Mouse" },
    c2 = { first = "Minnie", last = "Mouse" },
}
stars_v1.c1.next = stars_v1.c2

-- Linked list table with a cycle:
local stars_v2 =
{
    c1 = { first = "Mickey", last = "Mouse" },
    c2 = { first = "Minnie", last = "Mouse" },
}
stars_v2.c1.next = stars_v2.c2
stars_v2.c2.next = stars_v2.c1

-- Linked list table with a cycle and a self-reference:
local stars =
{
    c1 = { first = "Mickey", last = "Mouse" },
    c2 = { first = "Minnie", last = "Mouse" },
}
stars.c1.next = stars.c2
stars.c2.next = stars.c1
stars.home = stars

-- Linked list array:
local rooms = {
    { name = "Library", weapon = "Lead Pipe" },
    { name = "Kitchen", weapon = "Knife"     },
    { name = "Lounge",  weapon = "Poison"    },
    { name = "Bedroom", weapon = "Garrotte"  }
}
rooms[1].next, rooms[2].next, rooms[3].next, rooms[4].next = rooms[2], rooms[3], rooms[4], rooms[1]
rooms[1].prev, rooms[2].prev, rooms[3].prev, rooms[4].prev = rooms[4], rooms[1], rooms[2], rooms[3]
