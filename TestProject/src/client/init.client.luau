local Toasty = require(game:GetService("ReplicatedStorage").Packages.Toasty)

_G.__TOASTY_OBFUSCATE__ = true

local event = Toasty.Networking.ClientEventReceiver("John", false)
local clientEvent = Toasty.Networking.ClientEventSender("JohnClient", false)

event:SetCallback(function(...: any)
	local args = { ... }
	print(args)
end)

clientEvent:Fire("Poopy")

Toasty.Bootstrap.Toast()
