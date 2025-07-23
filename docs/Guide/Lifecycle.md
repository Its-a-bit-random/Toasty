---
sidebar_position: 2
---

# Lifecycle

Lifecycle events allow you to listen in to certain events from Toasty or by creating your own.

## Hooking into lifecycle events

To hook into a lifecycle event we need to tell Toasty what lifecycle events we would like to have on the service. We can do this by passing an `Implements` table into the options with the names of the lifecycles we want to have. E.g:

```lua
local Toasty = require(path.to.Toasty)

local myAwesomeService = {
	Implements = { "OnStart" }
}

--[[
	Lifecycles need to have a function with the same name
	to call when that event goes off.
]]
function myAwesomeService:OnStart()
	print("Hello World!")
end

Toasty.Service(myAwesomeService)
return myAwesomeService
```

## Toasty provided events

### OnStart

`OnStart` is called when you call the `Toasty.Bootstrap.Toast()` function. E.g:

```lua
-- MyAwesomeService.luau
local Toasty = require(path.to.Toasty)

local myAwesomeService = {
	Implements = { "OnStart" }
}

function myAwesomeService:OnStart()
	print("Hello World!")
end

Toasty.Service(myAwesomeService)
return myAwesomeService

-- Runtime.server.luau
Toasty.Bootstrap.Toast() -- would print "Hello World!"
```

### OnInit

:::warning
You should not use OnInit unless you need to use the behavior that it has. Yielding in OnInit will delay calling Init/Start on all other singletons.
:::

`OnInit` is called when you call the `Toasty.Bootstrap.Toast()` function but before the `OnStart` lifecycle. E.g:

```lua
-- MyAwesomeService.luau
local Toasty = require(path.to.Toasty)

local myAwesomeService = {
	Implements = { "OnInit", "OnStart" }
}

function myAwesomeService:OnStart()
	print("Start")
end

function myAwesomeService:OnInit()
	print("Init")
end

Toasty.Service(myAwesomeService)
return myAwesomeService

-- Runtime.server.luau
Toasty.Bootstrap.Toast() -- would print "Init" then "Start"
```

## Creating Your own

You can create your own lifecycle events that get fired whenever you would like and do whatever you like. Here is a basic example of an `OnHeartbeat` lifecycle event which also passes the `deltaTime` with it.

```lua
local RunService = game:GetService("RunService")
local Toasty = require(path.to.Toasty)

-- Create our lifecycle
local onHeartbeatLifecycle = Toasty.Lifecycle.Create("OnHeartbeat")

RunService.Heartbeat:Connect(function(dt: number)
	-- Dispatch lifecycle passing in delta time
	onHeartbeatLifecycle:Dispatch(dt)
end)

-- MyService.luau
local Toasty = require(path.to.Toasty)

local myAwesomeService = {
	Implements = { "OnHeartbeat" }
}

function myAwesomeService:OnHeartbeat(dt: number)
	print(dt)
end

Toasty.Service(myAwesomeService)
return myAwesomeService
```

### Custom Handlers

By default Toasty provides you with a handler for lifecycle events which just calls the function on each singleton which implements that lifecycle event using `task.spawn`. However you may want to do it your own way or add some logging, etc. You can do this by passing a handler function when you create your lifecycle event.

This example simply calls each function without `task.spawn`, the same way that `OnInit` lifecycle works
```lua
local RunService = game:GetService("RunService")
local Toasty = require(path.to.Toasty)

local onHeartbeatLifecycle = Toasty.Lifecycle.Create("OnHeartbeat", function(singletons, name: string, ...: any)
	for _, v in singletons do
		-- Toasty makes sure the singleton has the function
		-- so its safe to assume it exists here
		local func = v[name]
		func(v, ...)
	end
end)

RunService.Heartbeat:Connect(function(dt: number)
	onHeartbeatLifecycle:Dispatch(dt)
end)

-- MyService.luau
local Toasty = require(path.to.Toasty)

local myAwesomeService = {
	Implements = { "OnHeartbeat" }
}

function myAwesomeService:OnHeartbeat(dt: number)
	print(dt)
end

Toasty.Service(myAwesomeService)
return myAwesomeService
```