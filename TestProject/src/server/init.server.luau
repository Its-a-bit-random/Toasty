local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Toasty = require(ReplicatedStorage.Packages.Toasty)

Toasty.Networking.SetupFromModule(ReplicatedStorage.Shared.Net)

local Net = require(ReplicatedStorage.Shared.Net)

Net.Events.MyEvent.Server:AddCallback(function(player, ...: any)
	print(...)
	Net.Events.MyEvent.Server:Fire(player, "Hello", "World")
end)

Net.Functions.MyFunction.Server:SetCallback(function(player: Player, ...: any)
	local args = { ... }
	return player.Name .. " " .. table.concat(args, ", ")
end)
