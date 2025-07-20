local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Toasty = require(ReplicatedStorage.Packages.Toasty)
Toasty.Networking.SetupFromModule(ReplicatedStorage.Shared.Net)

local Net = require(ReplicatedStorage.Shared.Net)

Net.Events.MyEvent.Client:AddCallback(function(...: any)
	print(...)
end)

Net.Events.MyEvent.Client:Fire("Hello", "World")

local prom = Net.Functions.MyFunction.Client:Fire("HelloWorld"):andThen(function(...)
	print(...)
end)

print(prom)
