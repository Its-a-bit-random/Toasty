---
sidebar_position: 3
---

# Dependencies

:::warning
Using Toasty’s dependency system is optional, but highly recommended.  
It ensures your modules load in the correct order and can greatly improve project stability.
:::

Assuming you decide to use the dependency system you should almost never use the `OnInit` lifecycle because all singletons should be started in the correct order.

In simple terms, lets say you have `ServiceA` and `ServiceB`. And `ServiceB` needs to use a function from `ServiceA`. Toasty will then go on to call `OnInit` and `OnStart` to all singletons however since `ServiceB` depends on `ServiceA`, Toasty will always call `OnInit` on `ServiceA` before `ServiceB`. And same with `OnStart`, it will call `OnStart` on `ServiceA` before `ServiceB`

(Hopefully that is explained well :P)

## Defining Dependencies

With all that talk out of the way, how do we actually tell Toasty what our singletons depend on? It's very simple, have a look below:

```lua
-- ServiceA.luau
local Toasty = require(path.to.toasty)

local ServiceA = {
	Implements = { "OnStart" }
}

function ServiceA:SayHello()
	print("Hello from service a")
end

function ServiceA:OnStart()
	print("ServiceA::OnStart")
end

Toasty.Service(ServiceA)
return ServiceA
```
```lua
-- ServiceB.luau
local Toasty = require(path.to.toasty)
local ServiceA = require(path.to.ServiceA)

local ServiceB = {
	Implements = { "OnStart" },
	Dependencies = { ServiceA }, -- Tell toasty that this service depends on ServiceA
}

function ServiceB:OnStart()
	print("ServiceB::OnStart")
	ServiceA:SayHello()
end

Toasty.Service(ServiceB)
return ServiceB
```

If you ran this, you would see that the output would look something like this:
```txt
ServiceA::OnStart
ServiceB::OnStart
Hello from service a
```

:::note
Keep in mind that still, **all** `OnInit` functions are called before any `OnStart` functions are called!
:::