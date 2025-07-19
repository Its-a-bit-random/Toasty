# Lifecycle

Lifecycle events allow you to listen in to certain events from Toasty or by creating your own.

## Hooking into lifecycle events

To hook into a lifecycle event we need to tell Toasty what lifecycle events we would like to have on the service. We can do this by passing an `Implements` table into the options with the names of the lifecycles we want to have. E.g:

```luau
local Toasty = require(path.to.Toasty)

local myAwesomeService = Toasty.Service({
	Implements = { "OnStart" }
})

--[[
	Lifecycles need to have a function with the same name
	to call when that event goes off.
]]
function myAwesomeService:OnStart()
	print("Hello World!")
end
```

## Toasty provided events

### OnStart

`OnStart` is called when you call the `Toasty.Bootstrap.Toast()` function. E.g:

```luau

local Toasty = require(path.to.Toasty)

local myAwesomeService = Toasty.Service({
	Implements = { "OnStart" }
})

--[[
	Every lifecycle even needs a function with the same name that is called when
	the event happens
]]
function myAwesomeService:OnStart()
	print("Hello World!")
end

Toasty.Bootstrap.Toast() -- would print "Hello World!"
```

### OnInit

`OnInit` is called when you call the `Toasty.Bootstrap.Toast()` function but before the `OnStart` lifecycle. E.g:

```luau

local Toasty = require(path.to.Toasty)

local myAwesomeService = Toasty.Service({
	Implements = { "OnInit", "OnStart" }
})

function myAwesomeService:OnStart()
	print("Start")
end

function myAwesomeService:OnInit()
	print("Init")
end

Toasty.Bootstrap.Toast() -- would print "Init" then "Start"
```

## Creating Your own

!!!warning
	Dispatch **HAS** to be called with dot notation and not with a `:`.
	```luau
		onHeartbeatLifecycle.Dispatch(dt) -- ✅ Works as intented
		onHeartbeatLifecycle:Dispatch(dt) -- ❌ Error
	```

You can create your own lifecycle events that get fired whenever you would like and do whatever you like. Here is a basic example of an `OnHeartbeat` lifecycle event which also passes the `deltaTime` with it.

```luau
local RunService = game:GetService("RunService")
local Toasty = require(path.to.Toasty)

--[[
	This returns a table with a single function to dispatch this lifecycle
]]
local onHeartbeatLifecycle = Toasty.Lifecycle.Create("OnHeartbeat")

RunService.Heartbeat:Connect(function(dt: number)
	--[[
		Dispatch our event with the DeltaTime passed along
	]]
	onHeartbeatLifecycle.Dispatch(dt)
end)

-- MyService.luau
local Toasty = require(path.to.Toasty)

local myAwesomeService = Toasty.Service({
	Implements = { "OnHeartbeat" }
})

function myAwesomeService:OnHeartbeat(dt: number)
	print(dt)
end
```