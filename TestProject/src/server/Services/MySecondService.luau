local mySecondService = {
	Implements = { "OnStart" },
}

function mySecondService:OnStart(...)
	local args = { ... }

	print("Started")
	print(args)
end

return mySecondService
