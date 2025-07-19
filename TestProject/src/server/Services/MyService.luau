local Toasty = require(game:GetService("ReplicatedStorage").Packages.Toasty)

local myService = Toasty.Service({
	Implements = { "OnStart" },
})

function myService:OnStart(...)
	local args = { ... }

	print("Started")
	print(args)
end

return myService
