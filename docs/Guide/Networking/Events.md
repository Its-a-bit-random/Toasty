---
sidebar_position: 2
---

# Events

:::warning
All event senders/receivers should be defined at the top of scripts or in OnStart lifecycle to ensure they exist in time for the Client to find them in time.
:::

Events are one-way cross-boundary communication between the server and client, currently there is no type checking on anything in networking with Toasty so you need to manually do type checking!

## Server To Client

To create a server to client event we need a `Sender` on the server and a `Receiver` on the client.

```lua
-- myScript.server.luau
local event = Toasty.Networking.ServerEventSender("MyEpicEvent", false)

-- myScript.client.luau
local event = Toasty.Networking.ClientEventReceiver("MyEpicEvent", false)
```

Notice how both events have the same name and are both not unreliable. If your event names or other parameters do not line up an error will occur.

Now to fire / connect events is really simple:
```lua
-- myScript.server.luau
local event = Toasty.Networking.ServerEventSender("MyEpicEvent", false)
event:Broadcast("Hello World!")

-- myScript.client.luau
local event = Toasty.Networking.ClientEventReceiver("MyEpicEvent", false)
event:SetCallback(function(message: string)
	print(message)
end)
```

Running this will make the Client print "Hello World!"

## Client To Server

Creating a client to server event is the same as a server to client event but the opposite way around with a `Sender` on the client and a `Receiver` on the server:

```lua
-- myScript.client.luau
local event = Toasty.Networking.ClientEventSender("MyEpicEvent", false)

-- myScript.server.luau
local event = Toasty.Networking.ServerEventReceiver("MyEpicEvent", false)
```

Once again we can fire and receive the event as so:
```lua
-- myScript.client.luau
local event = Toasty.Networking.ClientEventSender("MyEpicEvent", false)
event:Fire("Hello World!")

-- myScript.server.luau
local event = Toasty.Networking.ServerEventReceiver("MyEpicEvent", false)
event:SetCallback(function(player: Player, message: string?)
	-- Because we are getting data from a client we need to make sure that its valid
	if type(message) ~= "string" then
		return
	end

	print(message)
end)
```