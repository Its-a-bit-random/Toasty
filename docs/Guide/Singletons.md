---
sidebar_position: 1
---

# Singletons

A singleton can be considered a `Service` (server) or `Controller` (client). Singletons are the backbone of Toasty, they are where most of your game logic will be. This page goes over the basics of creating a singleton and how they work!

## Creating a singleton

```lua
local Toasty = require(path.to.Toasty)

-- Server
local myAwesomeService = Toasty.Service({})

-- Client
local myAwesomeService = Toasty.Controller({})
```

Yep, that's all you need to do to create a singleton, from here you can hook into Lifecycles. The empty table passed is a options table which can be used to configure the singleton like implementing lifecycle.

## Lifecycle

We can implement lifecycle events by passing the name into the `Implements` table within the options table with all the lifecycle events we would like to get on this service. Learn more [here](Lifecycle.md)

```lua
local Toasty = require(path.to.Toasty)

local myAwesomeService = Toasty.Service({
	Implements = { "OnStart" }
})

function myAwesomeService:OnStart()
	print("Hello World!")
end
```