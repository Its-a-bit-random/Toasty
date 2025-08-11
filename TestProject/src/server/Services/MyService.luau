local myService = {
	Implements = { "OnStart" },
}

function myService:OnStart(...)
	local args = { ... }

	print("Started")
	print(args)
end

return myService
