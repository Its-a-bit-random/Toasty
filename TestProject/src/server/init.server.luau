local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Toasty = require(ReplicatedStorage.Packages.Toasty)
Toasty.Flags.Enable(Toasty.Flags.Flags.FlatNetworkStructure)

Toasty.Networking.Setup(ReplicatedStorage.Shared.Net)
Toasty.Bootstrap.LoadSingletonModules(script.Services, true)

Toasty.Bootstrap.Toast()

local Net = require(ReplicatedStorage.Shared.Net)

Net.URF.Server:SetCallback({
	Toasty.Networking.Arg.string,
}, function(player: Player, myString: string)
	return `{player} {myString}`
end)
