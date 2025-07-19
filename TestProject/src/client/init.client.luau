local Toasty = require(game:GetService("ReplicatedStorage").Packages.Toasty)

local event = Toasty.Networking.ClientEventReciever("John", false)
local clientEvent = Toasty.Networking.ClientEventSender("JohnClient", false)

event:SetCallback(function(...: any)
	local args = { ... }
	print(args)
end)

clientEvent:Fire("Poopy")

Toasty.Bootstrap.Toast()
