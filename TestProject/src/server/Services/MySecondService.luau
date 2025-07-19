local Toasty = require(game:GetService("ReplicatedStorage").Packages.Toasty)

local mySecondService = Toasty.Service({
	Implements = { "OnStart" },
})

function mySecondService:OnStart(...)
	local args = { ... }

	print("Started")
	print(args)
end

return mySecondService
