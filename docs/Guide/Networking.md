---
sidebar_position: 5
---

# Networking

Lets have a look at setting up networking. Toasty's networking system is currently bundled with Toasty, however in the future it may be placed in a separate package to allow users to use a different networking solution.

## Benefits

Toasty's networking comes with a couple of features that native `RemoteEvent` and `RemoteFunction`s just don't have. Here is a list of all features that Toasty brings to networking:

- `RemoteFunction`s emulated using `RemoteEvent`s
	- Allows for Unreliable `RemoteFunction` since ROBLOX doesn't have those
- Calling `RemoteFunction`s returns a promise instead of blocking

## Setting up

To get started you need to create a module script which describes the structure of your networking. This should be placed somewhere in `ReplicatedStorage` to allow both the Server and Client to access it.

```lua
-- ReplicatedStorage/Network.luau
local Toasty = require(path.to.Toasty)
local Net = Toasty.Networking -- Shorthand; not required

return {
	MyEvent = Net.Event();

	NestedStuff = {
		NestedFunction = Net.Function();
	}
}
```

We now need to tell toasty to actually create these events and setup everything for them. Lets go back to out Loader script:

```lua
-- Require --
local Toasty = require(path.to.toasty)

-- Config --
--[[
	This is where configs like Feature Flags will go
]]

-- Networking --
Toasty.Networking.Setup(path.to.Network) -- This should be the actual ModuleScript!

-- Loading --
-- Now we can load our actual modules
Toasty.Bootstrap.LoadSingletonModules(script.Parent.Services, true)
--[[
	When using LoadSingletonModules, Toasty automatically handles creating and registering
	singletons. This means all your modules should return singletons, if not, please
	restructure or call Toasty.Service or Toasty.Controller in every module. Before
	returning
]]

-- Toast --
-- Toasting is the same as calling Knit.Start(). It kicks off all singleton's OnStart and OnInit lifecycle (more info on that later)
Toasty.Bootstrap.Toast()
```

Now our networking is setup and ready. This should be done *before* loading singletons and *after* setting config flags (explained next page).

Using this networking module is self explanatory so I wont go into it here. However you can refer to the API docs to get the specifics. However here are some key things to keep in mind.

- The events/functions have a `.Client` and `.Server` API, you need to use the correct API depending on where you are using the event from. E.g. on the server use the `.Server` API and on the client use the `.Client` API
- The server cannot fire `RemoteFunction`s, I wont go into details here but the server should never get information from the client because the server should **never** trust from the client.
- The first argument when setting callbacks or firing remote functions is a table of type check functions to runtime-type-check networking, you can pass t.* into here or you can use `Toasty.Networking.Args.*`