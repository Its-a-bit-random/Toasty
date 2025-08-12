local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Toasty = require(ReplicatedStorage.Packages.Toasty)
Toasty.Flags.Enable(Toasty.Flags.Flags.FlatNetworkStructure)
Toasty.Networking.Setup(ReplicatedStorage.Shared.Net)

local Net = require(ReplicatedStorage.Shared.Net)

task.wait(1)

Net.URF.Client
	:Fire({
		Toasty.Networking.Arg.string,
	}, "Hello!")
	:andThen(function(arg: string)
		print(arg)
	end)

Net.URE.Client:Fire("Hello!")
