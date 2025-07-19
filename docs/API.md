# API Reference

## Toasty.Service

Create a new service which is a plain Singleton, this can either be used on the Server or Client but its recommended to **use on the server** for clear separation.

```luau
local Toasty = require(path.to.Toasty)

local myAwesomeService = Toasty.Service({
	Implements = { "OnStart" }
})

function myAwesomeService:OnStart()
	print("Hello World!")
end
```

## Toasty.Controller

Create a new controller which is a plain Singleton, this can either be used on the Server or Client but its recommended to **use on the client** for clear separation.

```luau
local Toasty = require(path.to.Toasty)

local myAwesomeController = Toasty.Controller({
	Implements = { "OnStart" }
})

function myAwesomeController:OnStart()
	print("Hello World!")
end
```

## Toasty.Lifecycle.Create

Create a new lifecycle event that can be dispatched whenever with whatever args you would like, that any singleton can hook into.


!!!warning
	Dispatch **HAS** to be called with dot notation and not with a `:`.
	```luau
		myLifecycleEvent.Dispatch(dt) -- ✅ Works as intented
		myLifecycleEvent:Dispatch(dt) -- ❌ Error
	```

```luau
local RunService = game:GetService("RunService")
local Toasty = require(path.to.Toasty)

local onHeartbeatLifecycle = Toasty.Lifecycle.Create("OnHeartbeat")

RunService.Heartbeat:Connect(function(dt: number)
	onHeartbeatLifecycle.Dispatch(dt)
end)
```

## Toasty.Bootstrap.LoadModules

Takes in an instance and calls `Require` on all the modules within it.

## Toasty.Bootstrap.Toast

Launches the `OnInit` & `OnStart` lifecycle events.