# Scribe

Scribe provides functions to convert Lua objects to readable strings and output methods that make printing Lua tables in various formats easy.

For example, if `arr = {1, 2, 3}` then `scribe.put("Array: %t", arr)` will print "Array: [ 1, 2, 3 ]" to `stdout`.

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

## Complex Tables

Scribe gracefully handles complex tables, including ones with shared and cyclical references. The strings returned for those tables show the underlying structure in a manner that is as readable as possible.

If you have:

```lua
local classes = {p1 = {subject = 'History', room = 401}, p2 = {subject = 'Spanish', room = 321}}
classes.p1.next = classes.p2
classes.p2.prev = classes.p1
```

Then `putln("Classes: %T", classes)` prints:

```txt
Classes: {
    p1 = { next = <p2>, room = 401, subject = "History" },
    p2 = { prev = <p1>, room = 321, subject = "Spanish" }
}
```

## Use Your Own String Methods

If your table has _custom_ `inline`, `pretty`, `classic`, `alt`, `json`, or `inline_json` methods, then `scribe.format`, and the other `scribe` output functions like `scribe.putln`, will use your methods to format the table.

For example, if you have a class with a custom `inline` method like the following:

```lua
local Pupil = {}
Pupil.__index = Pupil

function Pupil:new(name, age)
    local self = setmetatable({}, Pupil)
    self.name = name
    self.age = age
    return self
end

function Pupil:inline()
    return string.format("Pupil: %s is aged %d", self.name, self.age)
end
```

Then, that `inline` method will be used to print the table when you call on `putln`:

```lua
local pupil = Pupil:new("Mary", 12)
putln("%t", pupil)
```

Outputs:

```txt
Pupil: Mary is aged 12
```

## Installation

The module has no dependencies. Copy the single `scribe.lua` file and start using it.

Released versions will also be uploaded to the luarocks repository, so you should be able to install them using:

```bash
luarocks install scribe
```

## Documentation

Scribe is fully documented [here](https://nessan.github.io/scribe/).
We built the documentation site using [Quarto](https://quarto.org).

The documentation includes a [lengthy article](https://nessan.github.io/scribe/pages/tutorial/) describing how we built the module.
That tutorial might be a decent Lua 201 tutorial for those new to the language.

## Contact

You can contact me by email [here](mailto:nzznfitz+gh@icloud.com).

## Copyright and License

Copyright (c) 2025-present Nessan Fitzmaurice.
You can use this software under the [MIT license](https://opensource.org/license/mit).
