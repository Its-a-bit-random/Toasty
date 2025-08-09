---
sidebar_position: 1
---

# Singletons

A singleton can be considered a `Service` (server) or `Controller` (client). Singletons are the backbone of Toasty, they are where most of your game logic will be. This page goes over the basics of creating a singleton and how they work!

## Creating a singleton

```lua
local Toasty = require(path.to.Toasty)

-- Server
local myAwesomeService = {}

Toasty.Service(myAwesomeService)
return myAwesomeService

-- Client
local myAwesomeController = {}

Toasty.Controller(myAwesomeController)
return myAwesomeController
```

Yep, that's all you need to do to create a singleton, from here you can hook into Lifecycles. The empty table passed is a options table which can be used to configure the singleton like implementing lifecycle.

:::tip
Although you can create singletons via Toasty it is recommended you do not, and do what above does and define your singleton, then pass it to Toasty via `Service` or `Controller`.
:::

## Lifecycle

We can implement lifecycle events by passing the name into the `Implements` table within the options table with all the lifecycle events we would like to get on this service. Learn more [here](Lifecycle.md)

```lua
local Toasty = require(path.to.Toasty)

local myAwesomeService = {
	Implements = { "OnStart" }
}

function myAwesomeService:OnStart()
	print("Hello World!")
end

Toasty.Service(myAwesomeService)
return myAwesomeService
```