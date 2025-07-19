local Toasty = require(game:GetService("ReplicatedStorage").Packages.Toasty)

Toasty.Bootstrap.LoadModules(script.Services, true)
Toasty.Bootstrap.Toast()

local event = Toasty.Networking.ServerEventSender("John", false)
local clientEvent = Toasty.Networking.ServerEventReceiver("JohnClient", false)

clientEvent:SetCallback(function(player: Player, ...: any)
	print(player, ...)
end)

for i = 1, 5, 1 do
	print(i)
	task.wait(1)
end

event:Broadcast("John", "35")
