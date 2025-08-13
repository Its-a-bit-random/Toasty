local singleton = {
	Implements = { "OnStart" },
	LoadOrder = 1,
}

function singleton:OnStart()
	print("Started")
end

return singleton
