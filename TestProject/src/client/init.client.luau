local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Toasty = require(ReplicatedStorage.Packages.Toasty)
Toasty.Networking.SetupFromModule(ReplicatedStorage.Shared.Net)

local Net = require(ReplicatedStorage.Shared.Net)

Net.Functions.MyFunction.Client
	:Fire({
		Toasty.Networking.Arg.string
	}, "Hello!")
	:andThen(function(arg: string)
		print(arg)
	end)
