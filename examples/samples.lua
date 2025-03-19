-----------------------------------------------------------------------------------------------------------------------
-- scribe: Sample tables used in some test and example scripts.
--
-- Full Documentation:     https://nessan.github.io/scribe
-- Source Repository:      https://github.com/nessan/scribe
-- SPDX-FileCopyrightText: 2025 Nessan Fitzmaurice <nessan.fitzmaurice@me.com>
-- SPDX-License-Identifier: MIT
-----------------------------------------------------------------------------------------------------------------------

local M = {}

-----------------------------------------------------------------------------------------------------------------------
-- A sample configuration table.
-----------------------------------------------------------------------------------------------------------------------
local config_settings = {
    app_name        = "Magic-App",
    max_connections = 1001,
    debugging       = false,
    log_file        = nil,
    on_launch       = function() print("App launching...") end,
    background_task = coroutine.create(function() end),
    log_file_handle = io.open(os.tmpname(), "r"),
    languages       = { "English", "Spanish", "French", "German" },
    features        = {
        authentication = { oauth = true, saml = false },
        default_UI     = { darkMode = true, font_size = "medium" }
    }
}
M.config_settings =
{
    name = 'config_settings',
    value = config_settings
}

-----------------------------------------------------------------------------------------------------------------------
-- A sample table with a circular reference.
-----------------------------------------------------------------------------------------------------------------------
local graph_node = {}
graph_node.connections = { graph_node }
graph_node.metadata = { node_name = "Node1", node_type = "Root" }
local project_dependencies = {
    root = graph_node,
    dependency_graph = {
        root = graph_node,
        nodes = {
            { name = "Node2", links_to = graph_node },
            { name = "Node3", links_to = { graph_node } }
        }
    }
}
graph_node.project = project_dependencies
M.graph_node =
{
    name = "graph_node",
    value = graph_node
}

-----------------------------------------------------------------------------------------------------------------------
-- A mini version of a "typical" user profile.
-----------------------------------------------------------------------------------------------------------------------
local user_profile = {
    name        = "bill",
    friends     = { "tom", "dick", "harry" },
    session     = coroutine.create(function() end),
    preferences = {
        notifications = "enabled",
        privacy = {
            share_location = false,
            online_status  = "invisible"
        }
    }
}
M.user_profile =
{
    name = "user_profile",
    value = user_profile
}

-----------------------------------------------------------------------------------------------------------------------
-- A table that uses the user profile with a cycle.
-----------------------------------------------------------------------------------------------------------------------
local user_session = {
    user = user_profile,
    preferences = user_profile.preferences
}
M.user_session =
{
    name = "user_session",
    value = user_session
}

-----------------------------------------------------------------------------------------------------------------------
-- A linked list with a spurious self-reference.
-----------------------------------------------------------------------------------------------------------------------
local a = { node = 'Thomas', payload = 10 }
local b = { node = 'Harold', payload = 20 }
local c = { node = 'Sloane', payload = 30 }
local d = { node = 'Daphne', payload = 40 }

-- Make the head of the list point to itself and ditto for the tail.
a.next, b.next, c.next, d.next = b, c, d, d
a.prev, b.prev, c.prev, d.prev = a, a, b, c
local linked_list = { a, b, c, d }
linked_list.head = a
linked_list.tail = d

-- Add a spurious self reference.
linked_list.all = linked_list

M.linked_list =
{
    name = "linked_list",
    value = linked_list
}

return M
