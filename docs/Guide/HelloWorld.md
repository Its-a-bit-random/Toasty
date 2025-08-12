---
sidebar_position: 2
---

# Hello World

Lets now write your very own Starter script. You will need to create one for both the client and server. This will only cover the server side but the client side is pretty much identical.

Keep in mind that a "Singleton" is a way of saying "Service" or "Controller" since they are the same with just a different name on the Server and Client.

```lua
-- Require --
local Toasty = require(path.to.toasty)

-- Config --
--[[
	This is where configs like Feature Flags will go
]]

-- Networking --
--[[
	This will be covered later when we go over networking
]]

-- Loading --
-- Now we can load our actual modules
Toasty.Bootstrap.LoadSingletonModules(script.Parent.Services, true)
--[[
	When using LoadSingletonModules, Toasty automatically handles creating and registering
	singletons. This means all your modules should return singletons, if not, please
	restrucutre or call Toasty.Service or Toasty.Controller in every module. Before
	returning
]]

-- Toast --
-- Toasting is the same as calling Knit.Start(). It kicks off all singleton's OnStart and OnInit lifecycles (more info on that later)
Toasty.Bootstrap.Toast()
```

Now to create our actual Service. Create a folder next to your loader server script called "Services" and create a module script inside.

```lua
-- Services/MyService.luau
local MyFirstService = {
	Implements = { "OnStart" };
}

function MyFirstService:OnStart()
	print("Hello World!")
end

return MyFirstService
```

Ignore the implements table for now as we will go into Life-cycles in the next page. However running this you will get Hello World printing in console.

Now its your turn, try doing the setup for the client and see if you can get that to print hello world too. Heads up though, on the client services are called Controllers!