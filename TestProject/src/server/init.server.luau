local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Toasty = require(ReplicatedStorage.Packages.Toasty)
Toasty.Networking.Setup(ReplicatedStorage.Shared.Net)

local Net = require(ReplicatedStorage.Shared.Net)

Net.URF.Server:SetCallback({
	Toasty.Networking.Arg.string,
}, function(player: Player, myString: string)
	return `{player} {myString}`
end)
