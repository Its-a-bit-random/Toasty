---
sidebar_position: 4
---

# Networking

Toasty comes with a networking system. Currently it only wraps around the normal remote events and remote functions provided by Roblox with minimally more features however it will soon be expanded for middleware and automatic type checking.

## Getting Started

:::warning
Networking is subject to breaking changes constantly pre-1.0.0
:::

You first need to create your `Networking` module. This is where you define all your events and functions. Here is an example:

```lua
-- Shared/Networking.luau
local Toasty = require(path.to.toasty)
local Net = Toasty.Networking -- Just a shorthand; not required

return {
	-- Here we define a simple event
	MyEvent = Net.CreateEvent(),
	

	-- And a function
	MyFunction = Net.CreateFunction(),

	-- You can create namespaces by just adding a table
	MyNamespace = {
		MyNamespacedFunction = Net.CreateFunction(),
	}
}
```

Once your networking module is ready you need to load it via toasty on **both** the client and the server:

```lua
-- Server/Main.server.luau
local Toasty = require(path.to.toasty)
Toasty.Networking.SetupFromModule(path.to.networking)

-- Client/Main.client.luau
local Toasty = require(path.to.toasty)
Toasty.Networking.SetupFromModule(path.to.networking)
```

From here to use networking events you can simply require the networking module and access all the events and functions as you would expect.

:::tip
`SetCallback` and `Fire` (Fire only applies to client firing functions to server) take in an `expects` table which can type check things for you. This is done like this to hide types for clients. It is recommended you use `t` or `Toasty.Networking.Arg.*` however you can create your own.
:::