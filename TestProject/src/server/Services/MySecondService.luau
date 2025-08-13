local mySecondService = {
	Implements = { "OnStart" },
	Dependencies = { require(script.Parent.MyService) },
	LoadOrder = 3,
}

function mySecondService:OnStart(...)
	local args = { ... }

	print("Started")
	print(args)
end

return mySecondService
