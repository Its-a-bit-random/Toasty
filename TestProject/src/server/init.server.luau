local Toasty = require(game:GetService("ReplicatedStorage").Packages.Toasty)

local onStartLifecycle = Toasty.Lifecycle.Create("OnStart")

local myService = Toasty.Service({
	Implements = { "OnStart" },
})

function myService:OnStart(...)
	local args = { ... }

	print("Started")
	print(args)
end

local mySecondService = Toasty.Service({
	Implements = { "OnStart" },
})

function mySecondService:OnStart(...)
	local args = { ... }

	print("Started")
	print(args)
end

onStartLifecycle.Dispatch("Hello", "World") -- This should work as expected
onStartLifecycle:Dispatch("Hello", "World") -- This should error
