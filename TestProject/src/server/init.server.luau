local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Toasty = require(ReplicatedStorage.Packages.Toasty)

Toasty.Networking.SetupFromModule(ReplicatedStorage.Shared.Net)

local Net = require(ReplicatedStorage.Shared.Net)

Net.Functions.MyFunction.Server:SetCallback({
	Toasty.Networking.Arg.string
}, function(player: Player, myString: string)
	return `{player} {myString}`
end)
