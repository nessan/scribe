# Scribe

Scribe provides functions to convert Lua objects to readable strings and output methods that make printing Lua tables in various formats easy.

For example, if `arr = {1, 2, 3}` then `scribe.put("Array: %t", arr)` will print "Array: [ 1, 2, 3 ]" to `stdout`.

Scribe gracefully handles complex tables, including ones with shared and cyclical references.
The strings returned for those tables show the underlying structure in a way that is as readable as possible.

You can customise the strings returned for tables by passing a set of formatting options, and there are pre-defined options that will work for most applications. Those include printing tables on a single line, in a “pretty” format on multiple lines, or as JSON-like descriptors.

## Example

Suppose we have a `user_profile` table that contains a user's name and some preferences:

```lua
local user_profile = {
    name = "bill",
    preferences = {
        notifications = "enabled",
        privacy = {
            share_location = false,
            online_status  = "invisible"
        }
    },
    friends = { "tom", "dick", "harry" }
}
```

We can print the table in a readable format using `scribe.putln`:

```lua
local putln = require("scribe").putln
putln("User profile for %s:\n%T", user_profile.name, user_profile)
```

This prints to `stdout`:

```txt
User profile for bill:
{
    friends = [ "tom", "dick", "harry" ],
    name = "bill",
    preferences = {
        notifications = "enabled",
        privacy = { online_status = "invisible", share_location = false }
    }
}
```

We could instead dump the table in a JSON format with the call `putln("%J", user_profile)`, which yields:

```json
{
    "friends": ["tom", "dick", "harry"],
    "name": "bill",
    "preferences": {
        "notifications": "enabled",
        "privacy": {
            "online_status": "invisible",
            "share_location": false
        }
    }
}
```

## Installation

The module has no dependencies. Copy the single `scribe.lua` file and start using it.

## Documentation

Scribe is fully documented [here](https://nessan.github.io/scribe/).
We built the documentation site using [Quarto](https://quarto.org).

The documentation includes a [lengthy article](https://nessan.github.io/scribe/tutorial.html) describing how we built the module.
That tutorial might be a decent Lua 201 tutorial for those new to the language.

## Contact

You can contact me by email [here](mailto:nzznfitz+gh@icloud.com).

## Copyright and License

Copyright (c) 2025-present Nessan Fitzmaurice.
You can use this software under the [MIT license](https://opensource.org/license/mit).
