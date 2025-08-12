---
sidebar_position: 3
---

# Lifecycle

In the example service given in the "Hello World" page you might have noticed a table called "Implements". By default Toasty comes with OnInit and OnStart, ghis is where Toasty becomes really powerful, you can create and implement your own lifecycle functionss.

Lets create our own OnHeartbeat lifecycle and add it to our service from before.

Firstly we need to create a new service for handling our lifecycle, note this doesnt have to be a service/controller nor does it need to be created straight away. Your lifecycles can be created however, whereever and whenever you like.

```lua
-- Services/HeartbeatLifecycleService
local RunService = game:GetService("RunService")
local Toasty = require(path.to.Toasty)

local HeartbeatLifecycleService = {
	Implements = { "OnStart" }
}

function HeartbeatLifecycleService:OnStart()
	local heartbeatLifecycle = Toasty.Lifecycle.Create("OnHeartbeat")

	RunService.Heartbeat:Connect(function(deltaTime)
		heartbeatLifecycle:Dispatch(deltaTime)
	end)
end

return HeartbeatLifecycleService
```

When you create a lifecycle you pass a name, this is the name that you will pass into the `Implements` table of singletons. Anything you pass into `:Dispatch()` will also be passed to every singleton.

:::tip
You can also pass a custom function when creating a lifecycle to customise how the lifecycle is dispatched. You can see the default function [here](https://github.com/Its-a-bit-random/Toasty/blob/0a9ad5ab7a70f8db538e1934a247d8912b1a5688/Source/Core/LifecycleManager.luau#L6-L13). And you can also see OnInit and OnStart [here](https://github.com/Its-a-bit-random/Toasty/blob/0a9ad5ab7a70f8db538e1934a247d8912b1a5688/Source/Bootstrap.luau#L37-L55) since they also use custom handlers.
:::

Lets now add this to our HelloWorld service from before.

```lua
-- Services/MyService.luau
local MyFirstService = {
	Implements = { "OnStart", "OnHeartbeat" }; -- Add "OnHeartbeat" to our implements
}

--[[
	Add in the function wich gets called when the lifecycle
	is dispatched
]]
function MyFirstService:OnHeartbeat(deltaTime: number)
	print("Heartbeat, dt =", deltaTime)
end

function MyFirstService:OnStart()
	print("Hello World!")
end

return MyFirstService
```

Running this you should see that your service prints the delta time each frame.

As always you can refer to the API docs to learn more about the inner workings of Lifecycles.