---
sidebar_position: 4
---

# Networking

:::warning
As of 1.0.0, toasty sends 12 bytes (a string) with every remote call, this will be eventually removed.
:::

## Theory

Toasty only uses Remote events under the hood. This is because Roblox does not have a `UnreliableRemoteFunction`, sicne Toasty networking supports this it replicated the behaviour of `RemoteFunctions` using `RemoteEvents`. This is similar to how Flamework handles remote functions but the implementation may not be the same.

## Getting Started

You first need to create your `Networking` module. This is where you define all your events and functions. Here is an example:

```lua
-- Shared/Networking.luau
local Toasty = require(path.to.toasty)
local Net = Toasty.Networking -- Just a shorthand; not required

return {
	-- Here we define a simple event
	MyEvent = Net.Event(),

	-- And a function
	MyFunction = Net.Function(),

	-- You can create namespaces by just adding a table
	MyNamespace = {
		MyNamespacedFunction = Net.Function(),
	}
}
```

Once your networking module is ready you need to set it up on **both** the client and the server:

```lua
-- Server/Main.server.luau
local Toasty = require(path.to.toasty)
Toasty.Networking.Setup(path.to.networking)

-- Client/Main.client.luau
local Toasty = require(path.to.toasty)
Toasty.Networking.Setup(path.to.networking)
```

From here to use networking events you can simply require the networking module and access all the events and functions as you would expect.

:::tip
`SetCallback` and `Fire` (Fire only applies to client firing functions to server) take in an `expects` table which can type check things for you. This is done like this to hide types for clients. It is recommended you use `t` or `Toasty.Networking.Arg.*` however you can create your own.
:::